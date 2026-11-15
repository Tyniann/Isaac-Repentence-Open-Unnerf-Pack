"""Quarantine crashing diagnostic generations; install manual-join-only helper."""
import argparse
import hashlib
import json
from pathlib import Path
import runpy
import subprocess


def digest(data):
    return hashlib.sha256(data).hexdigest()


def install(session, game, matrix, matrix_sha, source, closed):
    library = session / "install-issue19.py"
    assert digest(library.read_bytes()) == "93d073fe8e621fc130d4be7303315c8f679150141a6bbc42499f6665a9a37470"
    methods = runpy.run_path(str(library), run_name="validated_swap_library")
    inventory, swap = methods["inventory"], methods["swap"]
    target = game / "mods/oup_blank_card_issue19_batch"
    production = game / "mods/Open Unnerf Pack 2/Mods/Blank Card Jera Unnerf/main.lua"
    production_sha = "6beb2862bad6a5feb083b7d9b4fbabc017ee936bf054c53b9a9ab166229b2025"
    assert digest(production.read_bytes()) == production_sha
    old = inventory(target)
    expected = {
        "main.lua": "bfec07380b1d3f98e942b17207e78661e1b82c63dfa1a4dc9f4b15ab2fe5dca0",
        "batch.lua": "febcb67b030d00bc8556c423b01509c7a8e36f766104371a30a9c95c5c30f794",
        "matrix.lua": "21bce95185f01034b64c24c39935fabc12755d91f9bbbd3a87a3470dc31afc45",
        "matrix-v3.lua": "21bce95185f01034b64c24c39935fabc12755d91f9bbbd3a87a3470dc31afc45",
        "matrix-v4.lua": "26215f61f2dc50957414384b010a491924c12600ddb2d3245214341e868fa8fa",
    }
    assert set(old) == set(expected) | {"metadata.xml"}, "Unexpected diagnostic files"
    for name, sha in expected.items():
        assert old[name]["sha256"] == sha, "Unexpected diagnostic bytes: " + name
    raw = matrix.read_bytes()
    assert digest(raw) == matrix_sha
    staged, archive = session / "diagnostic-safe-coop-new", session / "diagnostic-unsafe-coop"
    journal = session / "diagnostic-coop-guard.json"
    assert not staged.exists() and not archive.exists() and not journal.exists()
    closed()
    staged.mkdir()
    for name in ("main.lua", "batch.lua", "metadata.xml"):
        (staged / name).write_bytes((target / name).read_bytes())
    (staged / "matrix.lua").write_bytes(raw)
    wanted = {name: old[name] for name in ("main.lua", "batch.lua", "metadata.xml")}
    wanted["matrix.lua"] = {"size": len(raw), "sha256": matrix_sha}
    swap(staged, target, archive, wanted, old, closed)
    assert inventory(target) == wanted and inventory(archive) == old
    assert digest(production.read_bytes()) == production_sha
    record = {"status": "installed", "source_commit": source, "matrix_sha256": matrix_sha,
              "helper_files": inventory(target), "unsafe_helper_archive": str(archive),
              "unsafe_files_removed_from_mod_path": ["matrix-v3.lua", "matrix-v4.lua"],
              "production_changed": False, "profile_changed": False,
              "game_data_changed": False, "game_started": False}
    journal.write_text(json.dumps(record, indent=2), encoding="utf-8")
    return record


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--session", type=Path, required=True)
    parser.add_argument("--game-root", type=Path, required=True)
    parser.add_argument("--matrix", type=Path, required=True)
    parser.add_argument("--matrix-sha256", required=True)
    parser.add_argument("--source-commit", required=True)
    args = parser.parse_args()

    def closed():
        result = subprocess.run(["powershell.exe", "-NoProfile", "-Command",
                                 "@(Get-Process -Name 'isaac*' -ErrorAction SilentlyContinue).Count"],
                                check=True, capture_output=True, text=True)
        assert int(result.stdout.strip()) == 0, "Isaac must be closed"

    print(json.dumps(install(args.session, args.game_root, args.matrix, args.matrix_sha256,
                             args.source_commit, closed)))
