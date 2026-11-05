{
  description = "Deno development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustc
            cargo
            rust-analyzer
            rustfmt
            clippy
            llvmPackages_20.clang
            lld_20
            llvmPackages_20.libllvm
            pkg-config
            cmake
            protobuf
            openssl
          ] ++ lib.optionals stdenv.isLinux [
            glib
          ];

          LIBCLANG_PATH = pkgs.lib.makeLibraryPath [
            pkgs.llvmPackages_20.clang-unwrapped.lib
          ];

          shellHook = ''
            unset AS
          '';
        };
      });
}
