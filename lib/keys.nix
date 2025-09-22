rec {
  # User keys
  user = {
    desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGu/8cJc3bf0RQhigvzxQPYPrGBR4WiFP6x3nB8JtsMj tye";
    laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBevXkSxiJ6RqYr8tih3Ha8G6nKF/FIA2kqIAxr+RkG tye";
    framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF4WVKh+6Tg76ClLo03PNYyr4Kwh4O+VgwdawkB4cEUH tye";
    nas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlxvMZ/Q8knBvPAdFgjHRjVqtxyC+xAgA4RhlVWB7m1 tye";
  };

  # System keys
  system = {
    nas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJ7urvL6u/JGc0AG5UEkX6ncPClJ+Y+y+iKzlYywfHC root@nixos";
  };

  # All user keys
  users = builtins.attrValues user;
  # All system keys
  systems = builtins.attrValues system;
  # All keys
  all = builtins.concatLists [
    users
    systems
  ];
}
