{config, pkgs, nixpkgs-unstable, lib, ...}:
let system = "aarch64-darwin";
in
[
  (final: prev: {
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  })
  (final: prev: {
    terraform-config-inspect = pkgs.buildGoModule rec {
      pname = "terraform-config-inspect";
      version = "1.6.0";

      src = pkgs.fetchFromGitHub {
        owner = "hashicorp";
        repo = "terraform-config-inspect";
        rev = "a34142ec2a72dd916592afd3247dd354f1cc7e5c";
        sha256 = "sha256-+NsVQ3K7fiQjI/41kPV3iAzFO3Z3Z4oeUA5gJgR+EyU=";
      };

      vendorHash = "sha256-JO02/PrlyFpQnNAb0ZZ8sfGiMmGjtbhwmAasWkHPg1A=";
    };
  })
]