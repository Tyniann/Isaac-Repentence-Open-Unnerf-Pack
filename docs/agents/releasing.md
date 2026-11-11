# Releases and Steam Workshop

[Technical documentation](README.md)

Use this workflow when the owner requests a release. Updating this guide alone
does not create a release. GitHub publication and Steam Workshop publication are
separate operations; an unavailable Workshop account does not block GitHub.

## 1. Synchronize and prepare the version

Use Git, Python 3.10+, an authenticated GitHub CLI (`gh`), and `sha256sum`.
The command examples run from the repository root in the same Bash session.
Follow [subagent assignments](subagents.md) for routine execution and computer
use, and the root [pull-request instructions](../../AGENTS.md#pull-requests)
when release changes go through a PR.

1. Inspect the branch and working tree, fetch `origin`, and synchronize `master`
   with a fast-forward-only pull when safe. Preserve unrelated tracked edits and
   untracked notes. Finish any release PR integration before selecting the
   commit to package.
2. Inspect recent releases/tags and merged commits. Audit player-facing changes
   against [changelog rules](../../.agents/skills/changelog-rules/SKILL.md) and
   keep the relevant [documentation](../../.agents/skills/documentation-rules/SKILL.md)
   accurate. Development-only documentation does not require a release or
   changelog entry by itself.
3. Choose the next Semantic Versioning number. Update `<version>` in
   `metadata.xml`, move qualifying `Unreleased` entries into
   `## [X.Y.Z] - YYYY-MM-DD` using the release date, and leave a new empty
   `Unreleased` section. The metadata version, changelog version, and `vX.Y.Z`
   tag must agree. The first public fork release was **2.0.0**; do not invent
   historical release sections for the original project.
4. Keep the display name **Open Unnerf Pack 2**, internal registration, settings
   keys, schema, and metadata directory `open unnerf pack` stable. Apply the
   [Workshop identity rules](#prepare-the-first-steam-workshop-listing) below.
5. Run checks appropriate to the changes and record commands/results. Use the
   maintained [tests](../../tests/) and [validation guides](README.md#tools-and-validation).
   Gameplay changes retain their required acceptance checks; use
   [shared game validation](game-validation.md) for engine work. Packaging or
   documentation changes alone do not require another gameplay run. Existing
   evidence applies only while its inputs and acceptance conditions still hold.
6. Stage only the intended release changes and commit with
   `chore: release version X.Y.Z`. Resolve any later corrections before pinning
   the final source commit. A follow-up correction can make the final release
   SHA differ from that initial release commit.

Proceed when the release source is integrated on `master`, its tracked changes
are committed, and the new version/tag is available. If a tag or release already
exists, inspect it before acting: resume only the same source snapshot. Published
tags and assets stay tied to their original content; changed content needs a new
version.

## 2. Build and verify the exact snapshot

Capture the final commit rather than relying on a moving branch name:

```sh
set -euo pipefail
release_repo="Tyniann/Isaac-Repentence-Open-Unnerf-Pack"
release_version=$(python3 -c 'import xml.etree.ElementTree as E; print(E.parse("metadata.xml").getroot().findtext("version"))')
release_tag="v${release_version}"
release_commit=$(git rev-parse HEAD)
release_artifacts=$(mktemp -d "/tmp/open-unnerf-${release_tag}.XXXXXX")
release_zip="Open-Unnerf-Pack-2-${release_tag}.zip"
release_manifest="Open-Unnerf-Pack-2-${release_tag}.manifest.json"
release_notes="${release_artifacts}/release-notes.md"

python3 tools/release/build_release.py --ref "$release_commit" --output-dir "$release_artifacts"
(cd "$release_artifacts" && sha256sum -c SHA256SUMS.txt)
python3 -m zipfile -t "$release_artifacts/$release_zip"
python3 -m zipfile -l "$release_artifacts/$release_zip"
```

The [builder](../../tools/release/build_release.py) reads committed files only.
Its ZIP has exactly one top-level `Open Unnerf Pack 2` folder containing the Lua
entry points, `Mods/`, `content/`, any tracked `resources/`, `LICENSE`,
`docs/CHANGELOG.md`, and generated `README.txt`. It excludes developer tools,
test observers, saves, untracked files, and optional MCM. Check that any newly
required runtime assets fit the builder's allowlist before releasing.

Three files are release assets:

| File | Purpose |
| --- | --- |
| `Open-Unnerf-Pack-2-vX.Y.Z.zip` | Installable mod and Workshop payload |
| `Open-Unnerf-Pack-2-vX.Y.Z.manifest.json` | Exact source commit, package hash, per-file sizes/hashes, and Workshop metadata state |
| `SHA256SUMS.txt` | SHA-256 checks for the ZIP and manifest |

Before tagging, confirm all of the following:

- The manifest's `source_commit` equals `$release_commit`, and its version agrees
  with the packaged metadata and dated changelog section.
- The archive layout puts `main.lua`, `config.lua`, `metadata.xml`, `Mods/`, and
  `content/` directly inside the single mod folder. The full MIT license and
  original copyright notice are included.
- Runtime Lua/content bytes match the pinned source, and the metadata follows
  the documented Workshop ID policy. The builder verifies ZIP integrity and
  written content; inspect its manifest and metadata as well.
- Rebuilding into a fresh directory with the same Python/zlib toolchain produces
  identical ZIP, manifest, and checksum files. Existing artifact filenames are
  protected against overwriting; use a fresh output directory for each build.

Any correction after this step changes the source snapshot: commit it, capture
the new SHA, rebuild, and repeat the affected checks before tagging.

## 3. Tag, push, and publish

Write release notes to `$release_notes` as a real multiline file. Use the dated
changelog entries, game target, installation/update instructions, optional MCM
and F10 guidance, feature links, original-author credit, and compatibility
evidence with its limits. Identify the named ZIP as the installation download;
GitHub's automatic source archives are development snapshots. Keep the notes
outside the mod payload and pass them with `--notes-file`.

With the source and package verified, create an annotated tag at that exact SHA
and push the branch/tag together. Confirm the remote `master` can accept a
normal fast-forward; preserve concurrent work if the push is rejected.

```sh
test -s "$release_notes"
test "$(git branch --show-current)" = "master"
test "$(git rev-parse HEAD)" = "$release_commit"
git tag -a "$release_tag" "$release_commit" -m "Open Unnerf Pack 2 $release_tag"
git push --atomic origin master "refs/tags/${release_tag}"

gh release create "$release_tag" \
  "$release_artifacts/$release_zip" \
  "$release_artifacts/$release_manifest" \
  "$release_artifacts/SHA256SUMS.txt" \
  --repo "$release_repo" --verify-tag --latest \
  --title "Open Unnerf Pack 2 $release_tag" --notes-file "$release_notes"
```

This is the normal stable public release path. Use prerelease/draft options only
when that is the requested release type, and set latest status accordingly.
`--verify-tag` prevents GitHub from silently creating a missing tag at a different
commit. Upload only the three intended assets; notes and local validation logs
are not mod downloads. If publication partially fails, inspect the existing
draft/assets and resume the same tag and verified files instead of creating a
second release or moving the tag.

## 4. Verify publication and hand off

Read back the release and download its actual published assets:

```sh
gh release view "$release_tag" --repo "$release_repo" \
  --json url,tagName,name,isDraft,isPrerelease,publishedAt,assets
test "$(gh api "repos/${release_repo}/releases/latest" --jq .tag_name)" = "$release_tag"
release_download=$(mktemp -d "/tmp/open-unnerf-published-${release_tag}.XXXXXX")
gh release download "$release_tag" --repo "$release_repo" --dir "$release_download"
(cd "$release_download" && sha256sum -c SHA256SUMS.txt)
cmp "$release_artifacts/$release_zip" "$release_download/$release_zip"
cmp "$release_artifacts/$release_manifest" "$release_download/$release_manifest"
python3 -m zipfile -t "$release_download/$release_zip"
git rev-parse "${release_tag}^{commit}"
git ls-remote origin refs/heads/master "refs/tags/${release_tag}" "refs/tags/${release_tag}^{}"
git status --short
```

Completion means the release has the requested public/prerelease state and all
three uploaded assets, the downloaded hashes/content match the verified build,
and the remote annotated tag resolves to the manifest's source SHA. Confirm the
checkout is synchronized with `origin/master` and all intended changes are
committed while preserving unrelated work. Keep local artifact/evidence files
until verification is complete; remove only task-owned temporary branches or
worktrees, if any.

Report the release page, direct ZIP link, version/source SHA, verification
results, and any remaining compatibility limits or Workshop blocker. A new
documentation commit after publication belongs to the development branch; it
does not require replacing an existing release or moving its tag.

## Prepare the first Steam Workshop listing

**Use the same ZIP as the public GitHub release.** Extract it before using the
uploader; it uploads a mod folder through `metadata.xml`, rather than accepting a
ZIP directly. A separate internal release is needed only if Workshop preparation
requires different mod contents; link that release in the owner handoff.

The source metadata has no Workshop ID until this fork receives its own listing.
The builder also removes the original project's ID `2554325871` when packaging
an older compatible snapshot that still contains it. The metadata directory and
Lua registration are unchanged, preserving their settings identity. Once the
fork has its own ID, record it in source metadata; the builder preserves IDs
other than the original project's ID.

1. Extract the release ZIP to a staging directory. Confirm that its
   `Open Unnerf Pack 2/metadata.xml` has no `<id>` for the first upload. Use a
   Steam account that owns the game and is signed in to the Steam client.
2. Open the game's bundled **ModUploader.exe** under its `tools` directory
   (commonly `tools/ModUploader/ModUploader.exe`; layouts can vary). On the shared
   Windows installation, begin under
   `D:\The.Binding.of.Isaac.Repentance.v4.0.2\tools`.
3. Choose the extracted folder's `metadata.xml`. Check the title, description,
   version, tags, and desired visibility. The bundled description already
   credits KeinNiemand and links this fork's issue tracker. Select a preview
   image for the listing; keep it outside the staged mod folder unless the mod
   itself uses it.
4. Upload when the owner is ready to publish on Steam. If Steam requests
   agreement to the Workshop terms, complete that step. Open the new listing,
   confirm its ID differs from `2554325871`, check its visibility and description,
   link this repository, and list the required game DLC. Describe MCM Pure as
   optional so players can use the pack without it.
5. Retain the metadata containing the newly assigned ID. For subsequent updates,
   use that listing's ID and an increased version. If replacing staged files
   with a release made before the new ID was recorded, preserve that ID in the
   staging metadata before uploading again.

Preparing a GitHub release does not upload anything to Steam or exercise the
uploader. Record the assigned Workshop URL after the owner publishes it, then
update the public README and metadata to point to the maintained listing.

## Steam ownership and initialization failures

The uploading account needs a Steam license for the game. A GOG purchase does
not provide that license, and Valve explicitly excludes temporary licenses such
as Family Sharing from Workshop uploads. GitHub/manual releases remain usable
without a Workshop listing; leave the metadata ID absent until one is created.

An uploader message saying Steam API initialization failed is a general startup
failure, not a diagnosis of Steam being closed. Valve also documents missing
application ID information, differing Windows user/administrator contexts, and
missing ownership as possible causes. If the owner has a Steam license, check
those prerequisites before investigating the mod files. Launch Steam and the
uploader under the same Windows user and privilege level.

## Sources

- [IsaacScript directory structure](https://isaacscript.github.io/main/directory-structure/):
  `metadata.xml` is ModUploader's entry point; a mod ID is added on first upload.
- [IsaacScript publishing workflow](https://isaacscript.github.io/main/publishing-to-the-workshop/):
  the uploader is bundled with the game. Its
  [version-writing implementation](https://github.com/IsaacScript/isaacscript/blob/72a71fa56e27fc62b78831f7a15c12429226bef8/packages/isaacscript-cli/src/commands/publish/publish.ts#L168-L176)
  writes the release version string into metadata.
- [Valve Workshop implementation guide](https://partner.steamgames.com/doc/features/workshop/implementation):
  creating a new item uses an unset/zero published-file ID; updates use the
  assigned ID. Its API/SteamCMD examples establish the distinction, while Isaac
  uses its bundled uploader.
- [Valve ISteamUGC reference](https://partner.steamgames.com/doc/api/isteamugc):
  upload content, preview images, visibility, and Workshop terms.
- [Valve Steam API initialization](https://partner.steamgames.com/doc/api/steam_api?l=french&language=english#SteamAPI_Init):
  ownership and other conditions required for initialization.
- [Valve Workshop FAQ](https://partner.steamgames.com/doc/features/workshop):
  temporary licenses and Family Sharing do not permit uploads.

---
*Last updated: 2026-11-11*
