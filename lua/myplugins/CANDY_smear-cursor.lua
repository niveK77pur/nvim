return {
    'sphamba/smear-cursor.nvim',
    enable = true,
    opts = {
        legacy_computing_symbols_support = true,
        smear_insert_mode = false,

        -- 🔥 Faster smear
        stiffness = 0.8,
        trailing_stiffness = 0.5,
        stiffness_insert_mode = 0.7,
        trailing_stiffness_insert_mode = 0.7,
        damping = 0.8,
        damping_insert_mode = 0.8,
        distance_stop_animating = 0.5,
    },
}
