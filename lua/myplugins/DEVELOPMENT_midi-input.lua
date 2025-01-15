return {
    'niveK77pur/midi-input.nvim',
    enabled = true,
    ft = { 'lilypond' },
    cmd = { 'MidiInputStart' },
    opts = {
        device = 'USB-MIDI MIDI 1',
        mode = 'pedal-chord',
        -- replace_q = true,
        -- replace_in_comment = true,
        -- debug = 'replace mode',
        accidentals = 'sharps',
        -- key = 'besM',
        -- alterations = {
        --     ['0'] = 'YO',
        --     ['4'] = 'BYE',
        -- },
        -- global_alterations = '80:SIKE',
    },
}
