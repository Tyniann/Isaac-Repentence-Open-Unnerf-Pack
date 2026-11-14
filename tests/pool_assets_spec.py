"""Static helper definitions: not an Isaac engine test."""
from decimal import Decimal
from pathlib import Path
import xml.etree.ElementTree as ET

magic_mushroom = "OUP Magic Mushroom Pool Entry"
sack_head = "OUP Sack Head Pool Entry"
expected_magic = {
    "treasure": ("1", "1", "0.1"),
    "boss": ("1", "1", "0.1"),
    "greedTreasure": ("0.5", "0.5", "0.05"),
    "greedBoss": ("0.2", "0.2", "0.02"),
    "ultraSecret": ("1", "0.4", "0.1"),
}
helpers = {
    magic_mushroom: ("4", {"summonable", "mushroom", "offensive"}),
    sack_head: ("3", {"summonable", "offensive"}),
}
# Afterbirth 1.06.0109 and Afterbirth+ 1.06.J168 native XML both contain
# exactly this Shop row and no Greed/Secret entries for Sack Head (issue #20).
expected = {(magic_mushroom, pool): values for pool, values in expected_magic.items()}
expected[sack_head, "shop"] = ("1", "0.5", "0.1")
items = ET.parse("content/items.xml").getroot()
assert len(items) == len(helpers)
assert {item.get("name") for item in items} == set(helpers)
for item in items:
    quality, tags = helpers[item.get("name")]
    assert item.tag == "passive"
    assert item.get("quality") == quality
    assert set(item.get("tags").split()) == tags
    assert not item.get("id"), "let Isaac allocate a private ID"
    for effect in ("hearts", "maxhearts", "cache", "damage", "speed"):
        assert item.get(effect) is None, "helper must not apply real item effects"

pools = ET.parse("content/itempools.xml").getroot()
assert len(pools) == 6
assert {p.get("Name") for p in pools} == {pool for _, pool in expected}
actual = {}
for pool in pools:
    for entry in pool:
        key = entry.get("Name"), pool.get("Name")
        assert key in expected and key not in actual, "unexpected or duplicate helper row"
        assert entry.get("Id") is None
        actual[key] = tuple(Decimal(entry.get(k)) for k in ("Weight", "DecreaseBy", "RemoveOn"))
assert actual == {key: tuple(map(Decimal, values)) for key, values in expected.items()}

assert not Path("resources/itempools.xml").exists(), "no full vanilla pool replacement"
assert not Path("resources-dlc3/itempools.xml").exists()
print("pool asset definitions passed (XML/source contract; engine validation pending)")
