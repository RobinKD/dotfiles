{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware configs
    hardware.url = "github:nixos/nixos-hardware";

    # Wayland overlays
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprwm-contrib.url = "github:hyprwm/contrib";
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.hyprlang.follows = "hyprland/hyprlang";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Firefox addons
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    # TODO: Add any other flake you might need

    sops-nix = {
      url = "github:Mic92/sops-nix";
      # optional, not necessary for the module
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Allows tu run external programs with dynamically linked libs found automatically
    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      hyprland,
      sops-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        # "aarch64-linux"
        # "i686-linux"
        "x86_64-linux"
      ];
      mkNixos =
        modules:
        nixpkgs.lib.nixosSystem {
          inherit modules;
          specialArgs = {
            inherit inputs outputs;
          };
        };
    in
    rec {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs { inherit pkgs; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./shell.nix { inherit pkgs; }
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      wallpapers = ./wallpapers;
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # replace with your hostname
        aquila = mkNixos [
          # > Our main nixos configuration file <
          ./hosts/aquila
          hyprland.nixosModules.default
          sops-nix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              backupFileExtension = "hm-backup";

              extraSpecialArgs = {
                inherit inputs outputs wallpapers;
              };
              users = {
                # Import your home-manager configuration
                keanu = {
                  imports = [
                    ./home/aquila/home.nix
                    # hyprland.homeManagerModules.default
                  ];
                };
              };
            };
          }
        ];
        orion = mkNixos [
          # > Our main nixos configuration file <
          ./hosts/orion
          hyprland.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              backupFileExtension = "hm-backup";

              extraSpecialArgs = {
                inherit inputs outputs wallpapers;
              };
              users = {
                # Import your home-manager configuration
                keanu = {
                  imports = [
                    ./home/orion/home.nix
                    # hyprland.homeManagerModules.default
                  ];
                };
              };
            };
          }
        ];
        # RPi config
        cassiopee = mkNixos [
          ./hosts/cassiopee
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              backupFileExtension = "hm-backup";

              extraSpecialArgs = {
                inherit inputs outputs wallpapers;
              };
              users = {
                # Import your home-manager configuration
                rpi = {
                  imports = [ ./home/cassiopee/home.nix ];
                };
              };
            };
          }
        ];

        # Built with nix build .#nixosConfigurations.live-iso.config.system.build.isoImage
        # As usual sudo dd if=./result/iso/nixos....iso of=/dev/<usb device> bs=1M status=progress
        live-iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix")
            ./bootstrap.nix
            (
              { config, pkgs, ... }:
              {
                isoImage.squashfsCompression = "gzip -Xcompression-level 1";
                users.extraUsers.root.password = "nixos";
                environment.systemPackages = with pkgs; [
                  emacs
                  git
                ];
                hardware.enableAllFirmware = true;
                nixpkgs.config.allowUnfree = true;
                boot.supportedFilesystems = pkgs.lib.mkForce [
                  "btrfs"
                  "reiserfs"
                  "vfat"
                  "f2fs"
                  "xfs"
                  "ntfs"
                  "cifs"
                ]; # ZFS causes bugs on latest kernel
                boot.kernelPackages = pkgs.linuxPackages_latest;
              }
            )
          ];
        };
      };
    };
}
