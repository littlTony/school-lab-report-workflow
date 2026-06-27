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
    $source = Join-Path $CodexSkillsRoot $skill
    $dest = Join-Path $SkillsRoot $skill
    if (-not (Test-Path -LiteralPath $source)) { throw "Missing installed skill: $source" }
    if (Test-Path -LiteralPath $dest) { Remove-Item -LiteralPath $dest -Recurse -Force }
    Copy-Item -LiteralPath $source -Destination $dest -Recurse
    Write-Host "Pulled $skill"
}

Write-Host 'Done. Project skills now match installed Codex skills.'
