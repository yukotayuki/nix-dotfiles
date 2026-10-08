{
  description = "joo's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    with inputs;
    let
      vars = import ./vars.nix;
      inherit (vars) username homeDirectoryPrefix;

      mkHomeConfig =
        {
          system ? "x86_64-linux",
          pkgs ? (import nixpkgs { inherit system; }),
          homeDirectory ? "${homeDirectoryPrefix pkgs}/${username}",
          extraModules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            isNixOS = false;
          };

          modules = [
            ./home.nix
            {
              home = {
                inherit username;
                inherit homeDirectory;
              };
            }
          ]
          ++ extraModules;
        };

      mkNixOSConfig =
        {
          system ? "x86_64-linux",
          extraModules,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."${username}" = import ./home.nix;
                extraSpecialArgs = {
                  isNixOS = true;
                };
              };
            }
          ]
          ++ extraModules;
        };

      mkDarwinConfig =
        {
          system ? "x86_64-darwin",
          extraModules,
          hmModules ? [ ],
        }:
        darwin.lib.darwinSystem {
          inherit system;
          modules = [
            home-manager.darwinModules.home-manager
            {
              # home-manager は home.homeDirectory をこの値から導出し、未設定だと null になり、ビルド時の absolute path 型チェックで失敗する。
              # home.nix は standalone と共用なので、darwin 固有のパスはここで設定する。
              users.users."${username}".home = "/Users/${username}";
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                # 初回 activation で既存の .zshrc などと衝突しても abort せず、<file>.bak へ退避する。
                backupFileExtension = "bak";
                users."${username}" = import ./home.nix;
                extraSpecialArgs = {
                  isNixOS = false;
                };
                sharedModules = hmModules;
              };
            }
          ]
          ++ extraModules;
        };
    in
    {
      homeConfigurations = {
        mochi = mkHomeConfig {
          system = "aarch64-darwin";
          extraModules = [
            ./modules/hostSpec.nix
            ./hosts/mochi/home-configuration.nix
            { hostSpec.name = "mochi"; }
          ];
        };
        canele = mkHomeConfig {
          system = "x86_64-linux";
          extraModules = [
            ./modules/hostSpec.nix
            ./hosts/canele/home-configuration.nix
            { hostSpec.name = "canele"; }
          ];
        };
      };

      nixosConfigurations = {
        uiro = mkNixOSConfig {
          extraModules = [
            ./hosts/uiro/configuration.nix
          ];
        };
      };

      darwinConfigurations = {
        kinako = mkDarwinConfig {
          system = "aarch64-darwin";
          extraModules = [
            ./modules/hostSpec.nix
            {
              hostSpec.name = "kinako";
              hostSpec.enableYubikey = true;
            }
            ./hosts/kinako/darwin-configuration.nix
          ];
          hmModules = [
            ./modules/hostSpec.nix
            ./hosts/kinako/home-configuration.nix
            {
              hostSpec.name = "kinako";
              hostSpec.enableYubikey = true;
            }
          ];
        };
      };

      formatter = {
        # deadnix / statix は CI で実行するので、treefmt-nix は使わずフォーマッターだけにする。
        # nixfmt-tree はディレクトリを正しく処理できる公式ラッパー（nixfmt 単体は deprecated）。
        "aarch64-darwin" = (import nixpkgs { system = "aarch64-darwin"; }).nixfmt-tree;
        "x86_64-linux" = (import nixpkgs { system = "x86_64-linux"; }).nixfmt-tree;
      };

      apps = {
        "aarch64-darwin" =
          let
            pkgs = import nixpkgs { system = "aarch64-darwin"; };
            git = "${pkgs.git}/bin/git";
          in
          {
            "setup-kinako" = {
              type = "app";
              program = "${pkgs.writeShellScript "setup-kinako" ''
                set -euo pipefail
                DOTFILES_DIR="$HOME/dotfiles"
                if [ ! -d "$DOTFILES_DIR/.git" ]; then
                  ${git} clone "git@github.com:yukotayuki/nix-dotfiles.git" "$DOTFILES_DIR" 2>/dev/null \
                    || ${git} clone "https://github.com/yukotayuki/nix-dotfiles" "$DOTFILES_DIR"
                fi
                nix run nix-darwin -- switch --flake "$DOTFILES_DIR#kinako"
              ''}";
            };
            "setup-mochi" = {
              type = "app";
              program = "${pkgs.writeShellScript "setup-mochi" ''
                set -euo pipefail
                DOTFILES_DIR="$HOME/dotfiles"
                if [ ! -d "$DOTFILES_DIR/.git" ]; then
                  ${git} clone "git@github.com:yukotayuki/nix-dotfiles.git" "$DOTFILES_DIR" 2>/dev/null \
                    || ${git} clone "https://github.com/yukotayuki/nix-dotfiles" "$DOTFILES_DIR"
                fi
                nix run home-manager -- switch --flake "$DOTFILES_DIR#mochi" -b bak
                brew bundle --file "$DOTFILES_DIR/Brewfile"
              ''}";
            };
          };
        "x86_64-linux" =
          let
            pkgs = import nixpkgs { system = "x86_64-linux"; };
            git = "${pkgs.git}/bin/git";
          in
          {
            "setup-canele" = {
              type = "app";
              program = "${pkgs.writeShellScript "setup-canele" ''
                set -euo pipefail
                DOTFILES_DIR="$HOME/dotfiles"
                if [ ! -d "$DOTFILES_DIR/.git" ]; then
                  ${git} clone "git@github.com:yukotayuki/nix-dotfiles.git" "$DOTFILES_DIR" 2>/dev/null \
                    || ${git} clone "https://github.com/yukotayuki/nix-dotfiles" "$DOTFILES_DIR"
                fi
                nix run home-manager -- switch --flake "$DOTFILES_DIR#canele" -b bak
              ''}";
            };
            "setup-uiro" = {
              type = "app";
              program = "${pkgs.writeShellScript "setup-uiro" ''
                set -euo pipefail
                DOTFILES_DIR="$HOME/dotfiles"
                if [ ! -d "$DOTFILES_DIR/.git" ]; then
                  ${git} clone "git@github.com:yukotayuki/nix-dotfiles.git" "$DOTFILES_DIR" 2>/dev/null \
                    || ${git} clone "https://github.com/yukotayuki/nix-dotfiles" "$DOTFILES_DIR"
                fi
                sudo nixos-rebuild switch --impure --flake "$DOTFILES_DIR#uiro"
              ''}";
            };
          };
      };
    };
}
