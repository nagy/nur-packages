{
  pkgs,
  lib ? pkgs.lib,
}:

let
  selflib = (import ./.. { inherit pkgs; }).lib;
  conversionList = [
    # Rust
    {
      test = selflib.isRustFile;
      importer = selflib.importRust;
    }
    # Excel
    {
      test = selflib.isXLSXFile;
      importer = selflib.importXLSX;
    }
  ];
in
rec {

  findImporter =
    file:
    (lib.findFirst
      # Predicate
      (el: if el.test file then true else false)
      # Default value
      { importer = builtins.import; }
      # List to search
      conversionList
    ).importer;

  import = file: (findImporter file) file;

}
