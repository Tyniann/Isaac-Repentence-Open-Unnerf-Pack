"""Build a reproducible installable/Workshop ZIP from an explicit Git snapshot."""

import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
import re
import subprocess
import zipfile
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parents[2]
MOD_NAME = "Open Unnerf Pack 2"
REPO_URL = "https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack"
UPSTREAM_WORKSHOP_ID = "2554325871"
RUNTIME_FILES = {"main.lua", "config.lua", "metadata.xml", "LICENSE"}
RUNTIME_DIRS = ("Mods/", "content/", "resources/")


def git(*args):
    return subprocess.check_output(["git", "-C", str(ROOT), *args])


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def build(ref, output_dir):
    commit = git("rev-parse", "--verify", f"{ref}^{{commit}}").decode().strip()
    records = git("ls-tree", "-rz", commit).split(b"\0")
    files = {}
    for record in filter(None, records):
        info, raw_name = record.split(b"\t", 1)
        name = raw_name.decode("utf-8")
        if name in RUNTIME_FILES or name.startswith(RUNTIME_DIRS) or name == "docs/CHANGELOG.md":
            if info.split()[0] not in {b"100644", b"100755"}:
                raise ValueError(f"release files must be regular files: {name}")
            if PurePosixPath(name).is_absolute() or ".." in PurePosixPath(name).parts:
                raise ValueError(f"unsafe archive path: {name}")
            files[name] = git("show", f"{commit}:{name}")

    required = RUNTIME_FILES | {"docs/CHANGELOG.md", "content/items.xml", "content/itempools.xml"}
    if not required <= files.keys():
        raise ValueError(f"missing release files: {sorted(required - files.keys())}")
    metadata = ET.fromstring(files["metadata.xml"])
    version = metadata.findtext("version", "")
    if not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", version):
        raise ValueError("metadata.xml must contain a MAJOR.MINOR.PATCH release version")
    if metadata.findtext("name") != MOD_NAME or metadata.findtext("directory") != "open unnerf pack":
        raise ValueError("unexpected display name or saved-settings directory")
    changelog = files["docs/CHANGELOG.md"].decode("utf-8")
    if not re.search(rf"^## \[{re.escape(version)}\] - \d{{4}}-\d{{2}}-\d{{2}}$", changelog, re.M):
        raise ValueError("release version is missing from the changelog")

    # Retain source compatibility identifiers, but never distribute the original listing ID.
    removed_upstream_id = metadata.findtext("id") == UPSTREAM_WORKSHOP_ID
    if removed_upstream_id:
        files["metadata.xml"], count = re.subn(
            rb"(?m)^[ \t]*<id>2554325871</id>[ \t]*\r?\n", b"", files["metadata.xml"]
        )
        if count != 1:
            raise ValueError("could not safely remove the original Workshop ID")
    packaged_metadata = ET.fromstring(files["metadata.xml"])
    if packaged_metadata.findtext("id") == UPSTREAM_WORKSHOP_ID:
        raise ValueError("original Workshop ID remains in release metadata")
    for path in ("content/items.xml", "content/itempools.xml"):
        ET.fromstring(files[path])

    files["README.txt"] = f"""{MOD_NAME} v{version}
The Binding of Isaac: Repentance+ v1.9.7.17
Source commit: {commit}

INSTALLATION
Close the game. Extract this entire '{MOD_NAME}' folder into the active
Repentance+ installation's mods directory. main.lua must be directly inside
mods/{MOD_NAME}/. Disable other copies of the original pack and overlapping
standalone unnerfs, then enable {MOD_NAME} and start a new run.

UPDATING
Close the game and replace the contents of your existing pack folder. Keep its
folder name, including 'open unnerf pack' if you used that name previously.
The internal saved-settings identifiers are unchanged.

CONFIGURATION
All supported adjustments default to On. Optional Mod Config Menu Pure:
https://steamcommunity.com/sharedfiles/filedetails/?id=2681875787
Press F10, then choose {MOD_NAME} > Unnerfs. Choices save immediately and
apply to new runs. Continue keeps the current run's choices, including after
relaunch. MCM is not bundled or required.

FEATURES AND CHANGELOG
{REPO_URL}/blob/v{version}/docs/features/README.md
The full release changelog is also included at docs/CHANGELOG.md.
Report bugs: {REPO_URL}/issues

STEAM WORKSHOP
This same extracted folder is the upload payload. Follow the release guide:
{REPO_URL}/blob/v{version}/docs/agents/releasing.md

CREDITS AND LICENSE
Original Open Unnerf Pack by KeinNiemand; maintained fork by Tyniann.
Original source: https://github.com/KeinNiemand/Isaac-Repentence-Open-Unnerf-Pack
MIT License; the original copyright notice is retained in LICENSE.
""".encode("utf-8")

    stem = f"Open-Unnerf-Pack-2-v{version}"
    output_dir.mkdir(parents=True, exist_ok=True)
    package = output_dir / f"{stem}.zip"
    manifest_path = output_dir / f"{stem}.manifest.json"
    checksum_path = output_dir / "SHA256SUMS.txt"
    if any(path.exists() for path in (package, manifest_path, checksum_path)):
        raise FileExistsError("use an empty output directory; release files will not be overwritten")
    with zipfile.ZipFile(package, "x", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for name, data in sorted(files.items()):
            entry = zipfile.ZipInfo(f"{MOD_NAME}/{name}", date_time=(1980, 1, 1, 0, 0, 0))
            entry.compress_type = zipfile.ZIP_DEFLATED
            entry.create_system = 3
            entry.external_attr = 0o100644 << 16
            archive.writestr(entry, data)
    with zipfile.ZipFile(package) as archive:
        if archive.testzip() is not None:
            raise ValueError("archive checksum verification failed")
        if set(archive.namelist()) != {f"{MOD_NAME}/{name}" for name in files}:
            raise ValueError("archive file inventory differs")
        for name, data in files.items():
            if archive.read(f"{MOD_NAME}/{name}") != data:
                raise ValueError(f"archive content differs: {name}")

    manifest = {
        "name": MOD_NAME,
        "version": version,
        "source_commit": commit,
        "game_target": "Repentance+ v1.9.7.17",
        "root_folder": MOD_NAME,
        "removed_upstream_workshop_id": removed_upstream_id,
        "workshop_id": packaged_metadata.findtext("id"),
        "package": {"name": package.name, "sha256": sha256(package.read_bytes())},
        "files": {name: {"size": len(data), "sha256": sha256(data)} for name, data in sorted(files.items())},
    }
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8", newline="\n")
    checksum_path.write_text(
        "".join(f"{sha256(path.read_bytes())}  {path.name}\n" for path in (package, manifest_path)),
        encoding="utf-8", newline="\n",
    )
    print(json.dumps({"zip": str(package), "source_commit": commit,
                      "version": version, "files": len(files), "sha256": manifest["package"]["sha256"]}, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ref", default="HEAD", help="Git commit or tag to package (default: HEAD)")
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args()
    build(args.ref, args.output_dir)
