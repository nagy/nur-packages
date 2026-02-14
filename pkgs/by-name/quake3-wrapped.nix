{
  quake3wrapper,
  quake3arenadata,
  quake3pointrelease,
  pkgs,
}:

quake3wrapper {
  pname = "quake3-arena";
  paks = [
    quake3pointrelease
    (pkgs.linkFarm "quake3-arena-pak0-file" {
      "baseq3/pak0.pk3" = quake3arenadata.src;
    })
  ];
}
