# Installing

Clone this repo into `~/.config/nvim` and simply launch neovim. The first time around, it will install all the plugins specified using [packer.nvim][packer].

# Plugins

Plugins are managed using [packer.nvim][packer]. An interesting features is the [`config`](https://github.com/wbthomason/packer.nvim#specifying-plugins) specification, which allows to run code after the plugin has been loaded. This is where I put any plugin related configurations. Hence the plugins and their configurations reside in one single place.

# Cool things in my config

## Quickly edit config files

## Navigation

### Windows

Use `ALT+{hjkl}` to nagivate the open windows. Works from normal, insert and terminal mode!

### Tabs

Use `ALT+{,.}` to cycle through the tabs. Works from normal, insert and terminal mode!

### Insert mode

Use `ALT+{hjkl}` to move the cursor in insert mode. Useful for small movements ~~or if you are too lazy to go to normal mode~~.

## Headers

## Lilypond


# About this repository

Actually, I already have a [.vim config][77pur-vim] built, expanded and tinkered on for 5 years (Looking at the commit history on GitHub, the first commit was Aug 13, 2017 and the last one was Aug 28, 2022). Given how long this config has been with me, I was always extremely hesitant to make he jump to Lua; especially in light of the the many tweaks, mappings and functions that I wrote over the years.

I rarely use Vim anymore &mdash; these days I'm only using NeoVim. Also, if I need to work on a remote server that does not have NeoVim installed, it seems to [ship as an AppImage][nvim-appimage] as well. So technically speaking nothing was holding me back.

The thing that pushed me to finally do the switch is that my original Vim config is extremely bloated with a ton of things I practically never use anymore (which counts ultra specific mappings and functions and commands and whatnot). I did put everything accordingly into `ftplugin` files to avoid it all being a mess, but somehow things felt wonky lately. So I thought a fresh start might do good afterall.

It almost feels like I am betraying Vim by leaving VimScript for Lua, but [packer.nvim][packer] quickly convinced me otherwise.It is quite a bliss actually to rewrite my config in Lua &mdash; or at least those parts that I still need. 😛


[77pur-vim]: https://github.com/niveK77pur/.vim
[packer]: https://github.com/wbthomason/packer.nvim
[nvim-appimage]: https://github.com/neovim/neovim/wiki/Installing-Neovim#appimage-universal-linux-package
