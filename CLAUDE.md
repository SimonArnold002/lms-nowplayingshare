# NowPlayingShare — LMS Plugin

## Project Overview
A plugin for Lyrion Music Server (LMS) that generates shareable "Now Playing" card images (1200×630px) from the currently playing track. Built for LMS v9.1.1, tested with Material Skin v6.3.2.

## Current Version: 2.4.6

## Server Details
- **LMS Server**: 192.168.1.234:9000
- **OS**: DietPi (Debian-based)
- **Service**: `lyrionmusicserver`
- **Plugin location (local dev)**: `/var/lib/squeezeboxserver/Plugins/NowPlayingShare/`
- **Plugin location (repo install)**: `/var/lib/squeezeboxserver/cache/InstalledPlugins/Plugins/NowPlayingShare/`
- **Log**: `/var/log/squeezeboxserver/server.log`
- **Material Skin (dev build)**: `/var/lib/squeezeboxserver/Plugins/MaterialSkin/`
- **Material Skin JS**: `/usr/share/squeezeboxserver/Plugins/MaterialSkin/HTML/material/html/js/`

## Player IDs
- Sonos Beam: `aa:aa:60:90:9c:b0`
- Lounge: `bb:bb:93:32:0d:53`
- DMP-A8: `80:0a:80:5e:2b:7b`
- Kitchen: `cc:cc:de:7f:90:38`
- Sonos Arc: `aa:aa:b8:05:b6:35`
- Dining Room: `50:41:1c:72:4a:c8`

## Install Commands
```bash
# Full reinstall (required when Plugin.pm or install.xml changes)
sudo rm -rf /var/lib/squeezeboxserver/Plugins/NowPlayingShare
sudo unzip NowPlayingShare-plugin.zip -d /var/lib/squeezeboxserver/Plugins/
sudo chown -R squeezeboxserver:nogroup /var/lib/squeezeboxserver/Plugins/NowPlayingShare
sudo systemctl restart lyrionmusicserver

# HTML-only update (no restart needed)
sudo cp index.html /var/lib/squeezeboxserver/Plugins/NowPlayingShare/HTML/EN/plugins/NowPlayingShare/index.html
sudo chown squeezeboxserver:nogroup /var/lib/squeezeboxserver/Plugins/NowPlayingShare/HTML/EN/plugins/NowPlayingShare/index.html
```

## File Structure
```
NowPlayingShare/
├── Plugin.pm                          # Main Perl plugin file
├── install.xml                        # Plugin metadata
├── strings.txt                        # LMS string translations
├── README.md                          # User documentation
├── CHANGELOG.md                       # Version history
├── public.xml                         # Legacy (not used for repo)
├── CLAUDE.md                          # This file
└── HTML/EN/plugins/NowPlayingShare/
    ├── index.html                     # Main plugin UI (single file app)
    └── html/images/
        ├── NowPlayingShareIcon.png    # Plugin icon for LMS plugins page (real PNG)
        ├── NowPlayingShareIcon.svg    # SVG icon with fill="#000" for Material Skin Extras menu
        └── NowPlayingShareIcon_svg.png # Trigger file for Material Skin SVG recolouring
```

## GitHub Repository
- **URL**: https://github.com/SimonArnold002/lms-nowplayingshare
- **Creator**: CrystalGipsy
- **repo.xml URL**: https://raw.githubusercontent.com/SimonArnold002/lms-nowplayingshare/main/repo.xml
- **ZIP URL**: https://raw.githubusercontent.com/SimonArnold002/lms-nowplayingshare/main/NowPlayingShare-plugin.zip

### Adding to LMS Plugin Manager
In LMS → Settings → Plugins → Additional Repositories add:
```
https://raw.githubusercontent.com/SimonArnold002/lms-nowplayingshare/main/repo.xml
```
**Must use `raw.githubusercontent.com` — NOT `github.com/.../raw/...`**

### Publishing Updates to GitHub
1. Bump version in `install.xml` and `index.html`
2. Build zip locally
3. Calculate SHA BEFORE uploading: `sha1sum NowPlayingShare-plugin.zip`
4. Upload zip to GitHub replacing existing file
5. Update `repo.xml` with new version number and SHA
6. LMS detects update automatically and notifies users

### repo.xml format
```xml
<extensions>
  <details>
    <title lang="EN">NowPlayingShare for Lyrion Music Server</title>
  </details>
  <plugins>
    <plugin name="NowPlayingShare" version="X.X.X" minTarget="9.0.0" maxTarget="*">
      <title lang="EN">Now Playing Share</title>
      <desc lang="EN">Generate a shareable card image from your currently playing track.</desc>
      <url>https://raw.githubusercontent.com/SimonArnold002/lms-nowplayingshare/main/NowPlayingShare-plugin.zip</url>
      <creator>CrystalGipsy</creator>
      <email></email>
      <sha>LOWERCASE_SHA1_HERE</sha>
    </plugin>
  </plugins>
</extensions>
```

## Key Technical Decisions

### Plugin Registration
- `addPageLinks("plugins")` and `addPageLinks("icons")` in both `initPlugin` and `webPages`
- Key: `'PLUGIN_NOW_PLAYING_SHARE'`
- Icon path in install.xml and Plugin.pm: `plugins/NowPlayingShare/html/images/NowPlayingShareIcon.png`
- NO Jive node registration

