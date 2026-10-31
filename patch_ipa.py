#!/usr/bin/env python3
"""Build the c12n iOS 26/27-compatible Tap Tap Phoenix IPA from the original
v1.00 IPA. Steps:
  - extract the .app
  - replace games/game.ios with the patched data file if one is present
    (patched_game.ios next to this script), else keep the original
  - thin the runner binary to arm64 (lief)
  - rewrite Info.plist: c12n bundle id, version 0.1.0, MinimumOSVersion 15.0,
    drop stale keys, keep DT*/SDK stamps at 13.7 on purpose (legacy
    UIApplicationDelegate lifecycle fallback on iOS 26/27)
  - add PrivacyInfo.xcprivacy
  - strip _CodeSignature and embedded.mobileprovision (unsigned sideload
    build, same convention as other c12n IPAs; signing happens at install
    time in Feather / SignLab / AltStore)
  - zip as Payload/… IPA and report size + SHA-256
"""
import hashlib
import plistlib
import shutil
import sys
import zipfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
SRC_IPA = HERE / "TapTapPhoenix_1.00.ipa"
PATCHED_GAME = HERE / "patched_game.ios"
WORK = HERE / "build"
OUT_IPA = HERE / "TapTapPhoenix-c12n-0.1.0.ipa"

BUNDLE_ID = "com.c12n.taptapphoenix"
VERSION = "0.1.0"

PRIVACY_PLIST = {
    "NSPrivacyTracking": False,
    "NSPrivacyTrackingDomains": [],
    "NSPrivacyCollectedDataTypes": [],
    "NSPrivacyAccessedAPITypes": [
        {
            "NSPrivacyAccessedAPIType": "NSPrivacyAccessedAPICategoryUserDefaults",
            "NSPrivacyAccessedAPITypeReasons": ["CA92.1"],
        },
        {
            "NSPrivacyAccessedAPIType": "NSPrivacyAccessedAPICategoryFileTimestamp",
            "NSPrivacyAccessedAPITypeReasons": ["C617.1"],
        },
        {
            "NSPrivacyAccessedAPIType": "NSPrivacyAccessedAPICategorySystemBootTime",
            "NSPrivacyAccessedAPITypeReasons": ["35F9.1"],
        },
        {
            "NSPrivacyAccessedAPIType": "NSPrivacyAccessedAPICategoryDiskSpace",
            "NSPrivacyAccessedAPITypeReasons": ["E174.1"],
        },
    ],
}


def thin_arm64(binary_path: Path) -> None:
    import lief

    fat = lief.MachO.parse(str(binary_path))
    arm64 = None
    for b in fat:
        if "ARM64" in str(b.header.cpu_type):
            arm64 = b
            break
    if arm64 is None:
        raise SystemExit("no arm64 slice found")
    arm64.write(str(binary_path))
    print("thinned to arm64:", binary_path.stat().st_size, "bytes")


def main() -> None:
    if WORK.exists():
        shutil.rmtree(WORK)
    WORK.mkdir(parents=True)
    with zipfile.ZipFile(SRC_IPA) as z:
        z.extractall(WORK)

    app = WORK / "Payload" / "TapTapPhoenix.app"
    assert app.is_dir(), app

    if PATCHED_GAME.exists():
        shutil.copyfile(PATCHED_GAME, app / "games" / "game.ios")
        print("using patched game.ios:", PATCHED_GAME.stat().st_size)
    else:
        print("no patched_game.ios — keeping original game data")

    thin_arm64(app / "TapTapPhoenix")

    info_path = app / "Info.plist"
    with open(info_path, "rb") as f:
        info = plistlib.load(f)
    info["CFBundleIdentifier"] = BUNDLE_ID
    info["CFBundleShortVersionString"] = VERSION
    info["CFBundleVersion"] = VERSION
    info["MinimumOSVersion"] = "15.0"
    # stale / harmful on modern systems
    for key in ("FacebookAppID", "UIPrerenderedIcon", "YYHostIP", "YYHostPort"):
        info.pop(key, None)
    # Keep DTPlatformVersion / DTSDKName / DTXcode exactly as shipped (13.7-era):
    # the iOS 27 UIScene launch assert keys off the linked SDK, and this
    # runner has no scene delegate. Do not "modernise" these.
    with open(info_path, "wb") as f:
        plistlib.dump(info, f)

    with open(app / "PrivacyInfo.xcprivacy", "wb") as f:
        plistlib.dump(PRIVACY_PLIST, f)

    sig = app / "_CodeSignature"
    if sig.exists():
        shutil.rmtree(sig)
    prov = app / "embedded.mobileprovision"
    if prov.exists():
        prov.unlink()

    if OUT_IPA.exists():
        OUT_IPA.unlink()
    with zipfile.ZipFile(OUT_IPA, "w", zipfile.ZIP_DEFLATED, compresslevel=6) as z:
        for p in sorted((WORK / "Payload").rglob("*")):
            if p.is_file():
                z.write(p, p.relative_to(WORK).as_posix())

    data = OUT_IPA.read_bytes()
    print("OUT:", OUT_IPA)
    print("size:", len(data))
    print("sha256:", hashlib.sha256(data).hexdigest())


if __name__ == "__main__":
    main()
