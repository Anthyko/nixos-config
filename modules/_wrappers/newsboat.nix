{
  config,
  lib,
  pkgs,
  wlib,
  ...
}:

let
  cfg = config.newsboat;

  escapeNewsboat = lib.escape [
    "\\"
    ''"''
  ];
  quote = value: ''"${escapeNewsboat value}"'';

  mkUrlEntry =
    feed:
    lib.concatStringsSep " " (
      [ feed.url ] ++ map quote feed.tags ++ lib.optional (feed.title != null) (quote "~${feed.title}")
    );

  mkQueryEntry = name: expression: ''"query:${escapeNewsboat name}:${escapeNewsboat expression}"'';

  urlsContents =
    lib.concatStringsSep "\n" ((lib.mapAttrsToList mkQueryEntry cfg.queries) ++ map mkUrlEntry cfg.urls)
    + "\n";

  configContents = ''
    max-items ${toString cfg.maxItems}
    reload-threads ${toString cfg.reloadThreads}
    auto-reload ${if cfg.autoReload then "yes" else "no"}
    ${lib.optionalString (cfg.reloadTime != null) "reload-time ${toString cfg.reloadTime}"}
    browser ${cfg.browser}
    prepopulate-query-feeds yes
    ${cfg.extraConfig}
  '';

  configFile = pkgs.writeText "newsboat-config" configContents;
  urlsFile = pkgs.writeText "newsboat-urls" urlsContents;
in
{
  imports = [ wlib.modules.default ];

  options.newsboat = {
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.newsboat;
      defaultText = lib.literalExpression "pkgs.newsboat";
      description = "Newsboat package to wrap.";
    };

    urls = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            url = lib.mkOption {
              type = lib.types.str;
              description = "Feed URL.";
            };

            tags = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Tags assigned to this feed.";
            };

            title = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Optional title for this feed.";
            };
          };
        }
      );

      default = [ ];
      description = "Newsboat feeds.";
    };

    queries = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Named Newsboat query feeds.";
    };

    maxItems = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Maximum number of items per feed; 0 means unlimited.";
    };

    reloadThreads = lib.mkOption {
      type = lib.types.ints.positive;
      default = 5;
      description = "Number of threads used to reload feeds.";
    };

    autoReload = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether Newsboat automatically reloads feeds.";
    };

    reloadTime = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = 60;
      description = "Automatic reload interval in minutes, or null to omit it.";
    };

    browser = lib.mkOption {
      type = lib.types.str;
      default = "xdg-open";
      defaultText = lib.literalExpression ''"xdg-open"'';
      description = "Browser command used by Newsboat.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional lines appended to Newsboat's config file.";
    };
  };

  config = {
    package = cfg.package;

    runtimePkgs = [
      pkgs.xdg-utils
    ];

    flags = {
      "--config-file" = "${configFile}";
      "--url-file" = "${urlsFile}";
    };

  };
}
