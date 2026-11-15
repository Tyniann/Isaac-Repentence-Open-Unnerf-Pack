"""Frozen issue-19 Car Battery update; preserves every previous generation."""
import argparse
import hashlib
import json
from pathlib import Path
import runpy
import shutil
import subprocess


def digest(data):
    return hashlib.sha256(data).hexdigest()


def upgrade(session, game, before, previous, current, candidate, closed):
    library = session / "install-issue19.py"
    assert digest(library.read_bytes()) == "93d073fe8e621fc130d4be7303315c8f679150141a6bbc42499f6665a9a37470"
    methods = runpy.run_path(str(library), run_name="validated_swap_library")
    inventory, swap = methods["inventory"], methods["swap"]
    mods = game / "mods"
    target, original = mods / "Open Unnerf Pack 2", session / "original-pack"
    prefix = "Open Unnerf Pack 2/"
    saved = before["inventory"]["backup-mods"]["files"]
    original_files = {name[len(prefix):]: {"size": value["bytes"], "sha256": value["sha256"]}
                      for name, value in saved.items() if name.startswith(prefix)}
    protected = {name: {"size": value["bytes"], "sha256": value["sha256"]}
                 for name, value in saved.items() if not name.startswith(prefix)}
    assert original.is_dir() and inventory(original) == original_files, "Original pre-test pack changed"
    actual = inventory(mods)
    assert all(actual.get(name) == value for name, value in protected.items()), "Protected mod changed"
    helper = mods / "oup_blank_card_issue19_batch"
    helper_files = inventory(helper)
    for name, sha in {
        "main.lua": "bfec07380b1d3f98e942b17207e78661e1b82c63dfa1a4dc9f4b15ab2fe5dca0",
        "batch.lua": "febcb67b030d00bc8556c423b01509c7a8e36f766104371a30a9c95c5c30f794",
        "matrix.lua": "1d5b33b01aba1fcd7d0484665e16b798696184a21e7f92c5071510dec106cd2f",
        "matrix-v3.lua": "21bce95185f01034b64c24c39935fabc12755d91f9bbbd3a87a3470dc31afc45",
    }.items():
        assert helper_files[name]["sha256"] == sha, "Unexpected helper generation: " + name
    matrix_bytes = (helper / "matrix-v3.lua").read_bytes()
    expected_helper = dict(helper_files)
    expected_helper["matrix.lua"] = helper_files["matrix-v3.lua"]
    archive = session / "candidate-used-0e1c6e4215d6"
    backup = session / "diagnostic-generation-v2"
    journal = session / "candidate-update-v3.json"
    for name in (archive, backup, journal, session / "failed-candidate-v3",
                 session / "failed-diagnostic-v3", session / "failed-update-v3.json"):
        assert not name.exists(), "Update/archive path already exists: " + str(name)
    closed()
    shutil.copytree(helper, backup)
    assert inventory(backup) == helper_files
    swapped = False
    try:
        swap(candidate, target, archive, current["files"], previous["files"], closed)
        swapped = True
        closed()
        (helper / "matrix.lua").write_bytes(matrix_bytes)
        assert inventory(helper) == expected_helper
        assert inventory(original) == original_files
        actual = inventory(mods)
        assert all(actual.get(name) == value for name, value in protected.items())
        record = {"status": "installed", "source_commit": current["source_commit"],
                  "previous_source": previous["source_commit"], "files": len(current["files"]),
                  "original_pack": str(original), "previous_candidate": str(archive),
                  "diagnostic_backup": str(backup), "matrix_sha256": digest(matrix_bytes),
                  "game_started": False, "profile_changed": False, "game_data_changed": False}
        journal.write_text(json.dumps(record, indent=2), encoding="utf-8")
    except BaseException:
        closed()
        if swapped:
            target.rename(session / "failed-candidate-v3")
            archive.rename(target)
        helper.rename(session / "failed-diagnostic-v3")
        backup.rename(helper)
        if journal.exists():
            journal.rename(session / "failed-update-v3.json")
        raise
    return record


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--session", type=Path, required=True)
    parser.add_argument("--game-root", type=Path, required=True)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--manifest-sha256", required=True)
    parser.add_argument("--candidate", type=Path, required=True)
    args = parser.parse_args()
    old_raw = (args.session / "candidate-v2-inputs/runtime.json").read_bytes()
    before_raw = (args.session / "before.json").read_bytes()
    new_raw = args.manifest.read_bytes()
    assert digest(old_raw) == "db9bac3a7d797b621df6656660024ac3890ec75d21d5f8e2263fb21470803e7a"
    assert digest(before_raw) == "4af7acc70e3c153672d44c74f4ed1b58190b74fd3129483207d8f91c722b14a7"
    assert digest(new_raw) == args.manifest_sha256
    assert digest((args.game_root / "isaac-ng.exe").read_bytes()) == "e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0"

    def closed():
        result = subprocess.run(["powershell.exe", "-NoProfile", "-Command",
                                 "@(Get-Process -Name 'isaac*' -ErrorAction SilentlyContinue).Count"],
                                check=True, capture_output=True, text=True)
        assert int(result.stdout.strip()) == 0, "Isaac must be closed"

    print(json.dumps(upgrade(args.session, args.game_root, json.loads(before_raw), json.loads(old_raw),
                             json.loads(new_raw), args.candidate, closed)))
