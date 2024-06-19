{ lib, ... }: {
  programs.plasma = {
    enable = true;
    panels = [{ location = "top"; }];
  };
}
