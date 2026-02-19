{
  pkgs,
  lib ? pkgs.lib,
}:

let
  self = (import ../. { inherit pkgs; });
in
rec {

  findImporter =
    file:
    lib.findFirst
      # Predicate
      (el: el.check file)
      # Default value
      builtins.import
      # List to search
      [
        self.lib.importOrg
        self.lib.importRust
        self.lib.importXLSX
      ];

  import = file: (findImporter file) file;

}
