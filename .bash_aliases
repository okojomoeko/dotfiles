alias cd="cdls"
alias pd="pushdls"
alias code="open -a Visual\ Studio\ Code"
alias mytree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'"
# Alias for making a "Super cd"
alias scd="cd"


# VS Code alias
case "${OSTYPE}" in
darwin*)
  alias ls='ls -G'
  ;;
linux*)
  alias ls='ls --color=auto'
  ;;
msys*)
  alias code='~/AppData/Local/Programs/Microsoft\ VS\ Code/Code.exe'
esac

# Functions
cdls(){
\cd $1; ls;
}

pushdls(){
\pushd $1; ls;
}

# Super cd function
_scd_completion() {
    mapfile -t COMPREPLY < <(ls -d */ | grep "${COMP_WORDS[COMP_CWORD]}")
}
complete -F _scd_completion scd

# gcl: git-cleanup-remote-and-local-branches
#
# Cleaning up remote and local branch is delivered as follows:
# 1. Prune remote branches when they are deleted or merged
# 2. Remove local branches when their remote branches are removed
# 3. Remove local branches when a main included squash and merge commits

function git_prune_remote() {
  echo "Start removing out-dated remote merged branches"
  git fetch --prune
  echo "Finish removing out-dated remote merged branches"
}

function git_remove_merged_local_branch() {
  echo "Start removing out-dated local merged branches"
  git branch --merged | egrep -v "(^\*|main|develop|ANY_BRANCH_YOU_WANT_TO_EXCLUDE)" | xargs -I % git branch -d %
  echo "Finish removing out-dated local merged branches"
}

# When we use `Squash and merge` on GitHub,
# `git branch --merged` cannot detect the squash-merged branches.
# As a result, git_remove_merged_local_branch() cannot clean up
# unused local branches. This function detects and removes local branches
# when remote branches are squash-merged.
#
# There is an edge case. If you add suggested commits on GitHub,
# the contents in local and remote are different. As a result,
# This clean up function cannot remove local squash-merged branch.
function git_remove_squash_merged_local_branch() {
  echo "Start removing out-dated local squash-merged branches"
  git checkout -q main &&
    git for-each-ref refs/heads/ "--format=%(refname:short)" |
    while read branch; do
      ancestor=$(git merge-base main $branch) &&
        [[ $(git cherry main $(git commit-tree $(git rev-parse $branch^{tree}) -p $ancestor -m _)) == "-"* ]] &&
        git branch -D $branch
    done
  echo "Finish removing out-dated local squash-merged branches"
}

# Clean up remote and local branches
function gcl() {
  git_prune_remote
  git_remove_merged_local_branch
  git_remove_squash_merged_local_branch
}

function makedoc(){
  if [ $# -ne 1 ]; then
    echo "Input document name"
    return
  fi

  filename="$(date '+%Y%m%d')_$1"
  echo $filename

  if [ -d $filename ]; then
    echo "Directory Exists: $filename"
    return
  fi
  mkdir $filename;
  touch "$filename/$filename.md";
  echo -e "# $1\n\n## \n\n" >> "$filename/$filename.md";
  code "$filename/$filename.md";
}

today(){
  echo "$(date +%Y%m%d)";
}

now(){
  echo "$(date +%Y%m%d_%H%M%S)"
}

cmdfordir(){
  array=($(find . -maxdepth 1 -type d))

  cmd=${@:1}

  for obj in "${array[@]}"; do
    if [ $obj = "." ] || [ ${obj:0:3} = "./." ]; then
      continue
    fi

    echo -e "\033[1;33mExecute '$cmd' in $obj\033[0;39m"
    eval "cd $obj; $cmd; echo -en '\n'; cd ../;"

  done
}
