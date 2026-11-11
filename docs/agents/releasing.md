# Releases and Steam Workshop

[Technical documentation](README.md)

## Prepare a GitHub release

Use this workflow when the owner requests a release. The release version lives
in `metadata.xml`; use `MAJOR.MINOR.PATCH` for both it and the `vX.Y.Z` Git tag.
The first public release of this maintained fork is **2.0.0**, following the
original project's metadata version 1.2.

1. Fetch and synchronize the release branch while preserving unrelated local
   work. Compare recent merged player-facing changes against
   [changelog rules](../../.agents/skills/changelog-rules/SKILL.md).
2. Update `metadata.xml` and move `Unreleased` entries into the dated version
   section in `docs/CHANGELOG.md`. Leave a new empty `Unreleased` section. Keep
   the display name **Open Unnerf Pack 2**, internal registration, settings keys,
   schema, and metadata directory `open unnerf pack` stable.
3. Run checks appropriate to the changes, then make the authorized release
   commit with `chore: release version X.Y.Z`. Package that exact commit:

   ```sh
   python3 tools/release/build_release.py --ref HEAD --output-dir /tmp/ounp-release-X.Y.Z
   ```

   The builder reads committed files only. It excludes untracked files, developer
   tools, test observers, saves, and optional MCM. It creates a ZIP with one
   `Open Unnerf Pack 2` folder, a file/hash manifest, and `SHA256SUMS.txt`.
   Rebuilding the same snapshot with the same Python/zlib toolchain produces
   identical outputs; use a new output directory for each build.
4. Inspect the ZIP's root, required runtime files and XML, and verify checksums.
   Compare its Lua and content files with the source commit. The full MIT
   license and original copyright notice must be present. Changes limited to
   packaging and documentation do not replace prior engine evidence or require
   playing a new test run.
5. Push the commit and annotated tag, then publish a GitHub release with the ZIP,
   manifest, and checksums attached. Base release notes on the versioned
   changelog, link the existing compatibility evidence and its limits, and mark
   the release as latest. Verify the published asset names and downloadable ZIP.

The release ZIP contains `main.lua`, `config.lua`, `metadata.xml`, `Mods/`,
`content/`, any tracked `resources/`, `LICENSE`, `docs/CHANGELOG.md`, and generated
installation notes. Source archives remain available for development; the named
release asset is the installation package.

## Prepare the first Steam Workshop listing

**Use the same ZIP as the public GitHub release.** Extract it before using the
uploader; it uploads a mod folder through `metadata.xml`, rather than accepting a
ZIP directly. A separate internal release is unnecessary.

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
