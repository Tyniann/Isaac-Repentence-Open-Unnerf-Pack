$ErrorActionPreference = 'Stop'
function Assert-Closed {
    $running = @(Get-Process | Where-Object { $_.ProcessName -like 'isaac*' })
    if ($running.Count -ne 0) { throw 'Isaac is running; leave all files unchanged' }
}
function Hash([string]$Path) {
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}
function Snapshot([string]$Root) {
    if (-not (Test-Path -LiteralPath $Root -PathType Container)) { throw "Missing protected directory: $Root" }
    $prefix = [IO.Path]::GetFullPath($Root).TrimEnd([char]92) + '\'
    $records = @(Get-ChildItem -LiteralPath $Root -Recurse -Force -File | Sort-Object FullName | ForEach-Object {
        [ordered]@{path=$_.FullName.Substring($prefix.Length).Replace('\','/'); size=[int64]$_.Length; sha256=(Hash $_.FullName)}
    })
    return (ConvertTo-Json -InputObject $records -Depth 5 -Compress)
}
function Write-Json([string]$Path, $Value) {
    if (Test-Path -LiteralPath $Path) { throw 'Do not overwrite evidence' }
    [IO.File]::WriteAllText($Path, (ConvertTo-Json -InputObject $Value -Depth 10), (New-Object Text.UTF8Encoding($false)))
}
Assert-Closed
$gameRoot = 'D:\The.Binding.of.Isaac.Repentance.v4.0.2'
$modsRoot = Join-Path $gameRoot 'mods'
$source = Join-Path $modsRoot 'open_unnerf_validation_observer'
$expected = @{
    'main.lua'='32e56e884c63ea2a3153f1b0b9b278850a0c6ebe83af2a16a26c1a3699156e2c'
    'metadata.xml'='c8a8fa15763dc0b445c4196a132e6fcb0ab4b5ec68bc74120ff232c2ccefa302'
}
$files = @(Get-ChildItem -LiteralPath $source -Recurse -File)
if ($files.Count -ne 2) { throw 'Unexpected observer inventory' }
foreach ($name in $expected.Keys) {
    if ($expected[$name].Length -ne 64) { throw 'Malformed expected SHA256' }
    if ((Hash (Join-Path $source $name)) -ne $expected[$name]) { throw "Observer differs: $name" }
}
$exe = Join-Path $gameRoot 'isaac-ng.exe'
$exeHash = Hash $exe
if ($exeHash -ne 'e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0') { throw 'Executable differs' }
$roots = [ordered]@{
    pack=(Join-Path $modsRoot 'open_unnerf_pack_validation')
    mcm=(Join-Path $modsRoot 'mod_config_menu_pure')
    gameData=(Join-Path $gameRoot 'data')
    userData='C:\Users\Mario\Documents\My Games\Binding of Isaac Repentance+'
}
$beforeProtected = [ordered]@{}
foreach ($key in $roots.Keys) { $beforeProtected[$key] = Snapshot $roots[$key] }
$observerBefore = Snapshot $source
$modsBefore = @(Get-ChildItem -LiteralPath $modsRoot -Directory | Select-Object -ExpandProperty Name | Sort-Object)
$session = 'D:\T3ValidationArchives\issue4-cleanup-' + [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffZ') + '-' + [Guid]::NewGuid().ToString('N').Substring(0,8)
if (Test-Path -LiteralPath $session) { throw 'Cleanup session exists' }
if ([IO.Path]::GetPathRoot($source) -ne [IO.Path]::GetPathRoot($session)) { throw 'Must remain on same volume' }
[IO.Directory]::CreateDirectory($session) | Out-Null
$destination = Join-Path $session 'open_unnerf_validation_observer'
Write-Json (Join-Path $session 'before.json') ([ordered]@{roots=$roots; protected=$beforeProtected; observer=$observerBefore; mods=$modsBefore; executableSha256=$exeHash})
Assert-Closed
Move-Item -LiteralPath $source -Destination $destination
$afterProtected = [ordered]@{}
foreach ($key in $roots.Keys) {
    $afterProtected[$key] = Snapshot $roots[$key]
    if ($beforeProtected[$key] -cne $afterProtected[$key]) { throw "Protected files changed: $key" }
}
$observerAfter = Snapshot $destination
if ($observerBefore -cne $observerAfter) { throw 'Archive differs from source' }
if (Test-Path -LiteralPath $source) { throw 'Observer still installed' }
$modsAfter = @(Get-ChildItem -LiteralPath $modsRoot -Directory | Select-Object -ExpandProperty Name | Sort-Object)
$expectedMods = @($modsBefore | Where-Object { $_ -ne 'open_unnerf_validation_observer' })
if (($modsAfter -join '|') -cne ($expectedMods -join '|')) { throw 'Unrelated mod directory listing changed' }
if ((Hash $exe) -ne $exeHash) { throw 'Executable changed' }
Assert-Closed
Write-Json (Join-Path $session 'after.json') ([ordered]@{protected=$afterProtected; observer=$observerAfter; mods=$modsAfter; executableSha256=(Hash $exe)})
$counts = [ordered]@{}
foreach ($key in $roots.Keys) {
    $inventory = ConvertFrom-Json -InputObject $beforeProtected[$key]
    $counts[$key] = $inventory.Count
}
$result = [ordered]@{status='observer-archived'; session=$session; archive=$destination; gameClosed=$true; protectedUnchanged=$true; observerFiles=2; protectedFiles=$counts; beforeSha256=(Hash (Join-Path $session 'before.json')); afterSha256=(Hash (Join-Path $session 'after.json'))}
Write-Json (Join-Path $session 'result.json') $result
$result | ConvertTo-Json -Depth 6
