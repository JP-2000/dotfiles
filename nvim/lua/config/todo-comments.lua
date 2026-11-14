local M = {}

function M.setup()
	local highlight = require("todo-comments.highlight")
	local config = require("todo-comments.config")
	local original_highlight = highlight.highlight

	highlight.highlight = function(buf, first, last, event)
		original_highlight(buf, first, last, event)

		local opts = config.options.highlight
		if not vim.api.nvim_buf_is_valid(buf) or not opts.multiline or highlight.is_quickfix(buf) then
			return
		end
		if opts.after ~= "fg" and opts.after ~= "bg" then
			return
		end

		local lines = vim.api.nvim_buf_get_lines(buf, 0, last + 1, false)

		local function marker(row)
			local start, _, keyword = highlight.match(lines[row])
			if start and highlight.is_comment(buf, row - 1, start - 1) then
				return start - 1, keyword
			end
		end

		local function is_comment(row)
			local start = lines[row]:find("%S")
			return start and highlight.is_comment(buf, row - 1, start - 1)
		end

		-- Find the marker even when it is above the redraw range or viewport.
		local from = math.min(first + 1, #lines)
		while from > 1 do
			if marker(from) or not is_comment(from) then
				break
			end
			from = from - 1
		end

		local column, keyword
		for row = from, #lines do
			local start, matched_keyword = marker(row)
			if start then
				column, keyword = start, matched_keyword
			elseif not is_comment(row) then
				column, keyword = nil, nil
			elseif keyword and row > first and #lines[row] > column then
				-- Check the comment delimiter, not the marker column: bare // lines are shorter.
				local group = opts.after == "fg" and "TodoFg" or "TodoBg"
				vim.api.nvim_buf_set_extmark(buf, config.ns, row - 1, column, {
					end_col = #lines[row],
					hl_group = group .. keyword,
					priority = 500,
				})
			end
		end
	end
end

return M
