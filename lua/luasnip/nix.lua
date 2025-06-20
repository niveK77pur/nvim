return {
    s(
        'module',
        fmta(
            -- snippet {{{
            [[
            {
              lib,
              config,
              ...
            }: let
              cfg = config<path>.<modname>;
            in {
              options<path>.<modname> = {
                enable = lib.mkEnableOption "<modname>";
              };

              config = lib.mkIf cfg.enable {
                  <_end>
              };
            }
            ]],
            --  }}}
            {
                modname = c(1, {
                    p(vim.fn.expand, '%:t:r'),
                    i(1),
                }),
                path = c(2, {
                    t(''),
                    sn(nil, {
                        t('.'),
                        i(1),
                    }),
                }),
                _end = i(0),
            },
            {
                repeat_duplicates = true,
            }
        )
    ),
}

-- vim: fdm=marker
