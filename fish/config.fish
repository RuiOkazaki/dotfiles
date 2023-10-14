# aliases
alias ls "exa"
alias ll "exa -l -g --icons"
alias lla "ll -a"
alias tree "tree -I node_modules"
alias cat "bat"
alias vi "nvim"
alias vim "nvim"
alias view "nvim -R"
alias cc "code ."
alias oo "open ."

# GnuPG
set -gx GPG_TTY (tty)

# git
alias gecm "git commit --allow-empty -m"

# github cli
eval (gh completion -s fish| source)

# paths
set -g GOPATH $HOME
set -gx PATH $GOPATH/go/bin $PATH

# peco ghq
function fish_user_key_bindings
  bind \c] peco_select_ghq      # Ctrl-]
  bind \cr peco_select_history  # Ctrl-r
end

function peco_select_ghq
  set -l query (commandline)
  if test -n $query
    set peco_flags --query "$query"
  end

  ghq list -p | peco $peco_flags | read line
  if test $line
    cd $line
    commandline -f repaint
  end
end

function peco_select_history
  set -l query (commandline)
  if test -n $query
    set peco_flags --query "$query"
  end

  history | peco $peco_flags | read line
  if test $line
    commandline $line
  else
    commandline ''
  end
end

# color theme
set -gx TERM xterm-256color

