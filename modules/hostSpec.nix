{ lib, ... }:

{
  options.hostSpec = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "端末固有名";
    };
  };
}
