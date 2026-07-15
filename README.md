# Jonathan Dexter's config files

Prior art:

- [elenapan's dotfiles](https://github.com/elenapan/dotfiles)
- [typicons.font](https://github.com/stephenhutchings/typicons.font)
- [spicetify](https://github.com/khanhas/spicetify-cli)

## What's in here?

This is my setup for a bunch of things. It includes:

- Windows Manager setup (awesome)
- Neovim
- zsh
- A lot of other tools: `rg`, `fuck`, `ncmpcpp`, `mopidy`, `kitty`, `cava`, `git [COMMANDS]`, and more

## Nix / home-manager (Linux + WSL)

This repo exports a single reusable home-manager module,
`homeManagerModules.default`. It links these files live from `~/src/dotfiles`
via `mkOutOfStoreSymlink` (edit in place, no rebuild) and is split into
category toggles: `shell git scripts hyprland x11 sway terminal editor browser
media`, plus `cursor.*` and a `headless` convenience flag.

Import it from a consumer flake (see `../nixos` for the full workstation
example) and enable what that machine needs:

```nix
# Arch / workstation desktop
dotfiles = { enable = true; username = "jonathan"; x11 = true; };

# NixOS-WSL (headless) — `headless` turns the GUI categories off by default;
# anything you set explicitly still wins.
dotfiles = { enable = true; username = "jonathan"; headless = true; };
```

The WSL *system* layer (`wsl.enable`, flakes, user) lives in the consumer flake,
not here — this repo stays home-manager-only.

## Windows (neovim, windows-terminal)

Nix can't run on native Windows, so those configs are symlinked into place by a
PowerShell bootstrap. From an admin shell (or with Developer Mode on):

```powershell
pwsh -ExecutionPolicy Bypass -File .\windows\bootstrap.ps1
```

It links `.config/nvim` → `%LOCALAPPDATA%\nvim` and the terminal settings, and
refuses to overwrite real (non-symlink) files.

The Neovim config also needs a toolchain that Nix provides on Linux/WSL but
native Windows lacks: the `tree-sitter` CLI + `gcc` (parser compilation) and the
`node`/`python`/`go` runtimes (Mason LSP servers). Install them in one shot with
`-InstallDeps` (uses [scoop](https://scoop.sh)), then restart your terminal so
the new PATH takes effect:

```powershell
pwsh -ExecutionPolicy Bypass -File .\windows\bootstrap.ps1 -InstallDeps
# equivalent to: scoop install tree-sitter gcc nodejs-lts python go
```

The Nix language server (`nil_ls`) is intentionally skipped on Windows.

## Awesome WM configuration

First of all, update configuration located at `~/.config/awesome/rc.lua`. The vast majority of settings are included there.

## Prep

- Copy a profile picture to `~/profile.png`
- Install required items below
- Type `{Superkey}+?` to view hotkey options
  - On windows, the superkey is the windows button

## Other tools

Other tools can be found under `bin/`. These tools should be executable, and allow for some things I find helpful, for example sound switching and network switching via `rofi`.

### Dependancies (required)

**Supporting Libraries**

- lub-pam-git (allows usage of lock screen passwords, provided `liblua.so` is in path - eg. in `/usr/lib`)

**Default Programs from rc.lua**
_Note: You do not need to select these, but if you do not, you will have to change default programs in `rc.lua`_

- Terminal: [kitty](https://sw.kovidgoyal.net/kitty/)
- Browser: [firefox](https://firefox.com)
- Chat: [slack](https://slack.com)
- Email: [wavebox](https://wavebox.io)
- Backgrounds: [feh](https://wiki.archlinux.org/title/Feh)
- Quick Launcher: [rofi](https://github.com/davatorium/rofi)
  - _Optional_: [rofi-calc]() for quick calculations
  - _Optional_: [rofi-emoji]() for quick emojis

**Dashboard Support**
| Name | Description | Notes |
|-----------------------------------------------------------|--------------------------------------|---------------------------------------------------------|
| [gh](https://cli.github.com/) | Github Command line access | Run `gh auth login` after install
| [gcalcli](https://github.com/insanum/gcalcli) | Google Calendar Agenda | Update `.gcalclirc` with appropriate client ID + secret |
| [fortune](http://www.linux-commands-examples.com/fortune) | Random fortunes | |
| [redshift](https://wiki.archlinux.org/title/Redshift) | Shift monitor to red colors at night | |
| [jq](https://stedolan.github.io/jq/) | JQ quick command line parsing | |

### Dependencies (optional)

**Window Compositor**
_Note: This will make things look better_

- picom

**System Tools**

- htop
- ranger
- nsxiv
- maim
- xrandr
  - arandr
  - autorandr

**Editor(s)**

- Neovim
- JetBrains
  - Rider
  - DataGrip
  - WebStorm

**Music + Audio**

- pulseaudio
  - pavucontrol
- mopidy
  - mopidy-mpd
  - mopidy-spotify
- ncmpcpp
- cava

**Video**

- yewtube
- mpv

**Apps**
_Note: Many apps have hotkeys. Check out `apps.lua` and `keys.lua` to learn more_

- Gimp
- Inkscape
- Steam (via proton)
- Lutris
- Notion
- Chrome
- Onepassword / opp command line

**Others**
| Name | Description | Notes |
|-----------------------------------------------------------|--------------------------------|-----------------------------------------|
| [acpid](https://man.archlinux.org/man/acpi_listen.8.en) | Battery info | Will need to enable the `acpid` service |
| [light](https://wiki.archlinux.org/title/Backlight#light) | Light control | |
| [screenkey](https://gitlab.com/screenkey/screenkey) | Show others what you're typing | |
| [screenruler](TBD) | Measure objects on your screen | |
| [galculator](TBD) | Calculate things | |

Usage:
Link files via `ln -s` to target locations. Repo directory mirrors `/home/[user]` directory format.
