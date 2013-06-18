" write a file using sudo _after_ starting vim
cmap w!! w !sudo tee % >/dev/null
