# make_daily_briefing.ps1 - create a daily morning briefing with Codex CLI.
# Usage: powershell -ExecutionPolicy Bypass -File make_daily_briefing.ps1

$ErrorActionPreference = "Stop"

Push-Location $PSScriptRoot
try {
    $date = Get-Date -Format "yyyy-MM-dd"
    $out = Join-Path $PSScriptRoot "daily_briefing_$date.md"
    $log = Join-Path $PSScriptRoot "daily_briefing_$date.codex.log"
    $prompt = "Read every file in the sources folder and write a Korean morning briefing: 3 key changes, risks to watch, and today's action items."

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

    Write-Host "Briefing generated: $out"
    Get-Content -Encoding UTF8 $out
}
finally {
    Pop-Location
}
