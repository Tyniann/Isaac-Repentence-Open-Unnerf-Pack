"""Public log-comparison contract, not an engine pool test."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile


def profile(label, outputs, seed=123):
    return "\n".join("[INFO] OUP_POOL " + json.dumps(row) for row in (
        {"kind": "fingerprint", "label": label, "phase": "without_magic", "poolID": 3,
         "pool": "POOL_BOSS", "seed": seed, "outputs": outputs},
        {"kind": "fingerprint_complete", "label": label, "pass": True, "pools": 1, "seed": seed},
    ))


with tempfile.TemporaryDirectory() as tmp:
    baseline, candidate = Path(tmp) / "baseline.log", Path(tmp) / "candidate.log"
    baseline.write_text(profile("BASE", [1, 2, 3, 4] * 16))
    command = [sys.executable, "tools/validation/pool_fingerprints.py", "--baseline", str(baseline),
               "--candidate", str(candidate), "--baseline-label", "BASE", "--candidate-label", "ON",
               "--phase", "without_magic"]
    candidate.write_text(profile("ON", [1, 2, 3, 4] * 16))
    assert subprocess.run(command, capture_output=True).returncode == 0
    candidate.write_text(profile("ON", [1, 2, 3, 5] * 16))
    changed = subprocess.run(command, capture_output=True, text=True)
    assert changed.returncode != 0 and "POOL_BOSS" in changed.stderr
    candidate.write_text(profile("ON", [1, 2, 3, 4] * 16, seed=124))
    assert subprocess.run(command, capture_output=True).returncode != 0
    candidate.write_text(profile("ON", [1, 2, 3, 4] * 16) + "\n" + profile("ON", [1, 2, 3, 4] * 16))
    assert subprocess.run(command, capture_output=True).returncode != 0
    valid = profile("ON", [1, 2, 3, 4] * 16)
    records = valid.splitlines()
    foreign_completion = json.loads(records[-1].split("OUP_POOL ", 1)[1])
    foreign_completion["seed"] = 124
    candidate.write_text(records[0] + "\n[INFO] OUP_POOL " + json.dumps(foreign_completion))
    assert subprocess.run(command, capture_output=True).returncode != 0, "completion must belong to the profile run"
    candidate.write_text(valid + "\n" + records[-1])
    duplicate = subprocess.run(command, capture_output=True, text=True)
    assert duplicate.returncode != 0 and "completion" in duplicate.stderr
print("pool fingerprint comparison contracts passed (engine outputs not yet collected)")
