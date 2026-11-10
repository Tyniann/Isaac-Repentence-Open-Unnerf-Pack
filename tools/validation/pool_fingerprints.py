"""Compare same-seed native pool outputs; check build provenance separately."""
import argparse
import json
from pathlib import Path


def read(path, label, phase):
    records = {}
    seeds = set()
    complete_count = None
    for line in Path(path).read_text(encoding="utf-8-sig").splitlines():
        marker = "OUP_POOL "
        if marker not in line:
            continue
        record = json.loads(line.split(marker, 1)[1])
        if record.get("label") != label:
            continue
        if record.get("kind") == "fingerprint_complete" and record.get("pass") is True:
            complete_count = record["pools"]
        if record.get("kind") != "fingerprint" or record.get("phase") != phase:
            continue
        key = (record["poolID"], record["pool"])
        if key in records:
            raise ValueError("duplicate pool profile; use a unique test label")
        if len(record["outputs"]) != 64:
            raise ValueError("incomplete native output profile")
        records[key] = record["outputs"]
        seeds.add(record["seed"])
    if not records or complete_count != len(records) or len(seeds) != 1:
        raise ValueError("missing/incomplete profile or mixed run seeds")
    return records, seeds


def compare(baseline, candidate, baseline_label, candidate_label, phase):
    expected, seeds = read(baseline, baseline_label, phase)
    actual, other_seeds = read(candidate, candidate_label, phase)
    if seeds != other_seeds:
        raise ValueError("start seeds differ; this is not a controlled comparison")
    if expected.keys() != actual.keys():
        raise ValueError("native pool sets differ")
    differences = [name for key, name in expected if expected[(key, name)] != actual[(key, name)]]
    if differences:
        raise ValueError("native pool outputs differ: " + ", ".join(differences))
    return {"pass": True, "phase": phase, "pools": len(expected), "queries": len(expected) * 64}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--baseline", required=True)
    parser.add_argument("--candidate", required=True)
    parser.add_argument("--baseline-label", required=True)
    parser.add_argument("--candidate-label", required=True)
    parser.add_argument("--phase", choices=("full", "without_magic"), required=True)
    args = parser.parse_args()
    print(json.dumps(compare(args.baseline, args.candidate, args.baseline_label, args.candidate_label, args.phase)))
