{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib, callPackage ? pkgs.callPackage }:

let thisLib = import ./lib { inherit pkgs lib callPackage; };
in lib.makeScope pkgs.newScope (self:
  (thisLib.callNixFiles self.callPackage ./pkgs) // {

    lib = lib.extend (final: prev:
      # this extra callPackage call is needed to give
      # the result an `override` ability.
      (callPackage ./lib { }));

    qemuImages =
      pkgs.recurseIntoAttrs (self.callPackage ./pkgs/qemu-images { });

    python3Packages = pkgs.recurseIntoAttrs
      (lib.makeScope pkgs.python3Packages.newScope (self: {
        asyncer = self.callPackage ./pkgs/python3-packages/asyncer { };
        dbussy = self.callPackage ./pkgs/python3-packages/dbussy { };
        colorpedia = self.callPackage ./pkgs/python3-packages/colorpedia { };
        ssort = self.callPackage ./pkgs/python3-packages/ssort { };
        extcolors = self.callPackage ./pkgs/python3-packages/extcolors { };
        convcolors = self.callPackage ./pkgs/python3-packages/convcolors { };
        pymatting = self.callPackage ./pkgs/python3-packages/pymatting { };
        rembg = self.callPackage ./pkgs/python3-packages/rembg { };
        warctools = self.callPackage ./pkgs/python3-packages/warctools { };
        blender-file = self.callPackage ./pkgs/python3-packages/blender-file { };
        blender-asset-tracer = self.callPackage ./pkgs/python3-packages/blender-asset-tracer { };
        jtbl = self.callPackage ./pkgs/python3-packages/jtbl { };
        git-remote-rclone = self.callPackage ./pkgs/python3-packages/git-remote-rclone { };
        oauth2token = self.callPackage ./pkgs/python3-packages/oauth2token { };
        images-upload-cli = self.callPackage ./pkgs/python3-packages/images-upload-cli { };
        imagehash = self.callPackage ./pkgs/python3-packages/imagehash { };
        pipe21 = self.callPackage ./pkgs/python3-packages/pipe21 { };
        pystitcher = self.callPackage ./pkgs/python3-packages/pystitcher { };
      }));

    lispPackages = pkgs.recurseIntoAttrs {
      vacietis = pkgs.callPackage ./pkgs/vacietis { };
      dbus = pkgs.callPackage ./pkgs/cl-dbus { };
      cl-opengl = pkgs.callPackage ./pkgs/cl-opengl { };
      cl-raylib = pkgs.callPackage ./pkgs/cl-raylib { };
      s-dot = pkgs.callPackage ./pkgs/s-dot { };
      s-dot2 = pkgs.callPackage ./pkgs/s-dot2 { };
      tinmop = pkgs.callPackage ./pkgs/tinmop { };
    };

    ksv = self.callPackage ./pkgs/ksv { };

    qr2text = self.callPackage ./pkgs/qr2text { };

    urlp = self.callPackage ./pkgs/urlp { };

    overlay = lib.composeManyExtensions (thisLib.importNixFiles ./overlays);
  })
