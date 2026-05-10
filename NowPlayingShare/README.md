# NowPlayingShare for Lyrion Music Server

Generate and share a beautiful "Now Playing" card image from your currently playing track.

## Features

- **Auto-generates** a card when you open the plugin — no button clicking needed
- **Auto-updates** when the track changes
- Shows album artwork, track title, artist, album and year
- Streaming service logo (Qobuz, BBC Sounds, Bandcamp, Radio Paradise and more)
- Classical music support — shows performed by, composed by, work and album
- Disc subtitle and grouping support
- Lyrion Music Server branding
- Works on desktop and mobile browsers

## Installation

### From Repository (recommended)
1. In LMS go to **Settings → Plugins → Additional Repositories**
2. Add: `https://raw.githubusercontent.com/SimonArnold002/lms-nowplayingshare/main/repo.xml`
3. Click **Apply** then find **Now Playing Share** in the plugins list and install

### Manual Install
1. Download `NowPlayingShare-plugin.zip`
2. On your LMS server:
```bash
sudo unzip NowPlayingShare-plugin.zip -d /var/lib/squeezeboxserver/Plugins/
sudo chown -R squeezeboxserver:nogroup /var/lib/squeezeboxserver/Plugins/NowPlayingShare
sudo systemctl restart lyrionmusicserver
```

## Usage

1. Open the plugin from Material Skin's **Extras** menu
2. The card generates automatically for your active player
3. **Save Image** to download the card
4. Right-click the image and **Copy Image** to paste directly into Discord, forums etc.

## Requirements

- Lyrion Music Server 9.0+
- Material Skin (recommended)

## Credits

Created by CrystalGipsy
