$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

$rootDir = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $rootDir "figures"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$reportPath = Join-Path $PSScriptRoot "reports\daily_2026-05-16.md"
$jsonPath = Join-Path $PSScriptRoot "daily_report.json"

function New-Canvas {
    param([int]$Width = 1600, [int]$Height = 1000)
    $bmp = New-Object System.Drawing.Bitmap($Width, $Height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    $g.Clear([System.Drawing.Color]::FromArgb(246, 248, 251))
    return @($bmp, $g)
}

function FontN {
    param([float]$Size, [int]$Style = 0, [string]$Family = "Malgun Gothic")
    return New-Object System.Drawing.Font($Family, $Size, [System.Drawing.FontStyle]$Style)
}

function Brush {
    param([int]$R, [int]$G, [int]$B)
    return New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($R, $G, $B))
}

function PenC {
    param([int]$R, [int]$G, [int]$B, [float]$W = 1)
    return New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb($R, $G, $B), $W)
}

function Fill-RoundRect {
    param($G, [int]$X, [int]$Y, [int]$W, [int]$H, [int]$R, $Brush)
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $R * 2
    $path.AddArc($X, $Y, $d, $d, 180, 90)
    $path.AddArc($X + $W - $d, $Y, $d, $d, 270, 90)
    $path.AddArc($X + $W - $d, $Y + $H - $d, $d, $d, 0, 90)
    $path.AddArc($X, $Y + $H - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    $G.FillPath($Brush, $path)
    $path.Dispose()
}

function Draw-RoundRect {
    param($G, [int]$X, [int]$Y, [int]$W, [int]$H, [int]$R, $Pen)
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $R * 2
    $path.AddArc($X, $Y, $d, $d, 180, 90)
    $path.AddArc($X + $W - $d, $Y, $d, $d, 270, 90)
    $path.AddArc($X + $W - $d, $Y + $H - $d, $d, $d, 0, 90)
    $path.AddArc($X, $Y + $H - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    $G.DrawPath($Pen, $path)
    $path.Dispose()
}

function Text {
    param(
        $G,
        [string]$Value,
        [int]$X,
        [int]$Y,
        [float]$Size = 20,
        [string]$Color = "34,40,49",
        [int]$Style = 0,
        [string]$Family = "Malgun Gothic"
    )
    $parts = $Color.Split(",") | ForEach-Object { [int]$_ }
    $font = FontN $Size $Style $Family
    $brush = Brush $parts[0] $parts[1] $parts[2]
    $G.DrawString($Value, $font, $brush, $X, $Y)
    $font.Dispose()
    $brush.Dispose()
}

function TextBox {
    param(
        $G,
        [string]$Value,
        [int]$X,
        [int]$Y,
        [int]$W,
        [int]$H,
        [float]$Size = 20,
        [string]$Color = "34,40,49",
        [int]$Style = 0,
        [string]$Family = "Malgun Gothic"
    )
    $parts = $Color.Split(",") | ForEach-Object { [int]$_ }
    $font = FontN $Size $Style $Family
    $brush = Brush $parts[0] $parts[1] $parts[2]
    $format = New-Object System.Drawing.StringFormat
    $format.Trimming = [System.Drawing.StringTrimming]::EllipsisWord
    $rect = New-Object System.Drawing.RectangleF($X, $Y, $W, $H)
    $G.DrawString($Value, $font, $brush, $rect, $format)
    $format.Dispose()
    $font.Dispose()
    $brush.Dispose()
}

function Save-Figure {
    param($Bitmap, $Graphics, [string]$Name)
    $path = Join-Path $outDir $Name
    $Graphics.Dispose()
    $Bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $Bitmap.Dispose()
    Write-Output $path
}

function Draw-WindowFrame {
    param($G, [string]$Title)
    Fill-RoundRect $G 50 40 1500 900 12 (Brush 255 255 255)
    Draw-RoundRect $G 50 40 1500 900 12 (PenC 204 211 224 1.5)
    $G.FillRectangle((Brush 31 41 55), 50, 40, 1500, 54)
    Text $G $Title 80 53 17 "241,245,249" 1
}

function Draw-Terminal {
    param($G, [int]$X, [int]$Y, [int]$W, [int]$H, [string[]]$Lines)
    Fill-RoundRect $G $X $Y $W $H 8 (Brush 15 23 42)
    Text $G "TERMINAL" ($X + 22) ($Y + 15) 14 "148,163,184" 1 "Segoe UI"
    $yy = $Y + 56
    foreach ($line in $Lines) {
        if ($yy -gt ($Y + $H - 30)) { break }
        $color = "226,232,240"
        if ($line.StartsWith("PS ")) { $color = "125,211,252" }
        elseif ($line.StartsWith("{") -or $line.StartsWith("[")) { $color = "167,243,208" }
        elseif ($line.StartsWith("Report generated")) { $color = "134,239,172" }
        elseif ($line.StartsWith("OpenAI") -or $line.StartsWith("workdir") -or $line.StartsWith("exec")) { $color = "203,213,225" }
        TextBox $G $line ($X + 24) $yy ($W - 48) 30 15 $color 0 "Malgun Gothic"
        $yy += 32
    }
}

$json = (Get-Content -Raw -Encoding UTF8 -LiteralPath $jsonPath).Trim()
$report = (Get-Content -Raw -Encoding UTF8 -LiteralPath $reportPath).Trim()

# Figure 29: codex exec JSON result
$pair = New-Canvas
$bmp = $pair[0]
$g = $pair[1]
Draw-WindowFrame $g "chapter19 - codex exec JSON result"

$g.FillRectangle((Brush 248 250 252), 50, 94, 330, 846)
$g.DrawLine((PenC 214 220 230), 380, 94, 380, 940)
Text $g "EXPLORER" 82 126 14 "71,85,105" 1 "Segoe UI"
Text $g "CHAPTER19" 82 164 16 "15,23,42" 1 "Segoe UI"
$files29 = @("sample-prs.md", "schema.json", "daily_report.json", "run_daily_report.ps1", "reports")
$yy = 205
foreach ($file in $files29) {
    if ($file -eq "daily_report.json") {
        Fill-RoundRect $g 76 ($yy - 4) 270 34 5 (Brush 219 234 254)
        Text $g $file 101 $yy 15 "29,78,216" 1 "Segoe UI"
    }
    else {
        Text $g $file 101 $yy 15 "51,65,85" 0 "Segoe UI"
    }
    $yy += 42
}

Text $g "daily_report.json" 430 126 22 "15,23,42" 1 "Segoe UI"
Fill-RoundRect $g 430 170 1050 190 8 (Brush 248 250 252)
Draw-RoundRect $g 430 170 1050 190 8 (PenC 226 232 240)
TextBox $g $json 458 202 990 115 22 "22,101,52" 0 "Malgun Gothic"

$lines29 = @(
    "PS C:\Users\lovel\doit_codex\chapter19> codex exec --skip-git-repo-check --sandbox read-only --output-schema schema.json ""sample-prs.md summary as JSON"" > daily_report.json",
    "OpenAI Codex v0.131.0-alpha.9",
    "workdir: C:\Users\lovel\doit_codex\chapter19",
    "exec Get-Content -Path .\sample-prs.md succeeded",
    "codex",
    $json,
    "PS C:\Users\lovel\doit_codex\chapter19> Get-Content .\daily_report.json",
    $json
)
Draw-Terminal $g 430 400 1050 430 $lines29
Text $g "Figure 29. codex exec creates a structured daily_report.json file" 78 900 18 "71,85,105" 0 "Segoe UI"
Save-Figure $bmp $g "figure_29_codex_exec_json_result.png"

# Figure 31: daily report script
$pair = New-Canvas
$bmp = $pair[0]
$g = $pair[1]
Draw-WindowFrame $g "chapter19 - daily report automation"

$g.FillRectangle((Brush 248 250 252), 50, 94, 360, 846)
$g.DrawLine((PenC 214 220 230), 410, 94, 410, 940)
Text $g "EXPLORER" 82 126 14 "71,85,105" 1 "Segoe UI"
Text $g "CHAPTER19" 82 164 16 "15,23,42" 1 "Segoe UI"
$tree31 = @(
    "sample-prs.md",
    "schema.json",
    "run_daily_report.ps1",
    "reports",
    "  daily_2026-05-16.md"
)
$yy = 205
foreach ($item in $tree31) {
    if ($item.Trim() -eq "daily_2026-05-16.md") {
        Fill-RoundRect $g 76 ($yy - 4) 300 34 5 (Brush 220 252 231)
        Text $g $item 101 $yy 15 "22,101,52" 1 "Segoe UI"
    }
    elseif ($item -eq "reports") {
        Text $g "v  reports" 101 $yy 15 "15,23,42" 1 "Segoe UI"
    }
    else {
        Text $g $item 101 $yy 15 "51,65,85" 0 "Segoe UI"
    }
    $yy += 42
}

Text $g "reports/daily_2026-05-16.md" 460 126 22 "15,23,42" 1 "Segoe UI"
Fill-RoundRect $g 460 170 980 250 8 (Brush 255 255 255)
Draw-RoundRect $g 460 170 980 250 8 (PenC 226 232 240)
TextBox $g $report 492 205 910 170 24 "15,23,42" 0 "Malgun Gothic"

$lines31 = @(
    "PS C:\Users\lovel\doit_codex\chapter19> powershell -ExecutionPolicy Bypass -File run_daily_report.ps1",
    "Report generated: C:\Users\lovel\doit_codex\chapter19\reports\daily_2026-05-16.md",
    ($report -replace "`r?`n", "  ")
)
Draw-Terminal $g 460 470 980 340 $lines31
Text $g "Figure 31. run_daily_report.ps1 writes the daily Markdown report under reports" 78 900 18 "71,85,105" 0 "Segoe UI"
Save-Figure $bmp $g "figure_31_daily_auto_report.png"
