{
  description = "Jonathan Dexter's dotfiles";

  # These inputs exist so consumers can override them via `follows`.
  # This flake does not use them directly.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }:
    {
      # ── Reusable Home Manager module ──
      # Import this from another flake:
      #   dotfiles.homeManagerModules.default
      homeManagerModules.default = { config, lib, pkgs, ... }:
        let
          cfg = config.dotfiles;
          dotfilesPath = "/home/${cfg.username}/src/dotfiles";
          mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
        in
        {
          options.dotfiles = {
            enable = lib.mkEnableOption "mandest dotfiles";

            username = lib.mkOption {
              type = lib.types.str;
              description = "Username whose home directory contains the dotfiles checkout (expects ~/src/dotfiles)";
              example = "mandest";
            };

            shell = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Link shell configs (.zshrc, .zshenv, .p10k.zsh, .kubectl_aliases)";
            };

            git = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Link .gitconfig (contains personal signing key and identity — override or disable for other users)";
            };

            scripts = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Link ~/.local/bin scripts (raise, rofi helpers, git aliases, etc.)";
            };

            hyprland = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Link Hyprland, eww, rofi, and related WM configs";
            };

            x11 = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Link X11 configs (awesome, picom, .xinitrc, .Xresources)";
            };

            sway = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Link Sway config";
            };

            terminal = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Link kitty, tmux, ranger, neofetch, and ripgrep configs";
            };

            editor = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Link neovim config and supporting lua files (.luarc.json, .stylua.toml)";
            };

            browser = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Link browser-related configs (.tridactylrc for Firefox vim bindings)";
            };

            media = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Link media configs (cava, mopidy, ncmpcpp)";
            };

            cursor = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Configure pointer cursor theme";
              };

              name = lib.mkOption {
                type = lib.types.str;
                default = "Adwaita";
                description = "Cursor theme name";
              };

              package = lib.mkOption {
                type = lib.types.package;
                default = pkgs.adwaita-icon-theme;
                description = "Package providing the cursor theme";
              };

              size = lib.mkOption {
                type = lib.types.int;
                default = 24;
                description = "Cursor size in pixels";
              };
            };
          };

          config = lib.mkIf cfg.enable {
            home.pointerCursor = lib.mkIf cfg.cursor.enable {
              name = cfg.cursor.name;
              package = cfg.cursor.package;
              size = cfg.cursor.size;
              gtk.enable = true;
              hyprcursor.enable = cfg.hyprland;
            };

            home.file = lib.mkMerge [
              # ── Shell ──
              (lib.mkIf cfg.shell {
                ".zshrc".source          = mkLink ".zshrc";
                ".zshenv".source         = mkLink ".zshenv";
                ".p10k.zsh".source       = mkLink ".p10k.zsh";
                ".kubectl_aliases".source = mkLink ".kubectl_aliases";
                ".oh-my-zsh".source = "${pkgs.runCommand "oh-my-zsh-with-plugins" {} ''
                  cp -rs --no-preserve=mode ${pkgs.oh-my-zsh}/share/oh-my-zsh $out
                  mkdir -p $out/custom/themes
                  ln -s ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k $out/custom/themes/powerlevel10k
                ''}";
              })

              # ── Git ──
              (lib.mkIf cfg.git {
                ".gitconfig".source = mkLink ".gitconfig";
              })

              # ── Scripts (~/.local/bin) ──
              (lib.mkIf cfg.scripts (lib.mapAttrs'
                (name: _: lib.nameValuePair ".local/bin/${name}" {
                  source = mkLink ".local/bin/${name}";
                })
                (builtins.readDir (self + "/.local/bin"))
              ))

              # ── Hyprland / Wayland WM ──
              (lib.mkIf cfg.hyprland {
                ".config/hypr".source       = mkLink ".config/hypr";
                ".config/eww".source        = mkLink ".config/eww";
                ".config/rofi".source       = mkLink ".config/rofi";
                ".config/rofi-twitch".source = mkLink ".config/rofi-twitch";
                ".config/caelestia".source  = mkLink ".config/caelestia";
                ".config/gtk-3.0".source    = mkLink ".config/gtk-3.0";
                ".config/gtk-4.0".source    = mkLink ".config/gtk-4.0";
                ".gtkrc-2.0".source         = mkLink ".gtkrc-2.0";
                ".config/dconf".source      = mkLink ".config/dconf";
              })

              # ── X11 / Awesome ──
              (lib.mkIf cfg.x11 {
                ".config/awesome".source = mkLink ".config/awesome";
                ".config/picom".source   = mkLink ".config/picom";
                ".xinitrc".source        = mkLink ".xinitrc";
                ".xprofile".source       = mkLink ".xprofile";
                ".Xresources".source     = mkLink ".Xresources";
                ".xfiles".source         = mkLink ".xfiles";
              })

              # ── Sway ──
              (lib.mkIf cfg.sway {
                ".config/sway".source = mkLink ".config/sway";
              })

              # ── Terminal ──
              (lib.mkIf cfg.terminal {
                ".config/kitty".source   = mkLink ".config/kitty";
                ".tmux.conf".source      = mkLink ".tmux.conf";
                ".ripgreprc".source      = mkLink ".ripgreprc";
                ".config/ranger".source  = mkLink ".config/ranger";
                ".config/neofetch".source = mkLink ".config/neofetch";
              })

              # ── Editor ──
              (lib.mkIf cfg.editor {
                ".config/nvim".source    = mkLink ".config/nvim";
                ".luarc.json".source     = mkLink ".luarc.json";
                ".stylua.toml".source    = mkLink ".stylua.toml";
              })

              # ── Browser ──
              (lib.mkIf cfg.browser {
                ".tridactylrc".source    = mkLink ".tridactylrc";
              })

              # ── Media ──
              (lib.mkIf cfg.media {
                ".config/cava".source    = mkLink ".config/cava";
                ".config/mopidy".source  = mkLink ".config/mopidy";
                ".config/ncmpcpp".source = mkLink ".config/ncmpcpp";
              })
            ];

            programs.home-manager.enable = true;
          };
        };

    };
}
