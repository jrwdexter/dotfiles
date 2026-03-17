{
  description = "Jonathan Dexter's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      # ── Reusable Home Manager module ──
      # Import this from another flake:
      #   dotfiles.homeManagerModules.default
      homeManagerModules.default = { config, lib, pkgs, ... }:
        let
          cfg = config.dotfiles;
          mkLink = path: config.lib.file.mkOutOfStoreSymlink "${cfg.path}/${path}";
        in
        {
          options.dotfiles = {
            enable = lib.mkEnableOption "mandest dotfiles";

            path = lib.mkOption {
              type = lib.types.path;
              description = "Absolute path to the dotfiles checkout on disk";
              example = "/home/mandest/src/dotfiles";
            };

            shell = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Link shell configs (.zshrc, .zshenv, .p10k.zsh)";
            };

            git = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Link .gitconfig and git helper scripts";
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
              description = "Link kitty, tmux, and terminal-related configs";
            };

            editor = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Link neovim config and supporting files";
            };

            media = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Link media configs (cava, mopidy, ncmpcpp)";
            };
          };

          config = lib.mkIf cfg.enable {
            home.file = lib.mkMerge [
              # ── Shell ──
              (lib.mkIf cfg.shell {
                ".zshrc".source          = mkLink ".zshrc";
                ".zshenv".source         = mkLink ".zshenv";
                ".p10k.zsh".source       = mkLink ".p10k.zsh";
                ".kubectl_aliases".source = mkLink ".kubectl_aliases";
              })

              # ── Git ──
              (lib.mkIf cfg.git ({
                ".gitconfig".source = mkLink ".gitconfig";
              } // lib.mapAttrs'
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
                ".config/thefuck".source = mkLink ".config/thefuck";
              })

              # ── Editor ──
              (lib.mkIf cfg.editor {
                ".config/nvim".source    = mkLink ".config/nvim";
                ".luarc.json".source     = mkLink ".luarc.json";
                ".stylua.toml".source    = mkLink ".stylua.toml";
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

      # ── Standalone homeConfiguration for direct use ──
      # Apply with: home-manager switch --flake .
      homeConfigurations."mandest" =
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            self.homeManagerModules.default
            {
              home = {
                username = "mandest";
                homeDirectory = "/home/mandest";
                stateVersion = "24.11";
              };
              dotfiles = {
                enable = true;
                path = "/home/mandest/src/dotfiles";
                hyprland = true;
                x11 = true;
                sway = true;
              };
            }
          ];
        };

      # ── Dev shell ──
      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = [ home-manager.packages.${system}.home-manager ];
        };
      });
    };
}
