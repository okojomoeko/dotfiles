alias cd="cdls"
alias pd="pushdls"
alias code="open -a Visual\ Studio\ Code"
alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'"
# Alias for making a "Super cd"
alias scd="cd"

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
