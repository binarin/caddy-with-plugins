{ pkgs ? (
    let
      inherit (builtins) fetchTree fromJSON readFile;
      inherit ((fromJSON (readFile ./flake.lock)).nodes) nixpkgs gomod2nix;
    in
    import (fetchTree nixpkgs.locked) {
      overlays = [
        (import "${fetchTree gomod2nix.locked}/overlay.nix")
      ];
    }
  )
, buildGoApplication ? pkgs.buildGoApplication
}:

buildGoApplication {
  pname = "caddy-with-cloudflare";
  version = "2.10.0+20250604";
  pwd = ./.;
  src = ./.;
  modules = ./gomod2nix.toml;
  meta.mainProgram = "caddy-with-cloudflare";
}
