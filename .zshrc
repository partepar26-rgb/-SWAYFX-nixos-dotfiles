#customs

alias ff='clear && fastfetch -l nixos_small'
alias rebld='sudo nixos-rebuild switch'
alias tgws='nix --extra-experimental-features "nix-command flakes" run github:pialtor/tg-ws-proxy-flake -- --port 1080'
alias zprt='cd ~/zapret && printf "1\n1\ny\nn\n1\n2\n" | ./service.sh'
alias clrs='clear && for bg in {40..47}; do echo -en "\e[${bg}m    \e[0m"; done; echo'
alias аа='clear && fastfetch -l nixos_small'