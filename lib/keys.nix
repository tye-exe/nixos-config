rec {
  users = {
    desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGu/8cJc3bf0RQhigvzxQPYPrGBR4WiFP6x3nB8JtsMj tye"; # Desktop
    laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBevXkSxiJ6RqYr8tih3Ha8G6nKF/FIA2kqIAxr+RkG tye"; # Laptop
  };

  all = builtins.attrValues users;
}
