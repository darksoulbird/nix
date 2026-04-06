{
  description = "Configuración simple de NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; # o la rama que prefieras
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.main = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # cambia si usas otra arquitectura
      modules = [
        ./standardConfig.nix
      ];
    };
  };
}