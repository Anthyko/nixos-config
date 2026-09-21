{ pkgs, ... }:
{

  # Dependencies
  #
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extrapackages

  extraPackages = with pkgs; [
    black
    nixfmt
  ];

  # https://nix-community.github.io/nixvim/plugins/conform-nvim.html
  plugins.conform-nvim = {
    enable = true;
    settings = {
      notify_on_error = true;
      formatters_by_ft = {
        python = [ "black" ];
        nix = [ "nixfmt" ];
      };
      format_on_save = {
        timeout_ms = 3000;
        lsp_fallback = false;
      };
    };
  };

  # https://nix-community.github.io/nixvim/keymaps/index.html
  keymaps = [
    {
      mode = "";
      key = "<leader>f";
      action.__raw = ''
        function()
          require('conform').format { async = true, lsp_fallback = false }
        end
      '';
      options = {
        desc = "[F]ormat buffer";
      };
    }
  ];
}
