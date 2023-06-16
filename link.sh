IGNORE_PATTERN="^\.(git|config|DS_Store)"

echo "Create dotfile links."
for dotfile in .??*; do
  [[ $dotfile =~ $IGNORE_PATTERN ]] && continue
  ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done


IGNORE_PATTERN=".(DS_Store)$"
mkdir -p $HOME/.config
echo "Create .config links."
for dotfile in $(find .config -type f | grep -Ev $IGNORE_PATTERN ); do
  ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done
