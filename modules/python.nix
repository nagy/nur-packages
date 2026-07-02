{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.python3.withPackages (ps: [
      # Ergonomic
      ps.hy
      ps.hyrule
      ps.addict

      # Numbers
      ps.numpy
      ps.pandas
      ps.pyyaml
      ps.base58
      ps.pyarrow
      ps.polars

      # Banking
      ps.schwifty

      # Typst
      ps.typst

      # Misc
      (ps.callPackage ../pkgs/python3-packages/tvdatafeed.nix { })
      (ps.callPackage ../pkgs/python3-packages/ta-lib.nix { })
      (ps.callPackage ../pkgs/python3-packages/mintalib.nix { })
    ]))
    pkgs.black
    pkgs.isort
    pkgs.pyright

    pkgs.uv
    pkgs.ruff
    pkgs.ty
  ];
}
