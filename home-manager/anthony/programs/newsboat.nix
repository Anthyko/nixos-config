{ config
, pkgs
, ...
}: {
  programs.newsboat = {
    enable = true;
    autoReload = true;
    browser = "firefox";
    urls = [
      { url = "https://nixos.org/blog/announcements-rss.xml"; }
      { url = "https://www.reddit.com/r/linux_gaming/top/.rss?sort=top&t=week"; }
      { url = "https://www.gamingonlinux.com/article_rss.php"; }
      { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCUkyyRJdVdXFmBuxPLFYmPw"; }
      { url = "https://tldr.tech/api/rss/tech"; }
      { url = "https://www.bleepingcomputer.com/feed/"; }
      { url = "https://www.nicematin.com/loisirs/festivites/rss"; }
      { url = "https://wiki.nixos.org/w/api.php?hidebots=1&translations=filter&urlversion=1&days=7&limit=50&action=feedrecentchanges&feedformat=atom"; }
      { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC1KxoDAzbWOWOhw5GbsE-Bw"; }
      { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCO5QSoES5yn2Dw7YixDYT5Q"; }
    ];
    extraConfig = ''
      browser "xdg-open %u"
      macro m set browser "mpv %u"; open-in-browser ; set browser "xdg-open %u"
    '';
  };
}
