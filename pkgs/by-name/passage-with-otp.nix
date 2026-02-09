{
  passage,
  nur,
  ...
}:

passage.overrideAttrs (old: {
  postInstall = ''
    ${old.postInstall}
    install -Dm755 -t $out/lib/passage/extensions \
      ${nur.repos.nagy.pass-otp-unstable}/lib/password-store/extensions/otp.bash
  '';
})
