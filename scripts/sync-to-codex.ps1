$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$SkillsRoot = Join-Path $ProjectRoot 'skills'
$CodexSkillsRoot = Join-Path $env:USERPROFILE '.codex\skills'
$SkillNames = @(
    'school-lab-report',
    'school-lab-md-expander',
    'school-lab-data-analysis',
    'school-lab-method-conclusion',
    'school-lab-docx-report',
    'school-lab-report-pipeline'
)

foreach ($skill in $SkillNames) {
    $source = Join-Path $SkillsRoot $skill
    $dest = Join-Path $CodexSkillsRoot $skill
    if (-not (Test-Path -LiteralPath $source)) { throw "Missing project skill: $source" }
    Get-ChildItem -LiteralPath $CodexSkillsRoot -Directory -Filter "$skill.backup-*" | ForEach-Object {
        Remove-Item -LiteralPath $_.FullName -Recurse -Force
        Write-Host "Removed old backup $($_.FullName)"
    }
    if (Test-Path -LiteralPath $dest) {
        Remove-Item -LiteralPath $dest -Recurse -Force
        Write-Host "Removed existing $dest"
    }
    Copy-Item -LiteralPath $source -Destination $dest -Recurse
    Write-Host "Synced $skill"
}

Write-Host 'Done. Restart Codex or open a new thread to load updated skills. Only the latest school-lab skills are kept.'
