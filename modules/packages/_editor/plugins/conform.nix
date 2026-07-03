{ pkgs, ... }:
{
  # Dependencies
  #
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extrapackages
  extraPackages = with pkgs; [
    # Used to format Lua code
    stylua
    black
  ];

  # Autoformat
  # https://nix-community.github.io/nixvim/plugins/conform-nvim.html
  plugins.conform-nvim = {
    enable = true;
    settings = {
      notify_on_error = false;
      formatters_by_ft = {
        lua = [ "stylua" ];
        # Conform can also run multiple formatters sequentially
        python = [ "black" ];

        #
        # You can use a sublist to tell conform to run *until* a formatter
        # is found
        # javascript = [ [ "prettierd" "prettier" ] ];
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
          require('conform').format { async = true, lsp_fallback = true }
        end
      '';
      options = {
        desc = "[F]ormat buffer";
      };
    }
  ];
}
