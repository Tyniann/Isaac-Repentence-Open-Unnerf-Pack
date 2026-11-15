"""Contract smoke for staging; no network or game-directory writes."""
import hashlib
import importlib.util
from pathlib import Path
import tempfile
import urllib.parse

source = Path(__file__).resolve().parents[1] / "tools/validation/stage-source-pack.py"
spec = importlib.util.spec_from_file_location("stager", source)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

payload = {"main.lua": b"-- main", "config.lua": b"-- config", "LICENSE": b"license",
           "docs/CHANGELOG.md": b"# Changes", "content/items.xml": b"<items />",
           "content/itempools.xml": b"<ItemPools />",
           "metadata.xml": b"<metadata><name>Open Unnerf Pack 2</name><directory>open unnerf pack</directory></metadata>",
           "Mods/Blank Card Jera Unnerf/main.lua": b"-- module"}
manifest = {"source_commit": "a" * 40, "files": {
    name: {"size": len(data), "sha256": hashlib.sha256(data).hexdigest()}
    for name, data in payload.items()}}


def fetch(url):
    prefix = module.REPOSITORY + "/" + "a" * 40 + "/"
    assert url.startswith(prefix)
    return payload[urllib.parse.unquote(url[len(prefix):])]


with tempfile.TemporaryDirectory() as directory:
    root = Path(directory)
    result = module.stage(manifest, root / "candidate", fetch)
    assert result["status"] == "staged" and not result["game_directory_changed"]
    assert (root / "candidate/Mods/Blank Card Jera Unnerf/main.lua").read_bytes() == payload["Mods/Blank Card Jera Unnerf/main.lua"]
    try:
        module.stage(manifest, root / "candidate", fetch)
    except FileExistsError:
        pass
    else:
        raise AssertionError("overwrote staged candidate")
    for name in ("../escape", "Mods/../../escape", "Mods\\escape", "tools/tool.py"):
        invalid = {**manifest, "files": {**manifest["files"], name: {"size": 0, "sha256": "0" * 64}}}
        try:
            module.stage(invalid, root / "invalid", fetch)
        except ValueError:
            pass
        else:
            raise AssertionError("accepted unsafe/non-runtime path")
        assert not (root / "invalid").exists()
    try:
        module.stage(manifest, root / "bad-bytes", lambda _: b"wrong source bytes")
    except ValueError as error:
        assert "source hash/size mismatch" in str(error)
    else:
        raise AssertionError("accepted different source bytes")
print("Runtime staging smoke passed: exact source bytes, safe paths, overwrite refusal and hash rejection")
