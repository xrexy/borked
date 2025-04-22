{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ zsh-powerlevel10k zoxide ];
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;

    shellAliases = { cd = "z"; };

    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
    shellInit = ''
      export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
    '';

    ohMyZsh = {
      enable = true;
      # https://github.com/ohmyzsh/ohmyzsh/wiki/plugins
      plugins = [ "sudo" "command-not-found" "copyfile" "copypath" "dotenv" ];
    };
  };

  environment.shells = [ pkgs.zsh ];
  users.defaultUserShell = pkgs.zsh;

}
