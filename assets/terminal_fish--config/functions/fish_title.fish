# https://github.com/fish-shell/fish-shell/blob/master/share/functions/fish_title.fish
# https://gist.github.com/klazuka/cf516db5eab564704527

function fish_title
    set -l current_command (echo $_)

    set -l current_dir ''

    if git rev-parse --git-dir > /dev/null ^ /dev/null
        # we are inside a git directory, so use the name of the repo as the terminal title

        set -l git_dir (git rev-parse --git-dir)

        if test $git_dir = ".git"
            # we are at the root of the git repo
            set current_dir (basename (pwd))
        else
            set -l parent_dir (dirname (dirname $git_dir))
            # we are at least one level deep in the git repo
            set current_dir  (pwd | sed "s:^$parent_dir/::")
        end
    else
        set current_dir (pwd | sed "s:^$HOME:~:")
    end

    if test $current_command = "fish"
        echo $current_dir
    else if not set -q INSIDE_EMACS; or string match -vq '*,term:*' -- $INSIDE_EMACS
        echo (set -q argv[1] && echo $argv[1] || status current-command) $current_dir
    end
end
