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
    local match_pattern =
        [[\v(\s+)([abcdefg]{1}%([ie]?s)*)([',]*\=?[',]*)|\ze\<.{-}\>\zs]]
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
        vim.api.nvim_exec(
            ([[s#\v<%s(%%([ie]s)*)#%s%s#gie]]):format(cnote, nnote, accidental),
            false
        )
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
            vim.api.nvim_buf_set_lines(
                buf[window],
                linenr,
                linenr,
                true,
                newlines
            )
        end)
    end
end --  }}}

function _G.EditionEngraverProbeVoices() --  {{{
    local command, edition, measure, moment, context = vim.api
        .nvim_get_current_line()
        :match([[(\editionMod)%s+(%w+)%s+(%d+)%s+(%d+/%d+)%s+(%w+%.Voice)]])
    local probes = { '' }
    for voice in string.gmatch('ABCDEFGHIJKLMNOPQSTUVWXYZ', '%w') do
        table.insert(
            probes,
            string.format(
                [[%s %s %s %s %s.%s -"%s"]],
                command,
                edition,
                measure,
                moment,
                context,
                voice,
                voice
            )
        )
    end
    vim.fn.append('.', probes)
end --  }}}

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Commands
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim.api.nvim_create_user_command('Switch', [[:lua _G.SwitchNotes{<f-args>}]], {
    nargs = '+',
    -- range = true,
    desc = 'Change note into another (i.e. c -> d)',
})

vim.api.nvim_create_user_command(
    'ProbeVoices',
    [[:lua _G.EditionEngraverProbeVoices()]],
    {
        desc = 'Probe all voices A-Z (excluding R) for the edition engraver',
    }
)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Mappings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local nmap = function(LH, RH, args)
    vim.keymap.set('n', LH, RH, args)
end
local imap = function(LH, RH, args)
    vim.keymap.set('i', LH, RH, args)
end

