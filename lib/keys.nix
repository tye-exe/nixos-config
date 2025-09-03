rec {
  user = {
    desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGu/8cJc3bf0RQhigvzxQPYPrGBR4WiFP6x3nB8JtsMj tye";
    laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBevXkSxiJ6RqYr8tih3Ha8G6nKF/FIA2kqIAxr+RkG tye";
  };

  system = {
    nas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJ7urvL6u/JGc0AG5UEkX6ncPClJ+Y+y+iKzlYywfHC root@nixos";
  };

  users = builtins.attrValues user;
  systems = builtins.attrValues system;
  all = builtins.concatLists [
    users
    systems
  ];
}
