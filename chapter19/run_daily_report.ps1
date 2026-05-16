# run_daily_report.ps1 - create a daily PR report with Codex CLI.
# Usage: powershell -ExecutionPolicy Bypass -File run_daily_report.ps1

$ErrorActionPreference = "Stop"

Push-Location $PSScriptRoot
try {
    $date = Get-Date -Format "yyyy-MM-dd"
    $reportDir = Join-Path $PSScriptRoot "reports"
    if (-not (Test-Path $reportDir)) {
        New-Item -ItemType Directory -Path $reportDir | Out-Null
    }

    $out = Join-Path $reportDir "daily_$date.md"
    $log = Join-Path $reportDir "daily_$date.codex.log"
    $prompt = "Read sample-prs.md and create a Korean one-line team report summary plus PR counts by author."

    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        & codex exec --skip-git-repo-check --sandbox read-only --output-last-message $out $prompt > $log 2>&1
        $exitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }

    if ($exitCode -ne 0) {
        throw "codex exec failed with exit code $exitCode. See $log"
    }
    if (Test-Path -LiteralPath $log) {
        Remove-Item -LiteralPath $log
    }

    Write-Host "Report generated: $out"
    Get-Content -Encoding UTF8 $out
}
finally {
    Pop-Location
}