### Icon System
- `NowPlayingShareIcon.png` — real PNG image used on LMS plugins listing page
- `NowPlayingShareIcon.svg` — SVG with `fill="#000"`, Material Skin reads and recolours for Extras menu
- `NowPlayingShareIcon_svg.png` — just needs to exist as a trigger file for the `_svg.png` convention
- Material Skin replaces `#000` with white (dark theme) or black (light theme) for Extras menu
- The `_svg.png` convention ONLY applies to the Extras menu icon, NOT the plugins listing page
- `install.xml` and Plugin.pm both reference `NowPlayingShareIcon.png` (plain PNG)

### UI Behaviour
- **Auto-generates** card on page load once player is detected
- **Auto-refreshes** when track changes (polls every 10 seconds)
- Polling **pauses** when tab is hidden, **resumes** when tab becomes visible
- Generate Card and Auto buttons exist in HTML but are hidden (`display:none`) — JS logic intact
- Only visible button is **Save Image** for downloading
- Player selector shown — user can change player via Change button

### Canvas Renderer
- Pure canvas 2D — no external dependencies
- Card: W=1200, H=630, ART_W=600, PAD=50
- Always uses `midnight` theme: bg `#1a1a1a`, accent `#c9a84c`
- **Square corners** — no rounded clip, solid dark background, zero transparency
- Safe to paste anywhere — no white corner issues
- Preview in UI uses CSS `border-radius:12px` for rounded appearance only
- Full-card blurred background via multi-pass scale blur (mobile compatible)

### Multi-pass Blur (mobile compatible)
`ctx.filter: blur()` not supported on mobile. Use progressive scale:
```javascript
var sizes = [2, 8, 20, 60, 160];
```

### Text Layout — Standard tracks
- NOW PLAYING: 20px, 500 weight, white 60% opacity
- Title: 32px default, 700 weight, scales to 20px min, max 2 lines, 32px gap after
- `by` Artist: 26px, scales to 14px, with lighter smaller "by" prefix
- `from` Album: 22px, wraps to max 2 lines, scales to 12px min, with lighter "from" prefix
- `subtitle` Grouping: same size as album, shown if present (non-classical)
- `disc` Disc subtitle: shown if present (non-classical)
- Disc number (Disc X of Y): NOT shown
- All lines use `fontSize + LINE_GAP (18px)` spacing

### Text Layout — Classical tracks (isClassical = true from LMS)
- NOW PLAYING
- Track title
- `performed by` Artist
- `composed by` Composer
- `work` Work/Grouping (· performance if present)
- `from` Album (Year)

### Classical Detection
- Uses `isClassical` field returned directly by LMS status response
- LMS sets this based on "My work and composer album genres" setting in My Music
- Do NOT try to detect classical ourselves — trust LMS completely

### Service Logos
- All SVGs from Material Skin: `/material/html/images/SERVICE.svg`
- All white-tinted via `source-atop` compositing, 70% opacity
- Detection from `extid` or `url` field:
  - qobuz, bbcsounds (bbc/bbcsounds), spotify, tidal, deezer
  - bandcamp OR bcbits (Bandcamp streams from bcbits.com)
  - radioparadise/radio-paradise, soundcloud, iheartradio
  - tunein, mixcloud, napster, youtube

### Lyrion Logo
- Fetched from `/material/html/images/lyrion-logo.svg`
- White tinted via `source-atop`, 70% opacity
- Top-right of card, service icon to its left

### LMS Tags
```
tags:cdegilopqrstuyAABEGIKNPSTVbhz124
```
Full Material Skin tag string — includes isClassical, work, composer, grouping, discsubtitle, disc, disccount, performance

### Player Detection
- sessionStorage per-tab isolation
- Auto-detects active player on load, auto-generates card
- Artist: `loop.artist || loop.trackartist || loop.albumartist`
- Year: only shown if non-zero

### Auto-refresh / Polling
- Starts automatically after first card is rendered (1 second delay)
- Polls every 10 seconds for track changes
- Only regenerates if track title has changed AND mode is 'play'
- Pauses when tab is hidden (visibilitychange API)
- Resumes when tab becomes visible again
- Generate Card and Auto buttons hidden but functional if needed

## LMS JSON-RPC Examples
```bash
# Get player list
curl -s "http://192.168.1.234:9000/jsonrpc.js" \
  -d '{"id":1,"method":"slim.request","params":["",["players","0","10"]]}' \
  -H "Content-Type: application/json" | python3 -m json.tool

# Check what's playing with all tags
curl -s "http://192.168.1.234:9000/jsonrpc.js" \
  -d '{"id":1,"method":"slim.request","params":["PLAYER_ID",["status","-","1","tags:cdegilopqrstuyAABEGIKNPSTVbhz124"]]}' \
  -H "Content-Type: application/json" | python3 -m json.tool | grep -i "composer\|work\|grouping\|isClassical\|url\|extid"

# Check plugin loaded
grep -i "nowplaying" /var/log/squeezeboxserver/server.log | tail -10
```

## Known Issues / Notes
- Icon display in LMS plugins page uses plain PNG — `_svg.png` convention only for Extras menu
- Clipboard API requires HTTPS — not available on http://192.168.1.234:9000
- Bandcamp streams from `bcbits.com` not `bandcamp.com` — both detected
- `defaultState>enabled</defaultState>` in install.xml auto-enables plugin on install
- Square corners on exported image — rounded appearance is CSS only in preview
