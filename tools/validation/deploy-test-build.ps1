param(
    [Parameter(Mandatory=$true)][string]$ManifestPath,
    [Parameter(Mandatory=$true)][string]$ObserverPath,
    [Parameter(Mandatory=$true)][string]$ObserverMetadataPath,
    [Parameter(Mandatory=$true)][string]$SessionRoot,
    [string]$GameRoot = 'D:\The.Binding.of.Isaac.Repentance.v4.0.2',
    [switch]$UpdatePack,
    [switch]$StageOnly
)
$ErrorActionPreference = 'Stop'
if (-not $StageOnly -and (Get-Process | Where-Object { $_.ProcessName -like 'isaac*' })) { throw 'Isaac must be closed' }
$manifest = Get-Content -Raw -LiteralPath $ManifestPath | ConvertFrom-Json
$folders = @('open_unnerf_pack_validation','mod_config_menu_pure','open_unnerf_validation_observer')
$mods = Join-Path $GameRoot 'mods'
if ($UpdatePack) {
    if ([IO.Path]::GetPathRoot([IO.Path]::GetFullPath($SessionRoot)) -ne [IO.Path]::GetPathRoot([IO.Path]::GetFullPath($GameRoot))) {
        throw 'Update session must share the game volume for reversible directory moves'
    }
    if (-not (Test-Path -LiteralPath (Join-Path $mods 'open_unnerf_pack_validation'))) { throw 'Expected existing pack absent' }
    if (-not (Test-Path -LiteralPath (Join-Path $mods 'mod_config_menu_pure'))) { throw 'Expected existing MCM absent' }
    $folders = @('open_unnerf_pack_validation','open_unnerf_validation_observer')
}
foreach ($folder in $folders) {
    if ($UpdatePack -and $folder -eq 'open_unnerf_pack_validation') { continue }
    if (Test-Path -LiteralPath (Join-Path $mods $folder)) { throw "Destination already exists: $folder" }
}
$deployment = Join-Path $SessionRoot 'deployment'
if (Test-Path -LiteralPath $deployment) { throw 'Session deployment already exists; do not overwrite' }
New-Item -ItemType Directory -Path $deployment | Out-Null
foreach ($kind in @('pack','mcm')) {
    $spec = $manifest.archives.$kind
    $zip = Join-Path $deployment "$kind.zip"
    Invoke-WebRequest -UseBasicParsing -Uri $spec.url -OutFile $zip
    if ((Get-FileHash -Algorithm SHA256 -LiteralPath $zip).Hash.ToLower() -ne $spec.sha256) {
        throw "Archive hash mismatch: $kind"
    }
    Expand-Archive -LiteralPath $zip -DestinationPath (Join-Path $deployment $kind)
}
$packRoot = Join-Path $deployment ('pack\Isaac-Repentence-Open-Unnerf-Pack-' + $manifest.pack_sha)
$mcmRoot = Join-Path $deployment ('mcm\isaac-mod-config-menu-' + $manifest.mcm_sha)
$payload = Join-Path $deployment 'payload'
foreach ($entry in $manifest.files.PSObject.Properties) {
    $parts = $entry.Name.Split('/',2)
    if ($parts[1].Split('/') -contains '..') { throw 'Invalid manifest path' }
    switch ($parts[0]) {
        'open_unnerf_pack_validation' { $source = Join-Path $packRoot $parts[1] }
        'mod_config_menu_pure' { $source = Join-Path $mcmRoot $parts[1] }
        'open_unnerf_validation_observer' {
            if ($parts[1] -eq 'main.lua') { $source = $ObserverPath }
            elseif ($parts[1] -eq 'metadata.xml') { $source = $ObserverMetadataPath }
            else { throw 'Unknown observer file' }
        }
        default { throw 'Unknown payload folder' }
    }
    if ((Get-FileHash -Algorithm SHA256 -LiteralPath $source).Hash.ToLower() -ne $entry.Value.sha256) {
        throw "Source hash mismatch: $($entry.Name)"
    }
    $target = Join-Path $payload $entry.Name
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
    Copy-Item -LiteralPath $source -Destination $target
}
if ($UpdatePack) {
    foreach ($entry in $manifest.files.PSObject.Properties) {
        if ($entry.Name.StartsWith('mod_config_menu_pure/')) {
            $current = Join-Path $mods $entry.Name
            if (-not (Test-Path -LiteralPath $current) -or (Get-FileHash -Algorithm SHA256 -LiteralPath $current).Hash.ToLower() -ne $entry.Value.sha256) {
                throw "Installed MCM differs; it will not be replaced: $($entry.Name)"
            }
        }
    }
}
if ($StageOnly) {
    @{status='staged-files-verified'; sourceSha=$manifest.pack_sha; payload=$payload;
        updatePack=[bool]$UpdatePack; gameDirectoryChanged=$false; engineVerified=$false} | ConvertTo-Json
    return
}
# All downloaded/runtime bytes are verified before any game-directory mutation.
if (Get-Process | Where-Object { $_.ProcessName -like 'isaac*' }) { throw 'Isaac opened during staging; stop' }
$backup = Join-Path $SessionRoot 'backup'
New-Item -ItemType Directory -Path $backup | Out-Null
$userData = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'My Games\Binding of Isaac Repentance+'
if (-not (Test-Path -LiteralPath $userData)) { throw 'Expected user-data path absent' }
Copy-Item -LiteralPath $userData -Destination (Join-Path $backup 'repentance-plus-user-data') -Recurse
$gameData = Join-Path $GameRoot 'data'
if (Test-Path -LiteralPath $gameData) {
    Copy-Item -LiteralPath $gameData -Destination (Join-Path $backup 'game-mod-data') -Recurse
}
$before = @{gameRoot=$GameRoot; userData=$userData; sourceSha=$manifest.pack_sha;
    createdFolders=$folders; originalFolderAbsence=(-not $UpdatePack); updatePack=[bool]$UpdatePack; optionsChanged=$false;
    originalMods=@(Get-ChildItem -LiteralPath $mods -Directory | Select-Object -ExpandProperty Name)}
