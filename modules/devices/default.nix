{ ... }@inputs:
let
  devices = [
    # Personal Macbook
    ./pekora
    # Personal CI Machine
    ./soyo
    # Home Desktop
    ./tomori
  ];
  recursiveMerge =
    with builtins;
    zipAttrsWith (
      key: values:
      if tail values == [ ] then
        head values
      else if all isAttrs values then
        recursiveMerge values
      else
        last values
    );
in
recursiveMerge (builtins.map (x: (import x) inputs) devices)
