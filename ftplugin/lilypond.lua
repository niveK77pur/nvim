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
    local replace = ( [[\=empty(submatch(2)) ? '' : submatch(1).'<'.submatch(2).submatch(3).' '.submatch(2)."%s".'>']] ):format(pitch)
    vim.api.nvim_exec(( [[s#%s#%s#g]] ):format(match_pattern, replace), false)
    print('done pitching')
end -- }}}

function _G.SwitchNotes(notelist) -- {{{
  if #notelist%2 ~= 0 then
    print("Needs pair of notes (i.e. multiples of 2)")
    return 1
  end

  for _,i in ipairs(vim.fn.range(1,#notelist,2)) do
    local cnote, nnote = notelist[i], notelist[i+1]
    --[[ {{{
        If first note of pair (cnote) is upper case, then have the accidental removed.
          i.e. _G.SwitchNotes{'A','b'} : ais -> b
        If lower case, then keep the accidentals.
          i.e. _G.SwitchNotes{'a','b'} : ais -> bis
    --}}} ]]
    local accidental = (cnote == cnote:upper()) and '' or [[\1]]
    vim.api.nvim_exec(([[s#\v<%s(%%([ie]s)*)#%s%s#gie]]):format(cnote,nnote,accidental),false)
  end
end -- }}}

function _G.AlignCursors() --  {{{
    local windows = vim.api.nvim_tabpage_list_wins(0)
    local curpos, curwin = {}, {}
    local buf = {}
    for _,window in ipairs(windows) do
        local cursor = vim.api.nvim_win_get_cursor(window)[1]
        table.insert(curpos, cursor)
        curwin[window] = cursor
        buf[window] = vim.api.nvim_win_get_buf(window)
    end
    -- subtract 1 to operate on previous line (i.e. insert on line above)
    local maxpos = vim.fn.max(curpos) - 1
    for _,window in ipairs(windows) do
        vim.api.nvim_win_call(window, function()
            local linenr = curwin[window] - 1
            local newlines = {}
            for _=1,(maxpos - linenr),1 do
                table.insert(newlines,'')
            end
            vim.api.nvim_buf_set_lines(buf[window], linenr, linenr, true, newlines)
        end)
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

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Mappings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end
local imap = function(LH, RH, args) vim.keymap.set('i', LH, RH, args) end

-- Align lines on which the cursor is positioned {{{
for _,align_command in ipairs{ 'zt','zz','zb' } do
    nmap(('<LocalLeader>%s'):format(align_command), function()

            local curpos = vim.api.nvim_win_get_cursor(0)
            local curwin = vim.api.nvim_get_current_win()

            local lowestLineNumberInWindows = vim.api.nvim_exec([[
                let s:lineNumbers = []
                windo call add(s:lineNumbers, line("$"))
                echo min(s:lineNumbers)
                unlet s:lineNumbers
            ]], true)

            vim.api.nvim_exec(('silent windo %d | normal %s'):format(
                math.min(curpos[1], lowestLineNumberInWindows),
                align_command
            ), false)

            -- cursor moves after the :windo; reset its position
            vim.api.nvim_set_current_win(curwin)
            vim.api.nvim_win_set_cursor(0, curpos)

        end, {
        desc = ('Align windows on current line number (%s)'):format(align_command)
    })
end -- }}}

-- make octaves (relative pitch)
nmap('<LocalLeader>mo', [[:call v:lua.MakeOctave("'")<CR>]])
nmap('<LocalLeader>mO', [[:call v:lua.MakeOctave(",")<CR>]])

-- add fingerings (<LocalLeader>{12345}) {{{
for i = 1,5 do
    nmap(
      ('<LocalLeader>%d'):format(i),
      (':normal! a-%d<ESC>E'):format(i),
      { desc = ('Insert fingering (-%d)'):format(i) }
    )
end
-- }}}

-- add barline | at the end
nmap('<LocalLeader>b', [[A |<ESC>]])
imap('<LocalLeader>b', ([[<C-O>%sb]]):format(vim.g.maplocalleader), {remap=true})

-- align lines
nmap('<LocalLeader>a', function() _G.AlignCursors() end)


-- vim: fdm=marker
