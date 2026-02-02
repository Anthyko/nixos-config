{ lib, ... }:
{
  options.flake.factory = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
    # A library of factory functions that generate modules from parameters.
    # https://github.com/Doc-Steve/dendritic-design-with-flake-parts/wiki/Dendritic_Aspects#factory-aspect
  };

}
