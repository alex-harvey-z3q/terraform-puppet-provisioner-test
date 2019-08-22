#!/usr/bin/env bash

configure_ssh() {
  sed -i '
    s/.*PermitRootLogin.*/PermitRootLogin without-password/
    ' /etc/ssh/sshd_config
  systemctl restart sshd
  mkdir -p -m 700 /root/.ssh
  cat > /root/.ssh/authorized_keys <<'EOF'
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZWI7KSYD2tR0k+oxUsoY/DCVzryyH1z2i01Bx+pVY1/hPNwgrLFKYJVGqQyOtXNn0UqLr5DRwii8OYZsqccs7LPSZPgIJzTQpHtqudPJ3eB4EhU0NNdjKcgvZcBPnJBu9tKHKo8pB7sEkcCcXIfjrQcOJk0Ljyqn1mRzT37Q7mouNWd4aQKq8Pdq+r9IYe4Rhi5Avgxd04lZ3hbojcTPxNyxL+6kQZ0plnt09drNOomirW2MkOeKN+ySNlYskhB/Xag/J6FVAcMMcKo3quVRvYEFi8Z/rt5AnO345ZLwVIGIGwcj3Tx7wAjEUdK/N9y7uv757pw0YMPrcNTZ+C/n5 puppet
EOF
  chmod 644 /root/.ssh/authorized_keys
}

main() {
  configure_ssh
}

main

# vim: set ft=sh: