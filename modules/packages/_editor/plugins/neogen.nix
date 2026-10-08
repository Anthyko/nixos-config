{
  # generate documentation for functions and more
  plugins.neogen = {
    enable = true;

    settings = {
      languages = {
        python = {
          template = {
            annotation_convention = "reST"; # sphinx
          };
        };
      };

      snippet_engine = "luasnip";
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>cd";
      action = "<cmd>Neogen<CR>";
      options.desc = "Generate documentation";
    }
  ];
}
