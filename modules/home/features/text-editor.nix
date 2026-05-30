{
  inputs,
  ...
}:
{
  flake.homeModules.text-editor =
    { ... }:
    {

      imports = [
        inputs.nixvim.homeModules.nixvim
        ./_editor/nixvim.nix
      ];
    };

}
