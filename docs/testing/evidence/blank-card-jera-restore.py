"""Restore issue-19 originals while archiving the entire disposable session."""
import argparse
import hashlib
import json
from pathlib import Path
import runpy
import shutil
import subprocess


def digest(data):
    return hashlib.sha256(data).hexdigest()


def restore(session, before, runtime, closed):
    library = session / "install-issue19.py"
    assert digest(library.read_bytes()) == "93d073fe8e621fc130d4be7303315c8f679150141a6bbc42499f6665a9a37470"
    inventory = runpy.run_path(str(library), run_name="read_only_inventory")["inventory"]

    def snapshot(root):
        assert root.is_dir(), "Required tree absent: " + str(root)
        return {"files": inventory(root), "directories": sorted(
            p.relative_to(root).as_posix() for p in root.rglob("*") if p.is_dir())}

    def original(name):
        raw = before["inventory"][name]
        return {"files": {n: {"size": v["bytes"], "sha256": v["sha256"]}
                          for n, v in raw["files"].items()}, "directories": sorted(raw["directories"])}

    def fingerprint(value):
        return digest(json.dumps(value, sort_keys=True, separators=(",", ":")).encode())

    closed()
    expected = {name: original(name) for name in ("backup-user", "backup-data", "backup-mods")}
    for name, value in expected.items():
        assert snapshot(session / name) == value, "Immutable backup changed: " + name
    profile, data, mods = (Path(before["sources"][name]) for name in ("backup-user", "backup-data", "backup-mods"))
    pack_name = "Open Unnerf Pack 2"
    prefix = pack_name + "/"
    pack_expected = {
        "files": {n[len(prefix):]: v for n, v in expected["backup-mods"]["files"].items() if n.startswith(prefix)},
        "directories": sorted(n[len(prefix):] for n in expected["backup-mods"]["directories"] if n.startswith(prefix)),
    }
    original_pack = session / "original-pack"
    assert pack_expected["files"] and snapshot(original_pack) == pack_expected
    pack = mods / pack_name
    assert inventory(pack) == runtime["files"], "Test pack differs from its pinned runtime"
    diagnostic_names = ("oup_blank_card_issue19_observer", "oup_blank_card_issue19_batch")
    owned = (pack_name,) + diagnostic_names

    def owned_path(name):
        return any(name == root or name.startswith(root + "/") for root in owned)

    def protected(value):
        return {"files": {n: v for n, v in value["files"].items() if not owned_path(n)},
                "directories": [n for n in value["directories"] if not owned_path(n)]}

    assert protected(snapshot(mods)) == protected(expected["backup-mods"]), "Unrelated mods changed"
    for name in diagnostic_names:
        assert name not in expected["backup-mods"]["directories"]
        assert not any(n.startswith(name + "/") for n in expected["backup-mods"]["files"])
    plans = [
        ("pack", original_pack, pack, session / "restore-pack-staged", session / "final-test-pack", pack_expected),
        ("data", session / "backup-data", data, session / "restore-data-staged", session / "final-test-data", expected["backup-data"]),
        ("profile", session / "backup-user", profile,
         profile.with_name(profile.name + "." + session.name + ".restore-staged"),
         profile.with_name(profile.name + "." + session.name + ".test-session"), expected["backup-user"]),
    ]
    diagnostics = session / "final-diagnostics"
    journal = session / "restore-journal.json"
    result_file = session / "restore-result.json"
    for path in [diagnostics, journal, result_file] + [p for row in plans for p in row[3:5]]:
        assert not path.exists(), "Restore/archive path already exists: " + str(path)
    old = {name: snapshot(target) for name, _, target, _, _, _ in plans}
    old_diagnostics = {name: snapshot(mods / name) for name in diagnostic_names}
    for _, source, _, staged, _, value in plans:
        closed()
        shutil.copytree(source, staged)
        assert snapshot(staged) == value
    record = {"status": "prepared", "archives": {name: str(archive) for name, _, _, _, archive, _ in plans},
              "archive_fingerprints": {name: fingerprint(value) for name, value in old.items()},
              "diagnostics_archive": str(diagnostics),
              "diagnostic_fingerprints": {name: fingerprint(value) for name, value in old_diagnostics.items()},
              "completed": []}

    def save():
        journal.write_text(json.dumps(record, indent=2), encoding="utf-8")

    save()
    completed, moved_diagnostics = [], []
    try:
        for row in plans:
            name, _, target, staged, archive, value = row
            closed()
            assert snapshot(target) == old[name], "Disposable tree changed before archive: " + name
            assert snapshot(staged) == value
            target.rename(archive)  # Archive and target share a volume, including the C: profile.
            try:
                staged.rename(target)
            except BaseException:
                archive.rename(target)
                raise
            completed.append(row)
            assert snapshot(target) == value and snapshot(archive) == old[name]
            record["completed"].append(name)
            save()
        diagnostics.mkdir()
        for name in diagnostic_names:
            closed()
            assert snapshot(mods / name) == old_diagnostics[name]
            (mods / name).rename(diagnostics / name)
            moved_diagnostics.append(name)
        assert snapshot(profile) == expected["backup-user"]
        assert snapshot(data) == expected["backup-data"]
        assert snapshot(mods) == expected["backup-mods"]
        assert snapshot(original_pack) == pack_expected
        for name, value in expected.items():
            assert snapshot(session / name) == value
        record["status"] = "restored"
        save()
        result = {"status": "restored", "profile_files": len(expected["backup-user"]["files"]),
                  "data_files": len(expected["backup-data"]["files"]), "mod_files": len(expected["backup-mods"]["files"]),
                  "original_backups_preserved": True, "original_pack_archive_preserved": True,
                  "disposable_archives": record["archives"], "diagnostics_archive": str(diagnostics),
                  "game_started": False}
        result_file.write_text(json.dumps(result, indent=2), encoding="utf-8")
        return result
    except BaseException:
        closed()  # Never move live data beneath a newly started game.
        for name in reversed(moved_diagnostics):
            (diagnostics / name).rename(mods / name)
        for name, _, target, staged, archive, _ in reversed(completed):
            target.rename(staged)  # Retain restored bytes for diagnosis; never delete a tree.
            archive.rename(target)
            assert snapshot(target) == old[name]
        record["status"] = "rolled_back"
        save()
        raise


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--session", type=Path, required=True)
    args = parser.parse_args()
    raw = (args.session / "before.json").read_bytes()
    runtime_raw = (args.session / "candidate-v3-inputs/runtime.json").read_bytes()
    assert digest(raw) == "4af7acc70e3c153672d44c74f4ed1b58190b74fd3129483207d8f91c722b14a7"
    assert digest(runtime_raw) == "4e4e49ed5bf0bef57c5dee9e8393d0b7b95d432bd62e182a306876f4d51a6c4d"

    def closed():
        result = subprocess.run(["powershell.exe", "-NoProfile", "-Command",
                                 "@(Get-Process -Name 'isaac*' -ErrorAction SilentlyContinue).Count"],
                                check=True, capture_output=True, text=True)
        assert int(result.stdout.strip()) == 0, "Isaac must be closed"

    print(json.dumps(restore(args.session, json.loads(raw), json.loads(runtime_raw), closed)))
