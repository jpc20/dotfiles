[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
eval "$(rbenv init -)"
# get current branch in git repo
function parse_git_branch() {
  BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  if [ ! "${BRANCH}" == "" ]
  then
    STAT=`parse_git_dirty`
    echo "[${BRANCH}${STAT}]"
  else
    echo ""
  fi
}

# get current status of git repo
function parse_git_dirty {
  status=`git status 2>&1 | tee`
  dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
  untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
  ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
  newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
  renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
  deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
  bits=''
  if [ "${renamed}" == "0" ]; then
    bits=">${bits}"
  fi
  if [ "${ahead}" == "0" ]; then
    bits="*${bits}"
  fi
  if [ "${newfile}" == "0" ]; then
    bits="+${bits}"
  fi
  if [ "${untracked}" == "0" ]; then
    bits="?${bits}"
  fi
  if [ "${deleted}" == "0" ]; then
    bits="x${bits}"
  fi
  if [ "${dirty}" == "0" ]; then
    bits="!${bits}"
  fi
  if [ ! "${bits}" == "" ]; then
    echo " ${bits}"
  else
    echo ""
  fi
}
# --------- #
# directory #
# --------- #

alias cdt="cd ~/Turing"
alias cdtp="cd ~/Turing/3module/projects/"
alias cdtc="cd ~/Turing/3module/classwork/"
alias cdti="cd ~/Turing/3module/independent_challenge/"
alias cdte="cd ~/Turing/3module/extras/"
alias ..="cd .."
alias cl="clear"

# --- #
# git #
# --- #

alias gd="git diff"
alias gs="git status"
alias ga="git add"
alias gc="git checkout"
alias pm="git pull origin master"
alias com="git checkout master"
alias grv="git remote -v"                        # show remotes
alias gbr="git browse"                           # open repo on github
alias gcb="git checkout -b"                      # create and checkout to new branch
alias glp="git log --pretty=oneline"             # oneline logs
alias gl="git log --all --graph --decorate"      # detailed log
alias gpo="git push origin" 

# removes local branches that have been merged into master
alias gclean="git branch --merged master | ag -v '\* master' | xargs -n 1 git branch -d"

cobm() {
  git checkout master && git pull && git checkout -b "$1"
}

# commits... example: gcm This is a commit
function gcm() {
  args=$@
  git commit -m "$args"
}

# ----- #
# rails #
# ----- #

alias bi="bundle install"
alias ber="bundle exec rspec"
alias be="bundle exec"
alias seed="bundle exec rake db:reset"
alias drop="bundle exec rake db:drop"
alias migrate="bundle exec rake db:migrate"
alias load="bundle exec rake db:schema:load"
alias server="bundle exec rails s"

# ------ #
# heroku #
# ------ #

alias setupheroku="heroku run rake db:setup"        # migrate & seed

export PS1="\u\w\`parse_git_branch\`$ "
