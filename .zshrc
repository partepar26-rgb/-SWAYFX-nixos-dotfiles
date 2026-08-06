if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi


#customs

alias ff='clear && fastfetch -l nixos_small'
alias rebld='sudo nixos-rebuild switch'
