{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkg-config, ceph, dovecot, jansson }:
stdenv.mkDerivation rec {
  pname = "dovecot-ceph-plugin";
  version = "0.0.21";

  src = fetchFromGitHub {
    owner = "ceph-dovecot";
    repo = "dovecot-ceph-plugin";
    # a few commits after 0.0.21
    rev = "d467b855dfe250a259281e61b73959684895904e";
    sha256 = "0jmbjz4ldyhzqzhpmkfq1ps4ffizvig9xijarl34a1sbfvsrqd4y";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ ceph dovecot jansson ];

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
  ];

  meta = with lib; {
    description = "Dovecot plugin for storing mails in a Ceph cluster";
    homepage = "https://github.com/ceph-dovecot/dovecot-ceph-plugin";
    maintainers = [  ];
    platforms = platforms.linux;
  };
}
