"""Stage a hash-pinned runtime tree outside the game; never installs or launches."""
import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
import re
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET

REPOSITORY = "https://raw.githubusercontent.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack"
ROOT_FILES = {"main.lua", "config.lua", "metadata.xml", "LICENSE", "docs/CHANGELOG.md"}
RUNTIME_DIRS = ("Mods/", "content/", "resources/")


def digest(data):
    return hashlib.sha256(data).hexdigest()


def stage(manifest, output, fetch):
    commit = manifest["source_commit"]
    if not re.fullmatch(r"[0-9a-f]{40}", commit):
        raise ValueError("source_commit must be a full Git commit")
    files = manifest["files"]
    required = ROOT_FILES | {"content/items.xml", "content/itempools.xml"}
    if not required <= files.keys():
        raise ValueError("runtime manifest is incomplete")
    for name in files:
        path = PurePosixPath(name)
        if (path.is_absolute() or ".." in path.parts or "\\" in name or ":" in name
                or not (name in ROOT_FILES or name.startswith(RUNTIME_DIRS))):
            raise ValueError(f"unexpected runtime path: {name}")
    output.mkdir(parents=True, exist_ok=False)
    for name, expected in sorted(files.items()):
        url = f"{REPOSITORY}/{commit}/{urllib.parse.quote(name, safe='/')}"
        data = fetch(url)
        if len(data) != expected["size"] or digest(data) != expected["sha256"]:
            raise ValueError(f"source hash/size mismatch: {name}")
        destination = output.joinpath(*PurePosixPath(name).parts)
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(data)
    for name in ("metadata.xml", "content/items.xml", "content/itempools.xml"):
        ET.fromstring((output / name).read_bytes())
    metadata = ET.fromstring((output / "metadata.xml").read_bytes())
    if metadata.findtext("name") != "Open Unnerf Pack 2" or metadata.findtext("directory") != "open unnerf pack":
        raise ValueError("pack identity changed")
    actual = {p.relative_to(output).as_posix(): {"size": p.stat().st_size, "sha256": digest(p.read_bytes())}
              for p in output.rglob("*") if p.is_file()}
    if actual != files:
        raise ValueError("staged tree differs from manifest")
    return {"status": "staged", "source_commit": commit, "files": len(actual),
            "output": str(output), "game_directory_changed": False}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--manifest-sha256", required=True)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args()
    raw = args.manifest.read_bytes()
    if digest(raw) != args.manifest_sha256:
        raise SystemExit("manifest hash mismatch")

    def download(url):
        with urllib.request.urlopen(url, timeout=60) as response:
            return response.read()

    print(json.dumps(stage(json.loads(raw), args.output_dir, download)))
