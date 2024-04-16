IGNORE_PATTERN="^\.(git|config|DS_Store)"

echo "Create dotfile links."

# スクリプトのディレクトリを取得
DOTFILES_DIR=$(cd $(dirname $0); pwd)

# サブディレクトリも再帰的に処理する
find_dotfiles() {
    local dir=$1
    for path in "$dir"/**/.*; do
        if [ -d "$path" ]; then
            # ドットで始まるディレクトリ(例: .git)はスキップ
            if [ "$(basename "$path")" != "." -a "$(basename "$path")" != ".." ]; then
                find_dotfiles "$path"
            fi
        elif [ -f "$path" ]; then
            filename=$(basename "$path")
            if [[ $filename == .??* ]]; then

                # ドットファイルでない場合はスキップ
                if [[ $filename =~ $IGNORE_PATTERN ]]; then
                    continue
                fi
                ln -snfv "$path" "$HOME/$filename"
            fi
        fi
    done
}

find_dotfiles "$DOTFILES_DIR"


IGNORE_PATTERN=".(DS_Store)$"
mkdir -p $HOME/.config
echo "Create .config links."
for dotfile in $(find "$DOTFILES_DIR/.config" -type f | grep -Ev $IGNORE_PATTERN ); do
  tmp_dotfiles_dir="$DOTFILES_DIR/"
  new_path="${dotfile/$tmp_dotfiles_dir/}"
  ln -snfv "$dotfile" "$HOME/$new_path"
done
