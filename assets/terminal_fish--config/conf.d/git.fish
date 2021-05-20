#https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh

abbr -ag g 'git'

abbr -ag ga  git add
abbr -ag gaa git add --all

abbr -ag gb    git branch
abbr -ag gbd   git branch -d
abbr -ag gbD   git branch -D
abbr -ag gbr   git branch --remote
abbr -ag ggsup 'git branch --set-upstream-to=origin/(git-current-branch)'

abbr -ag gbs  git bisect
abbr -ag gbsb git bisect bad
abbr -ag gbsg git bisect good
abbr -ag gbsr git bisect reset
abbr -ag gbss git bisect start

abbr -ag g-   git checkout -
abbr -ag gcb  git checkout -b
abbr -ag gco  git checkout
abbr -ag gco- git checkout -
abbr -ag gcom 'git checkout (git-main-branch)'

abbr -ag gcl git clone --recurse-submodules
abbr -ag gcls git clone --single-branch --shallow-submodules

abbr -ag gc    git commit -v
abbr -ag gc!   git commit -v --amend
abbr -ag gcn!  git commit -v --no-edit --amend
abbr -ag gca   git commit -v -a
abbr -ag gca!  git commit -v -a --amend
abbr -ag gcan! git commit -v -a --no-edit --amend
abbr -ag gcam  git commit -a -m
abbr -ag gcmsg git commit -m

abbr -ag gcf git config --list

abbr -ag gd  git diff
abbr -ag gds git diff --staged
abbr -ag gdt git diff-tree --no-commit-id --name-only -r

abbr -ag gf  git fetch
abbr -ag gfa git fetch --all --prune --jobs=10
abbr -ag gfo git fetch origin

abbr -ag glg   git log --stat
abbr -ag glgp  git log --stat -p
abbr -ag glgg  git log --graph
abbr -ag glgga git log --graph --decorate --all
abbr -ag glgm  git log --graph --max-count=10
abbr -ag glo   git log --oneline --decorate
abbr -ag glog  git log --oneline --decorate --graph
abbr -ag gloga git log --oneline --decorate --graph --all

abbr -ag gm   git merge
abbr -ag gma  git merge --abort
abbr -ag gmom 'git merge origin/(git-main-branch)'
abbr -ag gmum 'git merge upstream/(git-main-branch)'

abbr -ag gmt git mergetool --no-prompt

abbr -ag gl   git pull
abbr -ag ggl  'git pull origin (git-current-branch)'
abbr -ag gglr 'git pull --rebase origin (git-current-branch)'

abbr -ag ggp    'git push origin (git-current-branch)'
abbr -ag ggf    'git push --force origin (git-current-branch)'
abbr -ag ggfl   'git push --force-with-lease origin (git-current-branch)'
abbr -ag gpsup  'git push --set-upstream origin (git-current-branch)'
