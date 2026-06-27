$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$SkillsRoot = Join-Path $ProjectRoot 'skills'
$SkillNames = @(
    'school-lab-report',
    'school-lab-md-expander',
    'school-lab-data-analysis',
    'school-lab-method-conclusion',
    'school-lab-docx-report',
    'school-lab-report-pipeline'
)

$errors = New-Object System.Collections.Generic.List[string]

foreach ($skill in $SkillNames) {
    $skillMd = Join-Path (Join-Path $SkillsRoot $skill) 'SKILL.md'
    if (-not (Test-Path -LiteralPath $skillMd)) { $errors.Add("Missing SKILL.md for $skill"); continue }
    $text = [System.IO.File]::ReadAllText($skillMd, [System.Text.Encoding]::UTF8)
    $frontmatterLines = ([regex]::Matches($text, '(?m)^---$')).Count
    $name = [regex]::Match($text, '(?m)^name:\s*(.+)$').Groups[1].Value.Trim()
    $description = [regex]::Match($text, '(?m)^description:\s*(.+)$').Groups[1].Value.Trim()
    $controlChars = $text.ToCharArray() | Where-Object { [int]$_ -lt 9 -and [int]$_ -ne 10 -and [int]$_ -ne 13 }
    if ($frontmatterLines -lt 2) { $errors.Add("$skill has invalid frontmatter delimiters") }
    if ($name -ne $skill) { $errors.Add("$skill name mismatch: $name") }
    if (-not $description) { $errors.Add("$skill missing description") }
    if ($controlChars.Count -gt 0) { $errors.Add("$skill has control characters") }
}

$requiredFiles = @(
    'skills\school-lab-docx-report\references\word-lab-report-rules.md',
    'skills\school-lab-docx-report\references\equations-omml.md',
    'skills\school-lab-docx-report\references\code-blocks.md',
    'docs\workflow.md',
    'skills-manifest.json'
)

foreach ($relative in $requiredFiles) {
    if (-not (Test-Path -LiteralPath (Join-Path $ProjectRoot $relative))) { $errors.Add("Missing required file: $relative") }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host 'Project validation passed.'
