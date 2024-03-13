{
  description = "TODO";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            vscode.extensions = with pkgs.vscode-extensions; [
              ms-toolsai.jupyter
            ];
          };
        };

        pythonWithPackages = pkgs.python3.withPackages (ps: with ps; [
          tqdm
          numpy
          torch
          jupyter
          ipython
        ]);
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pythonWithPackages
          ];
          shellHook = ''
          '';
        };
      }
    );
}
