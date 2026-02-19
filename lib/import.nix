{
  pkgs,
  lib ? pkgs.lib,
}:

let
  self = (import ../. { inherit pkgs; });
  conversionList = [
    # Rust
    {
      test = self.lib.isRustFile;
      importer = self.lib.importRust;
    }
    # Excel
    {
      test = self.lib.isXLSXFile;
      importer = self.lib.importXLSX;
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
