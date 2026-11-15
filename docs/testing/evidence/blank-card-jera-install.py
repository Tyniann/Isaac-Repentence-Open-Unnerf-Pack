"""One-session guarded pack swap. Never launches Isaac or edits profile/data."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess


def digest(data):
    return hashlib.sha256(data).hexdigest()


def inventory(root):
    result = {}
    for path in root.rglob('*'):
        if path.is_symlink():
            raise RuntimeError(f'Unexpected symlink: {path}')
        if path.is_file():
            data = path.read_bytes()
            result[path.relative_to(root).as_posix()] = {'size': len(data), 'sha256': digest(data)}
    return result


def swap(candidate, target, original, expected_candidate, expected_original, closed):
    closed()
    if original.exists() or not target.is_dir() or not candidate.is_dir():
        raise RuntimeError('Original archive exists or a required tree is absent')
    if inventory(candidate) != expected_candidate:
        raise RuntimeError('Staged candidate differs from pinned manifest')
    if inventory(target) != expected_original:
        raise RuntimeError('Installed original pack differs from initial backup')
    closed()
    target.rename(original)
    try:
        candidate.rename(target)
        if inventory(target) != expected_candidate:
            raise RuntimeError('Installed candidate hash mismatch')
    except BaseException:
        if target.exists():
            failed = original.with_name('failed-candidate')
            if failed.exists():
                raise RuntimeError('Rollback destination occupied; preserve both trees for assessment')
            target.rename(failed)
        original.rename(target)
        raise


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--session', type=Path, required=True)
    parser.add_argument('--game-root', type=Path, required=True)
    args = parser.parse_args()
    session, game = args.session, args.game_root
    before_raw = (session / 'before.json').read_bytes()
    assert digest(before_raw) == '4af7acc70e3c153672d44c74f4ed1b58190b74fd3129483207d8f91c722b14a7'
    manifest_raw = (session / 'candidate-4563-inputs/candidate-runtime.json').read_bytes()
    assert digest(manifest_raw) == 'b7026ac330ca2ebc11c5b741d6b9ebb9ed7e27c33aca3d3a36c5708502afd481'
    before, manifest = json.loads(before_raw), json.loads(manifest_raw)
    assert manifest['source_commit'] == '4563fd522e3086817c21fc89f1677f63262fc53c'
    assert digest((game / 'isaac-ng.exe').read_bytes()) == 'e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0'
    prefix = 'Open Unnerf Pack 2/'
    old_files = before['inventory']['backup-mods']['files']
    expected_original = {name[len(prefix):]: {'size': info['bytes'], 'sha256': info['sha256']}
                         for name, info in old_files.items() if name.startswith(prefix)}
    assert expected_original, 'No original-pack snapshot'
    mods = game / 'mods'
    protected = {name: {'size': info['bytes'], 'sha256': info['sha256']}
                 for name, info in old_files.items() if not name.startswith(prefix)}
    current = inventory(mods)
    for name, value in protected.items():
        if current.get(name) != value:
            raise RuntimeError(f'Protected original mod changed: {name}')

    def closed():
        command = "@(Get-Process -Name 'isaac*' -ErrorAction SilentlyContinue).Count"
        result = subprocess.run(['powershell.exe', '-NoProfile', '-Command', command],
                                check=True, capture_output=True, text=True)
        if int(result.stdout.strip()) != 0:
            raise RuntimeError('Isaac must be closed')

    journal = session / 'candidate-install.json'
    if journal.exists():
        raise RuntimeError('Install journal already exists; assess it before resuming')
    closed()
    swap(session / 'candidate-4563', mods / 'Open Unnerf Pack 2', session / 'original-pack',
         manifest['files'], expected_original, closed)
    after = inventory(mods)
    assert all(after.get(name) == value for name, value in protected.items())
    record = {'status': 'installed', 'source_commit': manifest['source_commit'],
              'files': len(manifest['files']), 'original_pack': str(session / 'original-pack'),
              'installed_pack': str(mods / 'Open Unnerf Pack 2'), 'game_started': False,
              'profile_changed': False, 'game_data_changed': False, 'protected_mods_verified': True}
    journal.write_text(json.dumps(record, indent=2), encoding='utf-8')
    print(json.dumps(record))
