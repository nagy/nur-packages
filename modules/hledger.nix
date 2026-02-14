{ pkgs, ... }:

let
  self = import ../. { inherit pkgs; };
in
{
  environment.systemPackages = [
    pkgs.hledger
    pkgs.hledger-ui
    pkgs.hledger-web
    # nur.repos.nagy.hledger-fmt
    self.hledger-fmt
  ];

  # environment.sessionVariables.LEDGER_FILE = "...";
}