$before | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 (Join-Path $backup 'before.json')
if (Get-Process | Where-Object { $_.ProcessName -like 'isaac*' }) { throw 'Isaac opened during backup; stop' }
$originalPack = Join-Path $backup 'original-pack'
if ($UpdatePack) {
    Move-Item -LiteralPath (Join-Path $mods 'open_unnerf_pack_validation') -Destination $originalPack
}
try {
    foreach ($folder in $folders) {
        if ($UpdatePack) {
            Move-Item -LiteralPath (Join-Path $payload $folder) -Destination (Join-Path $mods $folder)
        } else {
            Copy-Item -LiteralPath (Join-Path $payload $folder) -Destination (Join-Path $mods $folder) -Recurse
        }
    }
    foreach ($entry in $manifest.files.PSObject.Properties) {
        $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $mods $entry.Name)).Hash.ToLower()
        if ($actual -ne $entry.Value.sha256) { throw "Installed hash mismatch: $($entry.Name)" }
    }
} catch {
    $deploymentError = $_
    if ($UpdatePack) {
        foreach ($folder in $folders) {
            $installed = Join-Path $mods $folder
            if (Test-Path -LiteralPath $installed) {
                Move-Item -LiteralPath $installed -Destination (Join-Path $backup ("failed-" + $folder))
            }
        }
        Move-Item -LiteralPath $originalPack -Destination (Join-Path $mods 'open_unnerf_pack_validation')
    }
    throw $deploymentError
}
Copy-Item -LiteralPath $ManifestPath -Destination (Join-Path $SessionRoot 'installed-manifest.json')
@{status='installed-files-verified'; sourceSha=$manifest.pack_sha; mcmVersion=$manifest.mcm_version;
    runtimeFiles=$manifest.files.PSObject.Properties.Count; backup=$backup;
    session=$SessionRoot; gameStarted=$false; engineVerified=$false} | ConvertTo-Json -Depth 4
