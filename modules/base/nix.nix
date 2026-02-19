{ nixpkgs-unstable }:
{ pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    # Note: Code from https://github.com/NixOS/nixpkgs/blob/nixos-25.11/pkgs/by-name/xr/xrdp/package.nix
    # Updates are needed when the upstream package is updated.
    (final: prev: {
      unstable = import nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
    (final: prev: {
      xrdp = prev.xrdp.overrideAttrs (
        old:
        let
          xorgxrdp = final.stdenv.mkDerivation {
            pname = "xorgxrdp";
            version = "0.10.4";

            src = final.fetchFromGitHub {
              owner = "neutrinolabs";
              repo = "xorgxrdp";
              rev = "v0.10.4";
              hash = "sha256-TuzUerfOn8+3YfueG00IBP9sMpvy2deyL16mWQ8cRHg=";
            };

            nativeBuildInputs = [
              final.pkg-config
              final.autoconf
              final.automake
              final.which
              final.libtool
              final.nasm
            ];

            buildInputs = [
              final.xorg.xorgserver
              final.libdrm
              final.mesa # provides mesa drivers
              final.libgbm # contains mesa-libgbm
              final.libepoxy # provides epoxy
            ];

            postPatch = ''
              substituteInPlace module/rdpClientCon.c \
                --replace 'g_sck_listen(dev->listen_sck);' 'g_sck_listen(dev->listen_sck); g_chmod_hex(dev->uds_data, 0x0660);'

              substituteInPlace configure.ac \
                --replace 'moduledir=`pkg-config xorg-server --variable=moduledir`' "moduledir=$out/lib/xorg/modules" \
                --replace 'sysconfdir="/etc"' "sysconfdir=$out/etc"
            '';

            preConfigure = ''
              ./bootstrap
              export XRDP_CFLAGS="-I${prev.xrdp.src}/common -I${final.libdrm.dev}/include -I${final.libdrm.dev}/include/libdrm"
            '';

            configureFlags = [ "--enable-glamor" ];

            enableParallelBuilding = true;
          };
        in
        {
          # Patch postInstall to use our new xorgxrdp
          postInstall =
            builtins.replaceStrings [ "${prev.xrdp.passthru.xorgxrdp}" ] [ "${xorgxrdp}" ]
              old.postInstall;

          passthru = old.passthru // {
            inherit xorgxrdp;
          };
        }
      );
    })
  ];
}
