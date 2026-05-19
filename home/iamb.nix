{ pkgs, ... }:

{
  home.packages = with pkgs; [
    iamb
  ];

  xdg.configFile."iamb/config.toml".source = (pkgs.formats.toml { }).generate "iamb-config" {
    profiles.default = {
      user_id = "@bush:simplybush.pl";
      homeserver = "https://simplybush.pl";
    };

    layout.style = "new";

    settings = {
      notify = true;
      theme = "default";

      image_preview.protocol = {
        type = "kitty";
        size = {
          height = 50;
          width = 166;
        };
      };

      notifications = {
        enabled = true;
        via = "desktop";
      };
    };
  };
}
