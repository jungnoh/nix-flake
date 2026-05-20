{
  config,
  lib,
  pkgs,
  system,
  ...
}:
with lib;
{
  options.myOptions.helium = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.myOptions.helium.enable (byPlatform {
    linux =
      let
        pname = "helium-browser";
        version = "0.12.3.1";
        architectures = {
          "x86_64-linux" = {
            arch = "x86_64";
            hash = "sha256-VnOhzhAulvFNBB/0AD1d+K/TzfFL9Zwtk/vcm5vWl+I=";
          };
        };
        src =
          let
            inherit (architectures.${system}) arch hash;
          in
          pkgs.fetchurl {
            url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-${arch}.AppImage";
            inherit hash;
          };
        appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
        package = pkgs.appimageTools.wrapType2 {
          inherit pname version src;
          nativeBuildInputs = [ pkgs.copyDesktopItems ];

          extraInstallCommands = ''
            # Create directories for the desktop file and icons
            mkdir -p $out/share/applications
            mkdir -p $out/share/icons

            # Copy and fix the .desktop file
            cp ${appimageContents}/helium.desktop $out/share/applications/
            substituteInPlace $out/share/applications/helium.desktop \
              --replace 'Exec=helium' 'Exec=${pname}'

            # Copy the app icons
            cp ${appimageContents}/helium.png $out/share/icons/
          '';
        };
      in
      {
        home.packages = [ package ];
      };
    darwin = {
      homebrew.casks = [ "helium-browser" ];
    };
  });
}
