"""Static helper definitions: not an Isaac engine test."""
from decimal import Decimal
from pathlib import Path
import xml.etree.ElementTree as ET

helper = "OUP Magic Mushroom Pool Entry"
expected = {
    "treasure": ("1", "1", "0.1"),
    "boss": ("1", "1", "0.1"),
    "greedTreasure": ("0.5", "0.5", "0.05"),
    "greedBoss": ("0.2", "0.2", "0.02"),
    "ultraSecret": ("1", "0.4", "0.1"),
}
items = ET.parse("content/items.xml").getroot()
assert len(items) == 1 and items[0].tag == "passive"
assert items[0].get("name") == helper
assert items[0].get("quality") == "4"
assert set(items[0].get("tags").split()) == {"summonable", "mushroom", "offensive"}
assert not items[0].get("id"), "let Isaac allocate a private ID"
for effect in ("hearts", "maxhearts", "cache", "damage", "speed"):
    assert items[0].get(effect) is None, "helper must not apply real item effects"

pools = ET.parse("content/itempools.xml").getroot()
assert len(pools) == 5
assert {p.get("Name") for p in pools} == set(expected)
for pool in pools:
    assert len(pool) == 1, "one helper entry per pool"
    entry = pool[0]
    assert entry.get("Name") == helper and entry.get("Id") is None
    values = tuple(Decimal(entry.get(k)) for k in ("Weight", "DecreaseBy", "RemoveOn"))
    assert values == tuple(map(Decimal, expected[pool.get("Name")])), pool.attrib

assert not Path("resources/itempools.xml").exists(), "no full vanilla pool replacement"
assert not Path("resources-dlc3/itempools.xml").exists()
print("pool asset definitions passed (XML/source contract; engine validation pending)")
