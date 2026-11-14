#!/usr/bin/env bash

set -eu

action=${1:-toggle}
window=${2:?A tmux window ID is required}

# Serialize key presses and resize hooks for this window.
lock="center-pane-$window"
tmux wait-for -L "$lock"
trap 'tmux wait-for -U "$lock"' EXIT

if ! tmux display-message -p -t "$window" '#{window_id}' >/dev/null 2>&1; then
    exit 0
fi

get_option() {
    tmux show-options -wqv -t "$window" "$1"
}

find_panes() {
    left=
    main=
    right=
    pane_count=0

    while read -r pane role; do
        pane_count=$((pane_count + 1))
        case "$role" in
            left) left=$pane ;;
            main) main=$pane ;;
            right) right=$pane ;;
        esac
    done < <(tmux list-panes -t "$window" -F '#{pane_id} #{@center_role}')
}

disable_centering() {
    find_panes

    # Only remove panes that this helper marked as margins.
    for pane in "$left" "$right"; do
        if [[ -n "$pane" ]]; then
            tmux kill-pane -t "$pane"
        fi
    done

    # The application may have exited, leaving only the margin panes behind.
    if ! tmux display-message -p -t "$window" '#{window_id}' >/dev/null 2>&1; then
        return
    fi

    if [[ -n "$main" ]]; then
        tmux set-option -pu -t "$main" @center_role
        tmux select-pane -t "$main"
    fi

    saved_border=$(get_option @center_saved_border)
    if [[ -n "$saved_border" ]]; then
        tmux set-option -w -t "$window" pane-border-lines "$saved_border"
    else
        tmux set-option -wu -t "$window" pane-border-lines
    fi

    tmux set-option -wu -t "$window" @center_saved_border
    for option in pane-border-style pane-active-border-style; do
        saved_style=$(get_option "@center_saved_$option")
        if [[ "$saved_style" == inherit ]]; then
            tmux set-option -wu -t "$window" "$option"
        elif [[ -n "$saved_style" ]]; then
            tmux set-option -w -t "$window" "$option" "$saved_style"
        fi
        tmux set-option -wu -t "$window" "@center_saved_$option"
    done
    tmux set-option -wu -t "$window" @center_active
}

resize_centering() {
    find_panes
    if [[ "$pane_count" -ne 3 || -z "$left" || -z "$main" || -z "$right" ]]; then
        disable_centering
        return
    fi

    width=$(tmux display-message -p -t "$window" '#{window_width}')
    target=$(tmux show-options -wAqv -t "$window" @center_width)
    if [[ ! "$target" =~ ^[0-9]+$ ]] || (( target < 1 )); then
        target=110
    fi

    # Each margin needs one column, plus one column for each border.
    if (( width < 5 )); then
        disable_centering
        return
    fi
    if (( target > width - 4 )); then
        target=$((width - 4))
    fi

    left_width=$(((width - target - 2) / 2))
    right_width=$((width - target - 2 - left_width))

    # Reset first so resizing either margin has room to borrow from its neighbor.
    tmux select-layout -t "$window" even-horizontal >/dev/null
    tmux resize-pane -t "$left" -x "$left_width"
    tmux resize-pane -t "$right" -x "$right_width"
    tmux select-pane -t "$main"
}

active=$(get_option @center_active)

if [[ "$action" == resize ]]; then
    if [[ "$active" == 1 ]]; then
        resize_centering
    fi
    exit 0
fi

if [[ "$active" == 1 ]]; then
    disable_centering
    exit 0
fi

find_panes
if [[ "$pane_count" -ne 1 ]]; then
    tmux display-message 'Centered mode needs a window with one pane'
    exit 0
fi

width=$(tmux display-message -p -t "$window" '#{window_width}')
if (( width < 5 )); then
    tmux display-message 'This window is too narrow for centered mode'
    exit 0
fi

main=$(tmux list-panes -t "$window" -F '#{pane_id}')
saved_border=$(get_option pane-border-lines)
tmux set-option -w -t "$window" @center_saved_border "$saved_border"
tmux set-option -w -t "$window" @center_active 1
tmux set-option -p -t "$main" @center_role main

# Empty commands create blank panes without starting extra shell processes.
if left=$(tmux split-window -h -b -d -l 1 -t "$main" -P -F '#{pane_id}' ''); then
    tmux set-option -p -t "$left" @center_role left
else
    disable_centering
    exit 1
fi

if right=$(tmux split-window -h -d -l 1 -t "$main" -P -F '#{pane_id}' ''); then
    tmux set-option -p -t "$right" @center_role right
else
    disable_centering
    exit 1
fi

tmux set-option -w -t "$window" pane-border-lines spaces

margin_background=$(tmux show-options -wAqv -t "$window" @center_margin_background)
margin_background=${margin_background:-#293136}

for pane in "$left" "$right"; do
    tmux set-option -p -t "$pane" window-style "bg=$margin_background"
    tmux set-option -p -t "$pane" window-active-style "bg=$margin_background"
done

# Match the hidden dividers to the margins and remember their previous styles.
for option in pane-border-style pane-active-border-style; do
    saved_style=$(get_option "$option")
    tmux set-option -w -t "$window" "@center_saved_$option" "${saved_style:-inherit}"
    tmux set-option -w -t "$window" "$option" "bg=$margin_background"
done

resize_centering
