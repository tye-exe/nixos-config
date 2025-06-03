{ ... }:
{
  # Email monitoring
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = "/etc/aliases";
      port = 465;
      tls = "on";
      auth = "login";
      tls_starttls = false;
    };
    accounts = {
      default = {
        host = "smtp.gmail.com";
        passwordeval = "cat /home/tye/.smtp_password.txt";
        user = "tye.exe@gmail.com";
        from = "tye.exe@gmail.com";
      };
    };
  };

  ## Sets root email to my email.
  environment.etc = {
    "aliases" = {
      text = ''
        root: tye.exe@gmail.com
      '';
      mode = "0644";
    };
  };
}
