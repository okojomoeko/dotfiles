IGNORE_PATTERN="^\.(git|config)"

# echo "Create dotfile links."
# for dotfile in .??*; do
#   [[ $dotfile =~ $IGNORE_PATTERN ]] && continue
#   ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
# done


mkdir -p $HOME/.config
for dotfile in $(ls -1 .config); do
  [[ $dotfile =~ $IGNORE_PATTERN ]] && continue
  if [ -d "$HOME/.config/$dotfile" ]; then
    ln -snfv "$(pwd)/.config/$dotfile/" "$HOME/.config/$dotfile"

  else
    ln -snfv "$(pwd)/.config/$dotfile" "$HOME/.config/$dotfile"
  fi
  # echo "$(pwd)/.config/$dotfile"
  # echo "$HOME/.config/$dotfile"
done
