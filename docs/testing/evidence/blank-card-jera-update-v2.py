"""Frozen issue-19 update recipe. Keeps the original pre-test pack untouched."""
import argparse
import hashlib
import json
from pathlib import Path
import runpy
import shutil
import subprocess


def digest(data):
    return hashlib.sha256(data).hexdigest()


def upgrade(session, game, before, previous, current, candidate, matrix_file, loader_file, closed):
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
    assert original.is_dir() and inventory(original) == original_files, "Original pre-test pack changed"
    protected = {name: {"size": value["bytes"], "sha256": value["sha256"]}
                 for name, value in saved.items() if not name.startswith(prefix)}
    actual = inventory(mods)
    assert all(actual.get(name) == value for name, value in protected.items()), "Protected mod changed"
    helper = mods / "oup_blank_card_issue19_batch"
    assert digest((helper / "main.lua").read_bytes()) == "febcb67b030d00bc8556c423b01509c7a8e36f766104371a30a9c95c5c30f794"
    assert digest((helper / "matrix.lua").read_bytes()) == "1df01a33e93e59ab7e47cd98b050ee3bfa42be9805b66aefd76c175e9ea8968e"
    assert not (helper / "batch.lua").exists(), "Unexpected helper generation"
    batch_bytes = (helper / "main.lua").read_bytes()
    matrix_bytes, loader_bytes = matrix_file.read_bytes(), loader_file.read_bytes()
    old_candidate = session / "candidate-used-4563fd522e30"
    backup = session / "diagnostic-generation-v1"
    assert not backup.exists() and not old_candidate.exists(), "Update archive already exists"
    journal = session / "candidate-update-v2.json"
    assert not journal.exists(), "Update already recorded"
    closed()
    shutil.copytree(helper, backup)
    assert inventory(helper) == inventory(backup)
    swapped = False
    try:
        swap(candidate, target, old_candidate, current["files"], previous["files"], closed)
        swapped = True
        closed()
        (helper / "batch.lua").write_bytes(batch_bytes)
        (helper / "matrix.lua").write_bytes(matrix_bytes)
        (helper / "main.lua").write_bytes(loader_bytes)
        assert (helper / "batch.lua").read_bytes() == batch_bytes
        assert (helper / "matrix.lua").read_bytes() == matrix_bytes
        assert (helper / "main.lua").read_bytes() == loader_bytes
        assert inventory(original) == original_files
        after = inventory(mods)
        assert all(after.get(name) == value for name, value in protected.items())
    except BaseException:
        closed()  # Never roll back files beneath an unexpectedly running game.
        if swapped:
            target.rename(session / "failed-candidate-v2")
            old_candidate.rename(target)
        helper.rename(session / "failed-diagnostic-v2")
        backup.rename(helper)
        raise
    record = {"status": "installed", "source_commit": current["source_commit"],
              "previous_source": previous["source_commit"], "files": len(current["files"]),
              "original_pack": str(original), "previous_candidate": str(old_candidate),
              "helper_main_sha256": digest(loader_bytes), "matrix_sha256": digest(matrix_bytes),
              "batch_sha256": digest(batch_bytes), "game_started": False,
              "profile_changed": False, "game_data_changed": False}
    journal.write_text(json.dumps(record, indent=2), encoding="utf-8")
    return record


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--session", type=Path, required=True)
    parser.add_argument("--game-root", type=Path, required=True)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--manifest-sha256", required=True)
    parser.add_argument("--candidate", type=Path, required=True)
    parser.add_argument("--matrix", type=Path, required=True)
    parser.add_argument("--matrix-sha256", required=True)
    parser.add_argument("--loader", type=Path, required=True)
    parser.add_argument("--loader-sha256", required=True)
    args = parser.parse_args()
    old_raw = (args.session / "candidate-4563-inputs/candidate-runtime.json").read_bytes()
    before_raw = (args.session / "before.json").read_bytes()
    new_raw = args.manifest.read_bytes()
    assert digest(old_raw) == "b7026ac330ca2ebc11c5b741d6b9ebb9ed7e27c33aca3d3a36c5708502afd481"
    assert digest(before_raw) == "4af7acc70e3c153672d44c74f4ed1b58190b74fd3129483207d8f91c722b14a7"
    assert digest(new_raw) == args.manifest_sha256
    assert digest(args.matrix.read_bytes()) == args.matrix_sha256
    assert digest(args.loader.read_bytes()) == args.loader_sha256
    assert digest((args.game_root / "isaac-ng.exe").read_bytes()) == "e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0"

    def closed():
        result = subprocess.run(["powershell.exe", "-NoProfile", "-Command",
                                 "@(Get-Process -Name 'isaac*' -ErrorAction SilentlyContinue).Count"],
                                check=True, capture_output=True, text=True)
        assert int(result.stdout.strip()) == 0, "Isaac must be closed"

    print(json.dumps(upgrade(args.session, args.game_root, json.loads(before_raw), json.loads(old_raw),
                             json.loads(new_raw), args.candidate, args.matrix, args.loader, closed)))
