{ pkgs, ... }:

{
  # environment.systemPackages = with pkgs; [ zpty ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;

    ohMyZsh = {
      enable = true;
      theme = "amuse";

      # https://github.com/ohmyzsh/ohmyzsh/wiki/plugins
      plugins = [
        "sudo"
        "git"
        "bun"
        "command-not-found"
        "common-aliases"
        "copyfile"
        "copypath"
        "dotenv"
        "history"
        "ssh"
      ];
    };

    shellInit = ''
      export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
    '';
  };

  environment.shells = [ pkgs.zsh ];
  users.defaultUserShell = pkgs.zsh;
}
