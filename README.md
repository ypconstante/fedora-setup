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

Sign in or add license to:
- Sublime Merge
- Sublime Text

Configure Chromium:
- Change search engine to DDG

Configure Firefox:
- Sign in
- Change theme to dark compact
- Import extensions config
- Add certificates from /usr/local/share/ca-certificates
- Change sync config
    - Enable Add-ons
    - Disable credit cards
- Enable H264 plugin

Configure git:
- `git config --global user.email "you@example.com"`
- `git config --global user.name "Your Name"`
- [Create git key](https://github.com/ypconstante/mint-setup/wiki#create-ssh-key)

Configure JetBrains Toolbox:
- Sign in
- Install IntelliJ

Configure Spotify
- Sign in
- Download liked songs
- In 'Settings > Display Options', disable notifications
- In 'Settings > Privacy', disable cookies

Configure packages:
- gradle
- maven
- npm

[Install Nvidia drivers](https://rpmfusion.org/Howto/NVIDIA)

Optional - Gaming:
- Run `~/projects/personal/fedora-setup/shell/gaming.sh`
- Configure Steam to download into `~/Gaming/Steam`
