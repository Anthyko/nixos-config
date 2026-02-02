{
  config,
  pkgs,
  ...
}:
{
  services.woodpecker-server = {
    enable = false;
    environment = {
      WOODPECKER_HOST = "https://ci.datantho.ovh";
      WOODPECKER_SERVER_ADDR = "127.0.0.1:3007";
      WOODPECKER_ADMIN = "dat-Antho";
      WOODPECKER_GITHUB = "true";
    };
    environmentFile = "/etc/woodpecker/server.env";
  };

  services.woodpecker-agents.agents."local" = {
    enable = false;
    environment = {
      WOODPECKER_SERVER = "127.0.0.1:9000";
      WOODPECKER_HEALTHCHECK = "false";
      WOODPECKER_BACKEND = "local";
      WOODPECKER_MAX_WORKFLOWS = "2";
    };
    environmentFile = [ "/etc/woodpecker/agent.env" ];
  };
}

# 2 config files needed for env
# agent.env
# WOODPECKER_AGENT_SECRET=same_secret_has_server
# WOODPECKER_AGENT_LABELS="runner=local"
#
# ====
# server.env
# WOODPECKER_AGENT_SECRET=same_secret_has_agent
# WOODPECKER_GITHUB_CLIENT=tochange
# WOODPECKER_GITHUB_SECRET=tochange
