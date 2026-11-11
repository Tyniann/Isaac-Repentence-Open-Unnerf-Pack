"""Build a pinned, runtime-only Isaac test package; never install or run it."""
import argparse
import hashlib
import io
import json
from pathlib import Path
import re
import urllib.request
import zipfile
from xml.sax.saxutils import escape

PACK_SHA = "f1c83253af3636816c3b83c6ab28d2221ad345ea"
MCM_SHA = "a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d"


def archive(repo, revision):
    url = f"https://codeload.github.com/{repo}/zip/{revision}"
    with urllib.request.urlopen(url, timeout=60) as response:
        data = response.read()
    files = {}
    with zipfile.ZipFile(io.BytesIO(data)) as source:
        for item in source.infolist():
            if item.is_dir():
                continue
            parts = Path(item.filename).parts
            if len(parts) < 2 or ".." in parts:
                raise ValueError("unexpected archive path")
            files["/".join(parts[1:])] = source.read(item)
    return files, {"url": url, "sha256": hashlib.sha256(data).hexdigest()}


def build(output, observer, pack_sha=PACK_SHA, observer_description="Temporary read-only validation observer; not production gameplay."):
    if not re.fullmatch(r"[a-fA-F0-9]{40}", pack_sha):
        raise ValueError("pack revision must be a full commit SHA")
    pack, pack_archive = archive("Tyniann/Isaac-Repentence-Open-Unnerf-Pack", pack_sha)
    mcm, mcm_archive = archive("Zamiell/isaac-mod-config-menu", MCM_SHA)
    if not re.search(rb"local VERSION = 113\b", mcm["scripts/modconfig.lua"]):
        raise ValueError("expected MCM Pure v113")
    payload = {}
    for name, content in pack.items():
        if name in {"main.lua", "config.lua", "metadata.xml", "LICENSE"} or name.startswith(("Mods/", "content/")):
            payload["open_unnerf_pack_validation/" + name] = content
    for name, content in mcm.items():
        if name in {"main.lua", "metadata.xml", "LICENSE"} or name.startswith(("scripts/", "resources/")):
            payload["mod_config_menu_pure/" + name] = content
    payload["open_unnerf_validation_observer/main.lua"] = observer.read_bytes()
    payload["open_unnerf_validation_observer/metadata.xml"] = (
        b'<metadata><name>Open Unnerf Validation Observer</name><directory>'
        b'open_unnerf_validation_observer</directory><description>'
        + escape(observer_description).encode("utf-8") + b'</description></metadata>\n'
    )
    for folder in ("open_unnerf_pack_validation", "mod_config_menu_pure", "open_unnerf_validation_observer"):
        for required in ("main.lua", "metadata.xml"):
            if folder + "/" + required not in payload:
                raise ValueError("missing runtime entry point")
    manifest = {"pack_sha": pack_sha, "mcm_sha": MCM_SHA, "mcm_version": 113,
                "archives": {"pack": pack_archive, "mcm": mcm_archive},
                "files": {name: {"size": len(data), "sha256": hashlib.sha256(data).hexdigest()}
                          for name, data in sorted(payload.items())}}
    output.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(output, "w", compression=zipfile.ZIP_DEFLATED) as target:
        for name, content in sorted(payload.items()):
            entry = zipfile.ZipInfo(name, date_time=(2026, 11, 8, 0, 0, 0))
            entry.compress_type = zipfile.ZIP_DEFLATED
            target.writestr(entry, content)
    # Verify the written package bytes against the independent source-byte map.
    with zipfile.ZipFile(output) as target:
        if set(target.namelist()) != set(payload):
            raise ValueError("package file list differs")
        for name, original in payload.items():
            if target.read(name) != original:
                raise ValueError("package changed source bytes")
    manifest["package_sha256"] = hashlib.sha256(output.read_bytes()).hexdigest()
    output.with_suffix(".manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(json.dumps({"output": str(output), "file_count": len(payload),
                      "package_sha256": manifest["package_sha256"],
                      "archives": manifest["archives"]}, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--observer", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--pack-sha", default=PACK_SHA, help="full commit SHA (default: historical validated build)")
    parser.add_argument("--observer-description", default="Temporary read-only validation observer; not production gameplay.")
    args = parser.parse_args()
    build(args.output, args.observer, args.pack_sha, args.observer_description)