-- Align lines on which the cursor is positioned {{{
for _, align_command in ipairs({ 'zt', 'zz', 'zb' }) do
    nmap(('<LocalLeader>%s'):format(align_command), function()
        local curpos = vim.api.nvim_win_get_cursor(0)
        local curwin = vim.api.nvim_get_current_win()

        local lowestLineNumberInWindows = vim.api.nvim_exec(
            [[
                let s:lineNumbers = []
                windo call add(s:lineNumbers, line("$"))
                echo min(s:lineNumbers)
                unlet s:lineNumbers
            ]],
            true
        )

        vim.api.nvim_exec(
            ('silent windo %d | normal %s'):format(
                math.min(curpos[1], lowestLineNumberInWindows),
                align_command
            ),
            false
        )

        -- cursor moves after the :windo; reset its position
        vim.api.nvim_set_current_win(curwin)
        vim.api.nvim_win_set_cursor(0, curpos)
    end, {
        desc = ('Align windows on current line number (%s)'):format(
            align_command
        ),
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
imap(
    '<LocalLeader>b',
    ([[<C-O>%sb]]):format(vim.g.maplocalleader),
    { remap = true }
)
-- add barline with tie ~ | at the end
nmap('<LocalLeader>B', [[A ~ |<ESC>]])
imap(
    '<LocalLeader>B',
    ([[<C-O>%sB]]):format(vim.g.maplocalleader),
    { remap = true }
)

-- align lines
nmap('<LocalLeader>a', function()
    _G.AlignCursors()
end)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                               Measure Counting
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local measure_count_namespace =
    vim.api.nvim_create_namespace('lilypond-measure-count')

-- namespace highlight groups {{{
do
    local namespace = measure_count_namespace
    vim.api.nvim_set_hl_ns(namespace)
    vim.api.nvim_set_hl(
        namespace,
        'LilypondMeasureCountExtmark',
        { fg = '#88aa88' }
    )
    vim.api.nvim_set_hl(
        namespace,
        'LilypondPolyphony1MeasureCountExtmark',
        { fg = '#aa8888' }
    )
    vim.api.nvim_set_hl(
        namespace,
        'LilypondPolyphony2MeasureCountExtmark',
        { fg = '#8888aa' }
    )
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
        if vim.regex([[\\\\\|\\new\s\+Voice]]):match_str(line) then
            -- new voice started
            if measure > polyphony_start_measure[1].highest_local_measure then
                polyphony_start_measure[1].highest_local_measure = measure
            end
            measure = polyphony_start_measure[1].measure
        end
        if vim.regex([[>>]]):match_str(line) then
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
        if
            not vim.regex([[\%(%[{}]\@!.*\)\@<!\s\+|]]):match_str(line)
            or in_multiline_comment
        then
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
            virt_text = virt_text_layer(
                #polyphony_start_measure,
                measure_string
            ),
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
    local extmarks =
        vim.api.nvim_buf_get_extmarks(0, namespace, 0, -1, { details = true })

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
vim.api.nvim_create_user_command(
    'GotoMeasureCount',
    [[:lua _G.GotoMeasureCount(<f-args>)]],
    {
        nargs = 1,
        desc = 'Jump to a measure with the given count (Requires extmarks to have been set)',
    }
) --  }}}

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                  MIDI Input
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Variables -------------------------------------------------------------------

local callbacks = {
    on_stdout = function(job_id, data, event) --  {{{
        if not (vim.api.nvim_get_mode().mode == 'i') then
            return
        end

        local row, col = unpack(vim.api.nvim_win_get_cursor(0))

        local prev_char_is_space = true
        local next_char_is_space = true
        if col > 0 then
            prev_char_is_space = vim.api
                .nvim_buf_get_text(0, row - 1, col - 1, row - 1, col, {})[1]
                :match('%s')
        end
        if col < vim.api.nvim_get_current_line():len() then
            next_char_is_space = vim.api
                .nvim_buf_get_text(0, row - 1, col, row - 1, col + 1, {})[1]
                :match('%s')
        end

        data = string.format(
            '%s%s%s',
            prev_char_is_space and '' or ' ',
            vim.trim(vim.fn.join(data)),
            next_char_is_space and '' or ' '
        )
        print(
            prev_char_is_space,
            next_char_is_space,
            string.format('>%s<', data),
            col,
            vim.api.nvim_get_current_line():len()
        )

        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { data })
        vim.api.nvim_win_set_cursor(0, { row, col + data:len() + (next_char_is_space and 0 or -1) })
    end, --  }}}
    on_stderr = function(job_id, data, event) --  {{{
        local msg = vim.fn.join(data)
        if not vim.fn.empty(msg) then
            vim.cmd(string.format('echoerr %s', msg))
        end
    end, --  }}}
    on_exit = function(job_id, data, event) --  {{{
        print('MIDI Input Listener exited.')
    end, --  }}}
}

local job_id

-- Commands --------------------------------------------------------------------

vim.api.nvim_create_user_command('MidiInputStart', function()
    if job_id then
        print('A MIDI Input Listener is already running.')
        return
    end
    job_id = vim.fn.jobstart({
        'python',
        '-u',
        vim.fn.stdpath('config') .. '/scripts/MidiInputListener.py',
    }, callbacks)
end, { desc = 'Start MIDI Input Listener' })

vim.api.nvim_create_user_command('MidiInputStop', function()
    if job_id then
        vim.fn.jobstop(job_id)
    end
end, { desc = 'Stop MIDI Input Listener' })

-- AutoCommands ----------------------------------------------------------------
--
local augroup_midideviceinput =
    vim.api.nvim_create_augroup('midideviceinput', {})

vim.api.nvim_create_autocmd({ 'ExitPre', 'QuitPre' }, {
    group = augroup_midideviceinput,
    pattern = { '*' },
    desc = 'Quit the MIDI Input Listener',
    callback = function()
        if job_id then
            vim.fn.jobstop(job_id)
        end
    end,
})

-- vim: fdm=marker
