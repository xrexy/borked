{ pkgs, userSettings, ... }:

{
  home.packages = [ pkgs.git ];
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
      safe.directory =
        [ userSettings.dotfilesDir (userSettings.dotfilesDir + "/.git") ];
      pull.rebase = false;
    };
  };
}
