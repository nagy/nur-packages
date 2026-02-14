{
  pkgs,
  lib ? pkgs.lib,
}:

{
  fetchRFCBulk =
    { range, ... }@args:
    pkgs.fetchzip (
      {
        url = "https://www.rfc-editor.org/in-notes/tar/RFCs${range}.tar.gz";
        stripRoot = false;
      }
      // (lib.removeAttrs args [ "range" ])
    );
}
