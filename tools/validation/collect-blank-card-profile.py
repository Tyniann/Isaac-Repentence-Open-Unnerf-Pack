"""Preserve a stable native log and exact issue-19 observer records; no game input."""
import argparse
import hashlib
import json
from pathlib import Path
import re


def digest(data):
    return hashlib.sha256(data).hexdigest()


def collect(source, output):
    before = source.stat()
    data = source.read_bytes()
    after = source.stat()
    second = source.read_bytes()
    stable = (before.st_size, before.st_mtime_ns) == (after.st_size, after.st_mtime_ns)
    stable = stable and data == second
    output.mkdir(parents=True, exist_ok=False)
    (output / "log.txt").write_bytes(data)
    records, malformed, errors, context = [], [], [], []
    marker = "OUP_BLANK_CARD "
    for line in data.decode("utf-8", errors="replace").splitlines():
        if marker in line:
            payload = line.split(marker, 1)[1]
            try:
                record = json.loads(payload)
                if not isinstance(record, dict) or "event" not in record or "label" not in record:
                    raise ValueError("invalid observer record")
                records.append(record)
            except (ValueError, TypeError):
                malformed.append(line)
        if re.search(r"Lua Error|stack traceback|Error in callback", line, re.I):
            errors.append(line)
        if re.search(r"Repentance\+|Game Version|Mod Config Menu|Open Unnerf|Blank Card Jera Probe", line):
            context.append(line)
    (output / "records.jsonl").write_text(
        "".join(json.dumps(record) + "\n" for record in records), encoding="utf-8")
    (output / "malformed.txt").write_text("\n".join(malformed), encoding="utf-8")
    summary = {"source": str(source), "output": str(output), "stable": stable,
        "source_before": {"bytes": before.st_size, "mtime_ns": before.st_mtime_ns},
        "source_after": {"bytes": after.st_size, "mtime_ns": after.st_mtime_ns},
        "log_sha256": digest(data), "second_read_sha256": digest(second),
        "records_sha256": digest((output / "records.jsonl").read_bytes()),
        "records": len(records), "malformed": len(malformed), "errors": errors,
        "context": context[-30:], "recent_records": records[-20:]}
    (output / "capture.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(json.dumps(summary))
    return summary


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args()
    result = collect(args.source, args.output_dir)
    if not result["stable"]:
        raise SystemExit("Capture raced a live write; preserved bytes are diagnostic only")
