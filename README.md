# Tap Tap Phoenix — Remade for Modern iOS

A rebuild of **Tap Tap Phoenix** (the GameMaker rhythm game by Chris Cohran /
Team Phoenix) so it runs properly on iOS 26 / iOS 27 era devices, packaged
the c12n Apps way: a reproducible build pipeline that produces the sideload
IPA on every release. (GitHub-only distribution for this project — no
TestFlight.)

The original 2020 project shipped only as a prebuilt IPA (Xcode 11.7 /
iOS SDK 13.7, fat armv7 + arm64, minimum iOS 9.0). There is no source
project to recompile, so this repo rebuilds the app from that release:

1. The build downloads the original v1.00 IPA and verifies its SHA-256.
2. The GameMaker data file is fully decompiled with UndertaleModTool
   (189/189 code entries) and patched at the data level.
3. The bundle is modernised and reassembled into a fresh IPA.

## What changed vs the 2020 build

- **arm64 only** (the armv7 slice is dropped; nothing since the iPhone 5s
  can use it, and modern iOS refuses 32-bit code outright).
- **Minimum iOS 15.0** in place of 9.0.
- **Privacy manifest** (`PrivacyInfo.xcprivacy`) covering the required-reason
  APIs the runner uses (UserDefaults, file timestamps, boot time, disk space).
- **New bundle ID** `com.c12n.taptapphoenix`. The original
  embedded profile and signature are removed; the IPA ships unsigned for
  sideloading (Feather / SignLab / AltStore sign it on install).
- **Credits screen**: the original credits art is kept exactly as-is, with
  one line added at the very bottom — *"Remade for modern iOS by c12n Apps
  with ❤️ from Canada"*. The credits sprite grows downward from its original
  top edge, so the original artwork does not move or rescale.
- Deliberately **not** changed: the binary's iOS 13.7 SDK stamps and the
  legacy app-delegate lifecycle. iOS 26 warns and iOS 27 will refuse apps
  *linked against the new SDK* without a scene manifest; keeping the legacy
  stamps keeps this runner on the supported legacy path. The rendering was
  verified pixel-by-pixel against on-device screenshots — the game scales
  its 640×1387 rooms to modern displays exactly as designed.

## New in v0.2.0

- **Accounts and leaderboard live again.** The original backend
  (taptapphoenix.com) is gone, so the four endpoints the game calls —
  sign-up, login, score submission, leaderboard — were reimplemented from
  the decompiled protocol (see `server/`) and are hosted as a small
  PHP + SQLite service. The game data is patched to call the new host;
  the protocol, checksums and response formats are byte-for-byte what
  the 2020 code expects.
- **Accessibility pack.** Hit timing is more forgiving — the Perfect
  window is ±0.09 s (was ±0.05 s) and the Great window ±0.15 s
  (was ±0.08 s) — and the notes are high-contrast: the note orbs gained
  a white ring and a saturation boost, and the gameplay backgrounds
  were darkened so the notes stand out.

## Building

Push a tag `v*` (or run the workflow manually). The `Build and release`
workflow (Ubuntu) downloads + hashes the original IPA, patches the game
data with UndertaleModTool CLI (artwork imports in `tools/import_all.csx`,
code replacements in `tools/patch_gml/`), assembles the unsigned sideload
IPA with `patch_ipa.py`, verifies its bundle ID / version / architecture /
privacy manifest, and attaches it to the GitHub release. No secrets are
required. The backend in `server/` deploys separately (Docker; see its
compose file) and is not part of the IPA build.

## Credits

Original game © Team Phoenix — programming by Nick Cohran and Chris Cohran,
graphics by Chris Cohran and Tapulous. This is a preservation /
interoperability rebuild of a free fan release; no original assets were
redrawn. Content changes are the added credits line, the endpoint host,
the timing windows, and the note/background contrast treatment described
above.

Rebuild tooling Copyright (c) 2026 c12n Apps.
