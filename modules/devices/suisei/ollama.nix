{
  config,
  lib,
  pkgs,
  ...
}:
let
  listenAddress = "0.0.0.0";
  listenPort = "11434";
  webuiFolder = "/Users/jungnoh/open-webui";
in
{
  environment.systemPackages = with pkgs; [
    ollama
    uv
  ];

  launchd.user.agents.ollama = {
    path = [ config.environment.systemPath ];

    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      ProgramArguments = [
        "${pkgs.ollama}/bin/ollama"
        "serve"
      ];

      EnvironmentVariables = {
        OLLAMA_HOST = "${listenAddress}:${toString listenPort}";
      };
    };
  };
  launchd.user.agents.open-webui = {
    path = [ config.environment.systemPath ];

    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      ProgramArguments = [
        "${pkgs.uv}/bin/uvx"
        "--python"
        "3.11"
        "open-webui@latest"
        "serve"
      ];

      WorkingDirectory = webuiFolder;
      StandardOutPath = "${webuiFolder}/logs/stdout.log";
      StandardErrorPath = "${webuiFolder}/logs/stderr.log";

      EnvironmentVariables = {
        DATA_DIR = "~/.open-webui";
        PORT = "11557";
      };
    };
  };
}
