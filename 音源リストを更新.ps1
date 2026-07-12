# 音源フォルダをスキャンして manifest.json を作るスクリプト
# 使い方: このファイルを右クリック →「PowerShell で実行」
#         または PowerShell で  .\音源リストを更新.ps1

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$soundDir = Join-Path $root '音源'
$exts = @('.mp3','.wav','.m4a','.ogg','.flac','.aac','.opus','.webm')

if (-not (Test-Path $soundDir)) {
    Write-Host "音源フォルダが見つかりません: $soundDir" -ForegroundColor Red
    Read-Host "Enterキーで終了"
    exit 1
}

$files = Get-ChildItem -Path $soundDir -File |
    Where-Object { $exts -contains $_.Extension.ToLower() } |
    Sort-Object Name |
    ForEach-Object { $_.Name }

$json = ConvertTo-Json @($files) -Compress
$outPath = Join-Path $soundDir 'manifest.json'
[System.IO.File]::WriteAllText($outPath, $json, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "manifest.json を更新しました（$($files.Count) 曲）" -ForegroundColor Green
$files | ForEach-Object { Write-Host "  🎵 $_" }
Read-Host "`nEnterキーで終了"
