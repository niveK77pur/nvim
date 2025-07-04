vim.bo.commentstring = '% %s'
vim.opt.comments:remove('://')
vim.opt.comments:remove('b:#')
vim.bo.tabstop = 2
vim.wo.relativenumber = false
vim.wo.number = true
vim.wo.cursorline = true

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Functions
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function _G.MakeOctave(pitch) -- {{{
    local match_pattern = [[\v(\s+)([abcdefg]{1}%([ie]?s)*)([',]*\=?[',]*)|\ze\<.{-}\>\zs]]
    local replace = ([[\=empty(submatch(2)) ? '' : submatch(1).'<'.submatch(2).submatch(3).' '.submatch(2)."%s".'>']]):format(
        pitch
    )
    vim.api.nvim_exec(([[s#%s#%s#g]]):format(match_pattern, replace), false)
    print('done pitching')
end -- }}}

function _G.SwitchNotes(notelist) -- {{{
    if #notelist % 2 ~= 0 then
        print('Needs pair of notes (i.e. multiples of 2)')
        return 1
    end

    for _, i in ipairs(vim.fn.range(1, #notelist, 2)) do
        local cnote, nnote = notelist[i], notelist[i + 1]
        --[[ {{{
        If first note of pair (cnote) is upper case, then have the accidental removed.
          i.e. _G.SwitchNotes{'A','b'} : ais -> b
        If lower case, then keep the accidentals.
          i.e. _G.SwitchNotes{'a','b'} : ais -> bis
    --}}} ]]
        local accidental = (cnote == cnote:upper()) and '' or [[\1]]
        vim.api.nvim_exec(([[s#\v<%s(%%([ie]s)*)#%s%s#gie]]):format(cnote, nnote, accidental), false)
    end
end -- }}}

function _G.AlignCursors() --  {{{
    local windows = vim.api.nvim_tabpage_list_wins(0)
    local curpos, curwin = {}, {}
    local buf = {}
    for _, window in ipairs(windows) do
        local cursor = vim.api.nvim_win_get_cursor(window)[1]
        table.insert(curpos, cursor)
        curwin[window] = cursor
        buf[window] = vim.api.nvim_win_get_buf(window)
    end
    -- subtract 1 to operate on previous line (i.e. insert on line above)
    local maxpos = vim.fn.max(curpos) - 1
    for _, window in ipairs(windows) do
        vim.api.nvim_win_call(window, function()
            local linenr = curwin[window] - 1
            local newlines = {}
            for _ = 1, (maxpos - linenr), 1 do
                table.insert(newlines, '')
            end
            vim.api.nvim_buf_set_lines(buf[window], linenr, linenr, true, newlines)
        end)
    end
end --  }}}

function _G.EditionEngraverProbeVoices() --  {{{
    local command, edition, measure, moment, context =
        vim.api.nvim_get_current_line():match([[(\editionMod)%s+(%w+)%s+(%d+)%s+(%d+/%d+)%s+(%w+%.%w+)]])
    local probes = { '' }
    for voice in string.gmatch('ABCDEFGHIJKLMNOPQSTUVWXYZ', '%w') do
        table.insert(
            probes,
            string.format([[%s %s %s %s %s.%s -"%s"]], command, edition, measure, moment, context, voice, voice)
        )
    end
    local curr_linenr = vim.api.nvim_win_get_cursor(0)[1]
    local next_line = vim.api.nvim_buf_get_lines(0, curr_linenr, curr_linenr + 1, false)[1]
    if vim.fn.empty(next_line) == 0 then
        -- insert blank line for easy delition with dap
        table.insert(probes, '')
    end
    vim.api.nvim_buf_set_lines(0, curr_linenr, curr_linenr, false, probes)
end --  }}}

---Collect, sort and regroup all `\editionMod` statements at the end of the file
function _G.EditionEngraverSortStatements() --  {{{
    ---@class (exact) EditionMod
    ---@field ln_start number? Start line number of statement
    ---@field ln_end number? End line number of statement
    ---@field lines string[] Lines of the statement
    ---@field name string? Name of the edition
    ---@field measure number? Measure number of the edition

    ---@type EditionMod[]
    local edition_mods = {}
    ---@type boolean Needed to track multi-line `\editionMod`
    local in_block
    ---@type boolean Needed to track empty lines after `\editionMod`
    local after_block = false
    for i, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, true)) do
        local name, measure = line:match([[^%s*\editionMod%s+([A-Za-z-]+)%s+(%d+)]])
        local line_nr = i - 1
        if name ~= nil and measure ~= nil then
            table.insert(edition_mods, {
                ln_start = line_nr,
                ln_end = line_nr + 1,
                lines = { line },
                name = name,
                measure = tonumber(measure),
            })
            if line:match('{') then
                in_block = true
                after_block = false
            else
                in_block = false
                after_block = true
            end
        end
        local last_edition = edition_mods[#edition_mods]
        if in_block and line_nr > last_edition.ln_start then
            -- do not include the lin
            table.insert(last_edition.lines, line)
        end
        if in_block and line:match('}') then
            in_block = false
            after_block = true
            last_edition.ln_end = line_nr + 1
        end
        -- also keep track of trailing empty lines
        if after_block and line_nr >= last_edition.ln_end then
            if vim.fn.empty(vim.trim(line)) == 1 then
                last_edition.ln_end = line_nr + 1
            else
                -- we hit a non-empty line which was not a `\editionMod`
                after_block = false
            end
        end
    end
    -- Remove the `\editionMod` statements.
    -- List needs to be reversed, as otherwise the line numbers after
    -- deleted lines will be incorrect. So we essentially go bottom to top.
    for _, entry in ipairs(vim.fn.reverse(edition_mods)) do
        vim.api.nvim_buf_set_lines(0, entry.ln_start, entry.ln_end, true, {})
    end
    -- Sort the `\editionMod`
    edition_mods = vim.fn.sort(edition_mods, function(a, b)
        if a.measure == b.measure then
            if a.name == b.name then
                return 0
            else
                return a.name > b.name and 1 or -1
            end
        end
        return a.measure > b.measure and 1 or -1
    end)
    -- Regroup the `\editionMod` statemnts by paragraphs
    local prev_measure = edition_mods[1].measure
    for i, entry in ipairs(edition_mods) do
        local curr_measure = entry.measure
        if prev_measure ~= curr_measure then
            prev_measure = curr_measure
            table.insert(edition_mods, i, { lines = { '' } })
        end
    end
    -- Put the `\editionMod` statements at the end of the file
    for _, edition in ipairs(edition_mods) do
        vim.api.nvim_buf_set_lines(0, -1, -1, true, edition.lines)
    end
end --  }}}

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Commands
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim.api.nvim_create_user_command('Switch', [[:lua _G.SwitchNotes{<f-args>}]], {
    nargs = '+',
    -- range = true,
    desc = 'Change note into another (i.e. c -> d)',
})

vim.api.nvim_create_user_command('ProbeVoices', [[:lua _G.EditionEngraverProbeVoices()]], {
    desc = 'Probe all voices A-Z (excluding R) for the edition engraver',
})

vim.api.nvim_create_user_command('SortEditionMod', [[:lua _G.EditionEngraverSortStatements()]], {
    desc = [[Collect, sort and regroup all `\editionMod` statements at the end of the file]],
})

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Mappings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local nmap = function(LH, RH, args)
    vim.keymap.set('n', LH, RH, args)
end

-- Align lines on which the cursor is positioned {{{
for _, align_command in ipairs({ 'zt', 'zz', 'zb' }) do
    nmap(('<LocalLeader>%s'):format(align_command), function()
        local curpos = vim.api.nvim_win_get_cursor(0)
        local curwin = vim.api.nvim_get_current_win()

        local window_buffer_ids = vim.tbl_filter(function(win)
            -- filter out windows without buffer attached
            local buf = vim.api.nvim_win_get_buf(win)
            local res, bufname = pcall(vim.api.nvim_buf_get_name, buf)
            return res and (vim.fn.empty(bufname) == 0)
        end, vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage()))

        local lowestLineNumberInWindows = math.min(unpack(vim.tbl_map(function(win)
            return vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(win))
        end, window_buffer_ids)))

        for _, win in ipairs(window_buffer_ids) do
            vim.api.nvim_win_set_cursor(win, { math.min(curpos[1], lowestLineNumberInWindows), 0 })
            vim.api.nvim_set_current_win(win)
            vim.api.nvim_cmd({ cmd = 'normal', args = { align_command }, bang = true }, {})
        end

        vim.api.nvim_set_current_win(curwin)
        vim.api.nvim_win_set_cursor(0, curpos)
    end, {
        desc = ('Align windows on current line number (%s)'):format(align_command),
    })
end -- }}}

-- make octaves (relative pitch)
nmap('<LocalLeader>mo', [[:call v:lua.MakeOctave("'")<CR>]])
nmap('<LocalLeader>mO', [[:call v:lua.MakeOctave(",")<CR>]])

-- add fingerings (<LocalLeader>{12345}) {{{
for i = 1, 5 do
    nmap(
        ('<LocalLeader>%d'):format(i),
        (':normal! a-%d<ESC>E'):format(i),
        { desc = ('Insert fingering (-%d)'):format(i) }
    )
end
-- }}}

-- add barline | at the end
nmap('<LocalLeader>b', [[A |<ESC>]])
-- add barline with tie ~ | at the end
nmap('<LocalLeader>B', [[A ~ |<ESC>]])

-- align lines
nmap('<LocalLeader>a', function()
    _G.AlignCursors()
end)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                               Measure Counting
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local measure_count_namespace = vim.api.nvim_create_namespace('lilypond-measure-count')

-- namespace highlight groups {{{
do
    local namespace = measure_count_namespace
    vim.api.nvim_set_hl_ns(namespace)
    vim.api.nvim_set_hl(namespace, 'LilypondMeasureCountExtmark', { fg = '#88aa88' })
    vim.api.nvim_set_hl(namespace, 'LilypondPolyphony1MeasureCountExtmark', { fg = '#aa8888' })
    vim.api.nvim_set_hl(namespace, 'LilypondPolyphony2MeasureCountExtmark', { fg = '#8888aa' })
end --  }}}

local function virt_text_layer(layer, measure_string) --  {{{
    -- retrieve 'virt_text' for a given layer
    if layer == 0 then
        return {
            { '󰽰 ', 'LilypondMeasureCountExtmark' },
            { measure_string, 'LilypondMeasureCountExtmark' },
        }
    elseif layer == 1 then
        return {
            { '󰽯 ', 'LilypondPolyPhony1MeasureCountExtmark' },
            { measure_string, 'LilypondPolyPhony1MeasureCountExtmark' },
        }
    else
        return {
            { '󰽮 ', 'LilypondPolyphony2MeasureCountExtmark' },
            { measure_string, 'LilypondPolyphony2MeasureCountExtmark' },
        }
    end
end --  }}}

function _G.SetMeasureCounts() --  {{{
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
    local namespace = measure_count_namespace

    vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)

    local measure = 0
    -- stack which stores the measure count before entering a polyphonic passage.
    -- size of stack also indicates current layer.
    local polyphony_start_measure = {}
    local in_multiline_comment = false
    -- for multi-line comments starting after a barline
    local next_line_comment = false

    for i, line in ipairs(lines) do
        -- check for start of a new music block
        if vim.regex([[\v\\relative|\\absolute]]):match_str(line) then
            measure = 0
        end
        -- check for polyphonic passages
        if vim.regex([[<<]]):match_str(line) then
            -- polyphony started
            table.insert(polyphony_start_measure, 1, {
                measure = measure,
                -- polyphony with uneven measures in each voice, will still
                -- have lilypond continue with the latest measure number. This
                -- field will track the highest measure number among all
                -- voices.
                highest_local_measure = measure,
            })
        end
        if vim.regex([[\\\\\|\\new\s\+Voice]]):match_str(line) and polyphony_start_measure[1] then
            -- new voice started
            if measure > polyphony_start_measure[1].highest_local_measure then
                polyphony_start_measure[1].highest_local_measure = measure
            end
            measure = polyphony_start_measure[1].measure
        end
        if vim.regex([[>>]]):match_str(line) and polyphony_start_measure[1] then
            -- polyphony ended
            if measure < polyphony_start_measure[1].highest_local_measure then
                measure = polyphony_start_measure[1].highest_local_measure
            end
            table.remove(polyphony_start_measure, 1)
        end

        -- check for multi-line comments
        in_multiline_comment = next_line_comment
        if vim.regex([[%{.*|]]):match_str(line) then
            in_multiline_comment = true
            next_line_comment = true
        end
        if in_multiline_comment and vim.regex([[%}.*|]]):match_str(line) then
            in_multiline_comment = false
            next_line_comment = false
        end
        if vim.regex([[%{]]):match_str(line) then
            next_line_comment = true
        end
        if vim.regex([[%}]]):match_str(line) then
            next_line_comment = false
        end

        -- do not set extmark if not on a barline
        -- and if barline is inside single-line comment
        if not vim.regex([[\%(%[{}]\@!.*\)\@<!\s\+|]]):match_str(line) or in_multiline_comment then
            goto continue
        end

        -- count barlines and check if there is a multiplier
        -- (i.e. 's1*5 |' or 's4*4*5 |' both count 5 bars)
        local measure_inc = 0
        local barlines = vim.split(line, [[|]])
        for _, barline in ipairs({ unpack(barlines, 1, #barlines - 1) }) do
            measure_inc = measure_inc + (barline:match('*(%d+)%s$') or 1)
        end

        -- allow manually setting measure using '| % M.XXX'
        local specified_measure = line:match([[|%s+%%%s+[mM]%.(%d+)]])
        if specified_measure then
            measure = specified_measure
        else
            measure = measure + measure_inc
        end

        local measure_string = string.format([[%d]], measure)
        local line_nr = i - 1

        vim.api.nvim_buf_set_extmark(0, namespace, line_nr, 0, {
            virt_text = virt_text_layer(#polyphony_start_measure, measure_string),
            virt_text_pos = 'right_align',
            hl_mode = 'combine',
        })

        ::continue::
    end
end --  }}}

function _G.GotoMeasureCount(barline_input) --  {{{
    -- Jump to a barline given a measure. Jumps based on measure counts
    -- produced by extmarks from `_G.SetMeasureCounts`.
    local barline = tonumber(barline_input)
    local namespace = measure_count_namespace
    local extmarks = vim.api.nvim_buf_get_extmarks(0, namespace, 0, -1, { details = true })

    for i = 1, #extmarks - 1 do
        local extmark = extmarks[i]
        local next_extmark = extmarks[i + 1]

        local measure, next_measure
        do
            local _, line_nr, _, details = unpack(extmark)
            local virt_text = details.virt_text
            measure = {
                barline = tonumber(virt_text[#virt_text][1]),
                line_nr = line_nr,
            }
        end
        do
            local _, line_nr, _, details = unpack(next_extmark)
            local virt_text = details.virt_text
            next_measure = {
                barline = tonumber(virt_text[#virt_text][1]),
                line_nr = line_nr,
            }
        end

        if barline > measure.barline and barline <= next_measure.barline then
            vim.api.nvim_win_set_cursor(0, { next_measure.line_nr + 1, 0 })
        end
    end
end -- }}}

-- automatically update/set/clear extmarks {{{
local augroup_measure_count = vim.api.nvim_create_augroup('measure_count', {})

vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'InsertLeave' }, {
    group = augroup_measure_count,
    pattern = { '*.ly' },
    desc = 'Set/Update measure count virtual text',
    callback = _G.SetMeasureCounts,
})

vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
    group = augroup_measure_count,
    pattern = { '*.ly' },
    desc = 'Clear measure count virtual text upon entering insert mode',
    callback = function()
        local namespace = measure_count_namespace
        vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
    end,
})
--  }}}

-- GotoMeasureCount command {{{
vim.api.nvim_create_user_command('GotoMeasureCount', [[:lua _G.GotoMeasureCount(<f-args>)]], {
    nargs = 1,
    desc = 'Jump to a measure with the given count (Requires extmarks to have been set)',
}) --  }}}

-- vim: fdm=marker
