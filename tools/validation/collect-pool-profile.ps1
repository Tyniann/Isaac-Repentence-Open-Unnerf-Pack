param(
    [Parameter(Mandatory=$true)][string]$LogPath,
    [Parameter(Mandatory=$true)][string]$OutputRoot,
    [Parameter(Mandatory=$true)][string]$Label
)
$ErrorActionPreference = 'Stop'

function Read-SharedBytes([string]$Path) {
    # OpenRead/Get-FileHash can reject a live writer. Every source read, including
    # the before/after hashes, must allow the game's existing write handle.
    $stream = [IO.File]::Open($Path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $buffer = New-Object IO.MemoryStream
    try { $stream.CopyTo($buffer); return ,$buffer.ToArray() }
    finally { $buffer.Dispose(); $stream.Dispose() }
}
function Get-BytesHash([byte[]]$Bytes) {
    $hasher = [Security.Cryptography.SHA256]::Create()
    try { return [BitConverter]::ToString($hasher.ComputeHash($Bytes)).Replace('-', '').ToLowerInvariant() }
    finally { $hasher.Dispose() }
}

$captureName = 'capture-' + [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffZ') + '-' + [Guid]::NewGuid().ToString('N').Substring(0, 8)
$destination = Join-Path $OutputRoot $captureName
if (Test-Path -LiteralPath $destination) { throw 'Capture already exists; never overwrite evidence' }
New-Item -ItemType Directory -Path $destination | Out-Null
$beforeInfo = Get-Item -LiteralPath $LogPath
$before = @{length=$beforeInfo.Length; mtimeUtc=$beforeInfo.LastWriteTimeUtc.ToString('o')}
[byte[]]$bytes = Read-SharedBytes $LogPath
$before.sha256 = Get-BytesHash $bytes
$copy = Join-Path $destination 'log.txt'
[IO.File]::WriteAllBytes($copy, $bytes)
[byte[]]$afterBytes = Read-SharedBytes $LogPath
$afterInfo = Get-Item -LiteralPath $LogPath
$after = @{length=$afterInfo.Length; mtimeUtc=$afterInfo.LastWriteTimeUtc.ToString('o'); sha256=(Get-BytesHash $afterBytes)}
$stable = $before.length -eq $bytes.Length -and $before.length -eq $after.length -and
    $after.length -eq $afterBytes.Length -and $before.mtimeUtc -eq $after.mtimeUtc -and $before.sha256 -eq $after.sha256

$selected = New-Object 'System.Collections.Generic.List[string]'
$malformed = New-Object 'System.Collections.Generic.List[string]'
$records = New-Object 'System.Collections.Generic.List[object]'
foreach ($line in ([Text.Encoding]::UTF8.GetString($bytes) -split '\r?\n')) {
    $marker = 'OUP_POOL '
    $index = $line.IndexOf($marker)
    if ($index -lt 0) { continue }
    $payload = $line.Substring($index + $marker.Length)
    try { $record = $payload | ConvertFrom-Json }
    catch { $malformed.Add($payload); continue }
    if ($record.label -eq $Label) { $selected.Add($payload); $records.Add($record) }
}
$utf8 = New-Object Text.UTF8Encoding($false)
$jsonl = Join-Path $destination 'pool-records.jsonl'
[IO.File]::WriteAllLines($jsonl, $selected.ToArray(), $utf8)
[IO.File]::WriteAllLines((Join-Path $destination 'malformed.jsonl'), $malformed.ToArray(), $utf8)
$capture = @{label=$Label; stable=$stable; before=$before; after=$after;
    log=$copy; logSha256=(Get-BytesHash ([IO.File]::ReadAllBytes($copy)));
    records=$jsonl; recordsSha256=(Get-BytesHash ([IO.File]::ReadAllBytes($jsonl)));
    selectedRecords=$selected.Count; malformedRecords=$malformed.Count;
    states=@($records.ToArray() | Where-Object { $_.kind -eq 'state' });
    completions=@($records.ToArray() | Where-Object { $_.kind -eq 'fingerprint_complete' })}
[IO.File]::WriteAllText((Join-Path $destination 'capture.json'), ($capture | ConvertTo-Json -Depth 12), $utf8)
$capture | ConvertTo-Json -Depth 12
