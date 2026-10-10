_: {
  # defining some useful variables to propagate,
  # see:
  #   _module.args : everything starts here because the whole nix config use
  #   flake-parts
  #   specialArgs in mkNixos : usefull to propagate vars in nixos modules
  _module.args = {
    network = {
      domains = {
        vps = "datantho.ovh";
        main = "anthonyhengy.fr";
      };
      syncthing = {
        zeno = "NU24NWV-KGIJWAI-5P7H2LC-XMRYXUN-LSUW3UX-FILZD6P-HQDB4H2-MKSTFQ3";
        mark = "GFHIJIA-USGMC6L-ZI25Z4C-I4SCE6V-WJERPFI-64EHP7L-CUJY6HM-35NMAAJ";
        pocket = "ULPLVPO-6EILDJF-BT4TGNF-6JKI6YZ-JJZBD3E-MFSE4IF-6ZB6UDC-6PFOKQN";
      };
    };
    system = {
      users = {
        main = "anthony";
      };
    };
  };
}
