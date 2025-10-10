return {
    s(
        'module',
        fmta(
            -- snippet {{{
            [[
            {
              lib,
              config,<inputs>
              ...
            }: let
              cfg = config<path>.<modname>;
            in {
              <imports>

              options<path>.<modname> = {
                enable = lib.mkEnableOption "<modname>";
              };

              config = lib.mkIf cfg.enable {
                  <conf><_end>
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
                inputs = c(3, {
                    i(1),
                    t('pkgs,'),
                }),
                imports = c(4, {
                    t(''),
                    t({
                        'imports = lib.fileset.toList (',
                        'lib.fileset.fileFilter',
                        '(file: (file.hasExt "nix") && (file.name != "default.nix"))',
                        './.',
                        ');',
                    }),
                    sn(1, {
                        t('imports = ['),
                        i(1),
                        t('];'),
                    }),
                }),
                conf = c(5, {
                    i(1),
                    sn(1, {
                        t('home.packages = ['),
                        i(1),
                        t('];'),
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
