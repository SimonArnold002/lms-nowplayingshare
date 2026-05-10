# NowPlayingShare — Changelog

All notable changes to this plugin are documented here.
Format: [Version] — Date — Summary

---

## [1.3.3] — 2026-05-04

### Fixed
- Jive node now registered via a 2-second timer in initPlugin rather than
  waiting for a client event. Previously the client event never fired because
  players were already connected when LMS restarted, so the node was never
  registered. Timer approach ensures it always runs on startup.
- Removed actions.json approach — not needed with proper Jive registration.

---

## [1.3.2] — 2026-05-04

### Fixed
- **Material Skin Apps menu** — plugin now registers a Jive node with
  `node => 'extras'` via `clientEvent`, exactly as SqueezeDSP does. This
  is what makes it appear in Material Skin's Apps/Extras browse menu.
- Added `webPages()` sub and `shutdown()` sub matching the SqueezeDSP
  plugin pattern.

---

## [1.3.1] — 2026-05-04

### Added
- **`material-skin-actions.json`** — correct Material Skin 6.x integration file.
  Adds "Now Playing Share" to:
  - The main hamburger menu (system section) — always accessible
  - The Now Playing track context menu (track section) — share while browsing
  Both open the share page embedded within Material Skin as an iframe with the
  current player pre-selected via `$ID`. The toolbar shows "Now Playing Share • PlayerName".

### Removed
- `material-skin-custom-actions.js` — the JS bus approach does not work in
  Material Skin 6.x. Replaced by `actions.json` which is the correct API.

---

## [1.3.0] — 2026-05-04

### Added
- **Session-isolated player management** — each browser tab/session now stores
  its own player choice in `sessionStorage`. Concurrent Material Skin users on
  different devices each get a fully independent session with no cross-contamination.
- **Player picker** — a "Change" link appears next to the player display. Clicking
  it opens a panel listing all players with their current play state (gold dot =
  playing). Selecting a player saves it to the session. Closing the picker returns
  to normal polling.
- **Session persistence** — closing and reopening the same tab restores the
  previously chosen player for that session.

### Changed
- Player auto-detection now only runs once per session to find an initial player.
  After that the session player is locked — polling only refreshes the display
  name, it does not switch players automatically.
- Switching players via the picker debounces card regeneration by 500ms.
- Poll interval increased to 10 seconds.

### Fixed
- Multiple concurrent sessions no longer interfere with each other.

---

## [1.2.2] — 2026-05-04

### Fixed
- **Grouped / synced players** — when multiple players report `play` simultaneously
  (Group Players plugin or synced players), the plugin now sticks with the current
  player rather than switching, preventing regeneration loops. Group players are
  preferred over individual members when first selecting. Regeneration is also
  debounced by 2 seconds to absorb rapid state changes during sync events.
- Player poll interval increased from 5s to 8s to reduce LMS load.
- Player switch is now locked when `?player=PLAYERID` URL param is present.

---

## [1.2.1] — 2026-05-04

### Fixed
- Player display now updates automatically when you switch players in LMS.
  Previously `detectActivePlayer()` only ran once on page load. Now polls
  every 5 seconds and updates the player bar if the active player changes.
  If auto-refresh is also active, the card regenerates for the new player.

---

## [1.2.0] — 2026-05-04

### Added
- **Auto-refresh** — clicking the ▶ Auto button polls LMS every 10 seconds and
  automatically regenerates the card when the track changes. Button turns gold
  when active; click again to stop.
- **Material Skin accent colour detection** — when opened from within Material
  Skin, the plugin attempts to read the active accent colour from CSS variables
  and applies it to the card themes automatically.
- **Version number** shown in page title and header subtitle.

### Changed
- Card now rendered as a flat PNG image immediately on generate — right-click
  → Copy Image to copy to clipboard without any extra steps.
- Removed Copy Image button (clipboard write blocked over HTTP in Chrome).
  Save Image (download) remains as the primary action alongside right-click copy.

---

## [1.1.0] — 2026-05-04

### Added
- **Pure Canvas 2D renderer** — replaced html2canvas with a custom canvas
  drawing engine. Fixes album artwork rendering (no more yellow panels),
  correct background colours, and no CORS issues.
- **Three themes** — Dark, Olive (matching Material Skin toolbar), Midnight.
- **Roboto font** throughout to match Material Skin.
- **"by Artist / from Album (Year)"** layout matching Material Skin Now Playing screen.
- **Gold accent #c9a84c** matching Material Skin exactly.
- **Rounded card corners** (16px radius) on the generated image.
- **Blurred artwork** used as art panel background.
- **Active player auto-detection** — page detects the currently playing player
  on load. No player selector dropdown needed.
- **?player=PLAYERID** URL parameter to force a specific player.

### Changed
- Removed player selector dropdown — replaced with auto-detected player display.
- Material Skin integration: `material-skin-custom-actions.js` adds a share
  button to the Material Skin toolbar.

### Fixed
- JS syntax error (`btn-download` missing closing paren) that prevented
  player detection from running.
- Album artwork panel showing yellow — now fetched as blob, drawn directly
  to canvas.

---

## [1.0.1] — 2026-05-03

### Fixed
- `install.xml` format updated to match LMS plugin registry format exactly
  (based on MaterialSkin's working install.xml). Plugin now shows correct
  name instead of `?` in Settings → Plugins.
- `strings.txt` moved to plugin root (LMS expects it there, not in `strings/`
  subfolder).
- HTML served via `addPageFunction` + `filltemplatefile` matching SqueezeDSP
  plugin pattern. Fixes 404 on the plugin page URL.
- Artwork image now fetched with `credentials: 'same-origin'` to avoid CORS
  tainting the canvas.

---

## [1.0.0] — 2026-05-03

### Initial release
- Lyrion Music Server plugin for generating shareable Now Playing images.
- 1200×630px card (Open Graph ratio) with album art, track title, artist,
  album, year, and player name.
- Three card styles: Dark, Light, Vivid.
- Copy to clipboard (HTTPS) or Download PNG.
- Material Skin toolbar button integration via `material-skin-custom-actions.js`.
- Compatible with LMS/Lyrion 9.x on Debian Bookworm / DietPi.
