```sh
curl -L 'https://github.com/ypconstante/fedora-setup/archive/refs/heads/main.zip' -o 'fedora-setup.zip'
unzip 'fedora-setup.zip'
find fedora-setup-main/. -name "*.sh" -exec chmod +x {} \;
sudo ./fedora-setup-main/shell/install.sh
```

Restart


```sh
sudo dnf install -y git
git clone https://github.com/ypconstante/fedora-setup.git ~/projects/personal/fedora-setup
find ~/projects/personal/fedora-setup/. -name "*.sh" -exec chmod +x {} \;
./projects/personal/fedora-setup/shell/run-after-install.sh
```

Restart

```sh
./projects/personal/fedora-setup/shell/run.sh
```

Restart



Configure git:
- `git config --global user.email "you@example.com"`
- `git config --global user.name "Your Name"`
- [Create git ssh key](https://github.com/ypconstante/fedora-setup/wiki#create-ssh-key)
- Import GPG keys
- `cd ~/projects/personal/fedora-setup/ && git remote set-url origin git@github.com:ypconstante/fedora-setup.git`

Configure Firefox:
- Delete default bookmarks
- [Install and login into 1Password](https://addons.mozilla.org/en-US/firefox/addon/1password-x-password-manager/)
- Sign in
- Change theme to dark compact
- Import extensions config
- Enable extensions on private window
- Enable H264 plugin
- Remove additional search engines
- Add cookie exception

Configure JetBrains Toolbox:
- Sign in
- Install IntelliJ

Configure Spotify
- Sign in
- Download liked songs
- In 'Settings > Display Options', disable notifications and what friends are playing
- In 'Settings > Playback', disable smooth transition
- In 'Settings > Privacy', disable cookies

Sign in or add license to:
- Sublime Merge
- Sublime Text

Configure Chromium and Chrome:
- Change search engine to DDG
- Install [Chromium Web Store](https://github.com/NeverDecaf/chromium-web-store)
- Install uBlock Origin

[Install Nvidia drivers](https://rpmfusion.org/Howto/NVIDIA)

Configure backup on Vorta

Optional - Gaming:
- Run `~/projects/personal/fedora-setup/shell/gaming.sh`
