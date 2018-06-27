{ pkgs ? import <nixpkgs> {} }:

with pkgs;
with lib;

let
  nixops = (import ~/projects/nixops/release.nix {}).build."${builtins.currentSystem}";
in

stdenv.mkDerivation {
  name = "env";

  buildInputs = [ nixops gnumake git ];

  NIX_PATH = concatStringsSep ":" [
    # pin to specific repo
    "nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/nixos-18.03.tar.gz"

    # unstable channel for some packages
    "nixpkgs-unstable=https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz"

    # make <base.nix> refer to ./base.nix
    "."
  ];

  NIXOPS_DEPLOYMENT = "foo";
  NIXOPS_STATE="./state.nixops";

  EC2_ACCESS_KEY=removeSuffix "\n" (builtins.readFile ./secrets/EC2_ACCESS_KEY);
  EC2_SECRET_KEY=removeSuffix "\n" (builtins.readFile ./secrets/EC2_SECRET_KEY);
}
