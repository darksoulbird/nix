{
  description = "NixOS configuration with hardened Firefox via Schizofox";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    schizofox = {
      url = "github:schizofox/schizofox";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, schizofox, ... }:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations = {
      secure_node = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup"; 
            home-manager.users.alma = { pkgs, ... }: {
              imports = [ schizofox.homeManagerModules.default ];

              home.stateVersion = "25.11";

              programs.schizofox = {
                enable = true;

                security = {
                  sanitizeOnShutdown.enable = true;
                  sandbox.enable = true;
                };

                extensions = {
                  simplefox.enable = true;
                  darkreader.enable = true;
                };

                settings = {
                  "datareporting.healthreport.uploadEnabled" = false;
                  "datareporting.policy.dataSubmissionEnabled" = false;
                  "dom.security.https_only_mode" = true;
                  "browser.urlbar.suggest.history" = false;
                  "browser.urlbar.suggest.bookmark" = false;
                  "browser.urlbar.suggest.searches" = false;
                  "browser.sessionstore.max_tabs_undo" = 0;
                };
              };
            };
          }
        ];
      };
    };
  };
}