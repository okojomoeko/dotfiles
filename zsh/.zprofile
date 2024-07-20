
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Cloud value path for Obsidian
################################
# icloud
icloud_link_path="$HOME/icloudvault"
icloud_target_path="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/myvault"

if [ ! -L "$icloud_link_path" ]; then
  ln -s "$icloud_target_path" "$icloud_link_path"
  echo "シンボリックリンクを作成しました: $icloud_link_path -> $icloud_target_path"
fi

# google drive
gd_link_path="$HOME/googlevault"
gd_target_path="$HOME/Library/My Drive/MyPrivateFile/Documents/obsidian/myvault"

if [ ! -L "$gd_link_path" ]; then
  ln -s "$gd_target_path" "$gd_link_path"
  echo "シンボリックリンクを作成しました: $gd_link_path -> $gd_target_path"
fi

################################
