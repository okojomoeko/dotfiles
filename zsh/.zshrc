
# -----------------------------
# General
# -----------------------------
# 色を使用

# エディタをvimに設定
# export EDITOR=vim

# Ctrl+Dでログアウトしてしまうことを防ぐ
#setopt IGNOREEOF

# パスを追加したい場合
# export PATH="$HOME/bin:$PATH"
export PATH=$PATH:/opt/local/bin


# emacsキーバインド
# bindkey -e

# viキーバインド
#bindkey -v

# フローコントロールを無効にする
setopt no_flow_control

# ワイルドカード展開を使用する
setopt extended_glob

# コマンドラインがどのように展開され実行されたかを表示するようになる
#setopt xtrace

# ビープ音を鳴らさないようにする
setopt no_beep

# カッコの対応などを自動的に補完する
setopt auto_param_keys

# bgプロセスの状態変化を即時に知らせる
setopt notify

# 8bit文字を有効にする
# setopt print_eight_bit

# 終了ステータスが0以外の場合にステータスを表示する
setopt print_exit_value

# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs

# 上書きリダイレクトの禁止
setopt no_clobber

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# パスの最後のスラッシュを削除しない
# setopt noautoremoveslash

# 各コマンドが実行されるときにパスをハッシュに入れる
#setopt hash_cmds

# rsysncでsshを使用する
# export RSYNC_RSH=ssh

# その他
# umask 022
# ulimit -c 0

if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

# -----------------------------
# History
# -----------------------------
# 基本設定
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000

# ヒストリーに重複を表示しない
setopt histignorealldups

# 他のターミナルとヒストリーを共有
setopt share_history

# すでにhistoryにあるコマンドは残さない
setopt hist_ignore_all_dups

# historyに日付を表示
alias h='fc -lt '%F %T' 1'

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 履歴をすぐに追加する
setopt inc_append_history

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify
# -----------------------------

# -----------------------------
# Completion
# -----------------------------
# 自動補完を有効にする
autoload -Uz compinit ; compinit

# 単語の入力途中でもTab補完を有効化
#setopt complete_in_word

#入力途中の履歴補完を有効化する
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# コマンドミスを修正
setopt correct

# コマンドライン全てのスペルチェックをする
setopt correct_all

# 補完の選択を楽にする
zstyle ':completion:*' menu select

# 補完候補をできるだけ詰めて表示する
setopt list_packed

# 補完候補にファイルの種類も表示する
#setopt list_types

# 色の設定
export LSCOLORS=Exfxcxdxbxegedabagacad

# 補完時の色設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# キャッシュの利用による補完の高速化
zstyle ':completion::complete:*' use-cache true

# 補完候補に色つける
autoload -U colors ; colors ; zstyle ':completion:*' list-colors "${LS_COLORS}"
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 大文字・小文字を区別しない(大文字を入力した場合は区別する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# manの補完をセクション番号別に表示させる
zstyle ':completion:*:manuals' separate-sections true

# --prefix=/usr などの = 以降でも補完
setopt magic_equal_subst

# cdコマンドを省略して、ディレクトリ名のみの入力で移動
setopt auto_cd

# 自動でpushdを実行
setopt auto_pushd

# pushdから重複を削除
setopt pushd_ignore_dups

# -----------------------------
# Prompt
# -----------------------------
# プロンプトに色を付ける
autoload -Uz colors; colors
# 一般ユーザ時
tmp_prompt="%{${fg[cyan]}%}%n%# %{${reset_color}%}"
tmp_prompt2="%{${fg[cyan]}%}%_> %{${reset_color}%}"
# tmp_rprompt="%{${fg[green]}%}[%(4~,%-2~/.../%2~,%d)]%{${reset_color}%}"
tmp_sprompt="%{${fg[yellow]}%}%r is correct? [Yes, No, Abort, Edit]:%{${reset_color}%}"

# git branch 表示
autoload -Uz vcs_info
# zstyle ':vcs_info:*' formats '(%s)-[%b]'
# zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
tmp_rprompt="%1(v|%F{magenta}%1v%{${fg[green]}%}[%(4~,%-2~/.../%2~,%d)]%f|%F{green}[%(4~,%-2~/.../%2~,%d)]%f)"


# rootユーザ時(太字にし、アンダーバーをつける)
if [ ${UID} -eq 0 ]; then
  tmp_prompt="%B%U${tmp_prompt}%u%b"
  tmp_prompt2="%B%U${tmp_prompt2}%u%b"
  tmp_rprompt="%B%U${tmp_rprompt}%u%b"
  tmp_sprompt="%B%U${tmp_sprompt}%u%b"
fi

PROMPT=$tmp_prompt    # 通常のプロンプト
PROMPT2=$tmp_prompt2  # セカンダリのプロンプト(コマンドが2行以上の時に表示される)
RPROMPT=$tmp_rprompt  # 右側のプロンプト
SPROMPT=$tmp_sprompt  # スペル訂正用プロンプト
# SSHログイン時のプロンプト
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
  PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
;


# -----------------------------
# Functions
# -----------------------------
cdls(){
  \cd $1; ls;
}
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/vagrant/libs/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/vagrant/libs/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/vagrant/libs/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/vagrant/libs/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
