$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

$outDir = Join-Path $PSScriptRoot "figures"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

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
    param([float]$Size, [int]$Style = 0, [string]$Family = "Segoe UI")
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
    param($G, [string]$Value, [int]$X, [int]$Y, [float]$Size = 20, [string]$Color = "34,40,49", [int]$Style = 0, [string]$Family = "Segoe UI")
    $parts = $Color.Split(",") | ForEach-Object { [int]$_ }
    $font = FontN $Size $Style $Family
    $brush = Brush $parts[0] $parts[1] $parts[2]
    $G.DrawString($Value, $font, $brush, $X, $Y)
    $font.Dispose()
    $brush.Dispose()
}

function TextBox {
    param($G, [string]$Value, [int]$X, [int]$Y, [int]$W, [int]$H, [float]$Size = 20, [string]$Color = "34,40,49", [int]$Style = 0)
    $parts = $Color.Split(",") | ForEach-Object { [int]$_ }
    $font = FontN $Size $Style
    $brush = Brush $parts[0] $parts[1] $parts[2]
    $format = New-Object System.Drawing.StringFormat
    $format.Trimming = [System.Drawing.StringTrimming]::EllipsisWord
    $rect = New-Object System.Drawing.RectangleF($X, $Y, $W, $H)
    $G.DrawString($Value, $font, $brush, $rect, $format)
    $format.Dispose()
    $font.Dispose()
    $brush.Dispose()
}

function StatusPill {
    param($G, [string]$Value, [int]$X, [int]$Y, [string]$Kind)
    $bg = @{running=(219,239,255); review=(255,241,204); done=(220,245,229)}[$Kind]
    $fg = @{running="21,94,156"; review="128,82,0"; done="28,111,67"}[$Kind]
    Fill-RoundRect $G $X $Y 128 34 17 (Brush $bg[0] $bg[1] $bg[2])
    Text $G $Value ($X + 17) ($Y + 3) 15 $fg 1
}

function Save-Figure {
    param($Bitmap, $Graphics, [string]$Name)
    $path = Join-Path $outDir $Name
    $Graphics.Dispose()
    $Bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $Bitmap.Dispose()
    Write-Output $path
}

function Draw-AppFrame {
    param($G, [string]$Title)
    Fill-RoundRect $G 60 50 1480 880 14 (Brush 255 255 255)
    Draw-RoundRect $G 60 50 1480 880 14 (PenC 211 216 226 1.5)
    $G.FillRectangle((Brush 26 31 44), 60, 50, 1480, 64)
    Text $G "Codex" 92 67 22 "255,255,255" 1
    Text $G $Title 220 70 18 "225,231,239" 0
}

# Figure 11
$pair = New-Canvas; $bmp = $pair[0]; $g = $pair[1]
Draw-AppFrame $g "Task list and thread detail"
$g.FillRectangle((Brush 248 250 252), 60, 114, 430, 816)
$g.DrawLine((PenC 211 216 226), 490, 114, 490, 930)
Text $g "Task List" 92 146 24 "17,24,39" 1
$tasks = @(
    @("Web dashboard fix", "Running", "running"),
    @("PDF report draft", "Review", "review"),
    @("Test failure check", "Done", "done"),
    @("Sales report cleanup", "Done", "done")
)
$y = 198
foreach ($t in $tasks) {
    Fill-RoundRect $g 92 $y 360 92 8 (Brush 255 255 255)
    Draw-RoundRect $g 92 $y 360 92 8 (PenC 219 224 232)
    Text $g $t[0] 112 ($y + 15) 18 "29,36,48" 1
    Text $g "Updated 2 minutes ago" 112 ($y + 48) 14 "96,108,124"
    StatusPill $g $t[1] 312 ($y + 48) $t[2]
    $y += 112
}
Text $g "Thread" 530 146 24 "17,24,39" 1
Fill-RoundRect $g 530 195 900 110 8 (Brush 242 247 255)
TextBox $g "User: Increase the button spacing and make the mobile title wrap naturally." 555 222 850 65 19 "39,58,85"
Fill-RoundRect $g 530 330 900 150 8 (Brush 247 248 250)
TextBox $g "Codex: I checked the layout CSS. I will adjust toolbar gap and heading width, then verify the mobile preview." 555 358 850 85 19 "43,49,59"
Text $g "Result Summary" 530 548 24 "17,24,39" 1
Fill-RoundRect $g 530 596 900 210 8 (Brush 255 255 255)
Draw-RoundRect $g 530 596 900 210 8 (PenC 219 224 232)
Text $g "Files" 560 628 18 "29,36,48" 1
Text $g "app/styles.css, app/page.tsx" 760 628 18 "73,83,98"
Text $g "Tests" 560 680 18 "29,36,48" 1
Text $g "npm test passed, mobile screenshot checked" 760 680 18 "73,83,98"
Text $g "Next" 560 732 18 "29,36,48" 1
Text $g "Review, approve, or add another screen comment" 760 732 18 "73,83,98"
Text $g "Figure 11. Codex app task list and thread detail screen" 94 890 18 "85,94,108"
Save-Figure $bmp $g "figure_11_codex_tasks_thread.png"

# Figure 12
$pair = New-Canvas; $bmp = $pair[0]; $g = $pair[1]
Draw-AppFrame $g "Browser preview and screen comment"
$g.FillRectangle((Brush 238 241 246), 90, 134, 1420, 58)
Fill-RoundRect $g 130 148 860 30 15 (Brush 255 255 255)
Text $g "http://localhost:5173/preview" 155 151 15 "92,102,117"
$g.FillRectangle((Brush 255 255 255), 90, 192, 1000, 690)
Text $g "Sales Dashboard" 140 240 40 "19,28,45" 1
TextBox $g "Track monthly performance and regional revenue in one focused view." 142 300 600 60 20 "86,96,111"
Fill-RoundRect $g 142 390 190 56 8 (Brush 37 99 235)
Text $g "Save" 210 403 20 "255,255,255" 1
Fill-RoundRect $g 352 390 190 56 8 (Brush 243 244 246)
Text $g "Share" 417 403 20 "31,41,55" 1
Fill-RoundRect $g 142 510 250 170 8 (Brush 241 245 249)
Fill-RoundRect $g 420 510 250 170 8 (Brush 241 245 249)
Fill-RoundRect $g 698 510 250 170 8 (Brush 241 245 249)
Text $g "Comment" 1140 235 22 "17,24,39" 1
Fill-RoundRect $g 1120 280 330 160 8 (Brush 255 255 255)
Draw-RoundRect $g 1120 280 330 160 8 (PenC 219 224 232)
TextBox $g "Increase spacing in this button area, and make the title wrap naturally on mobile." 1145 305 280 100 18 "48,59,75"
$g.DrawLine((PenC 239 68 68 3), 1118, 360, 540, 418)
Fill-RoundRect $g 520 400 44 44 22 (Brush 239 68 68)
Text $g "1" 535 405 20 "255,255,255" 1
Text $g "Figure 12. Adding a screen comment in browser preview" 94 890 18 "85,94,108"
Save-Figure $bmp $g "figure_12_browser_preview_comment.png"

# Figure 13
$pair = New-Canvas; $bmp = $pair[0]; $g = $pair[1]
Draw-AppFrame $g "Computer Use permission request"
Fill-RoundRect $g 450 210 700 520 10 (Brush 255 255 255)
Draw-RoundRect $g 450 210 700 520 10 (PenC 200 207 218 2)
Text $g "Computer Use Permission" 500 260 30 "17,24,39" 1
TextBox $g "Codex wants to view the screen and perform clicks or typing. Check the target app and task scope before approving." 500 320 600 80 20 "73,83,98"
Fill-RoundRect $g 500 430 600 130 8 (Brush 248 250 252)
Text $g "Target" 530 455 18 "29,36,48" 1
Text $g "Test browser window" 690 455 18 "73,83,98"
Text $g "Allowed" 530 500 18 "29,36,48" 1
Text $g "Click, type, inspect screen" 690 500 18 "73,83,98"
Text $g "Scope" 530 545 18 "29,36,48" 1
Text $g "Current task session" 690 545 18 "73,83,98"
Fill-RoundRect $g 500 610 180 58 8 (Brush 243 244 246)
Text $g "Deny" 565 625 20 "31,41,55" 1
Fill-RoundRect $g 920 610 180 58 8 (Brush 37 99 235)
Text $g "Allow" 980 625 20 "255,255,255" 1
Text $g "Figure 13. Computer Use permission request screen" 94 890 18 "85,94,108"
Save-Figure $bmp $g "figure_13_computer_use_permission.png"

# Figure 14
$pair = New-Canvas; $bmp = $pair[0]; $g = $pair[1]
Draw-AppFrame $g "Artifact preview"
$g.FillRectangle((Brush 248 250 252), 60, 114, 360, 816)
$g.DrawLine((PenC 211 216 226), 420, 114, 420, 930)
Text $g "Artifacts" 95 150 24 "17,24,39" 1
Fill-RoundRect $g 95 205 285 78 8 (Brush 255 255 255)
Draw-RoundRect $g 95 205 285 78 8 (PenC 219 224 232)
Text $g "deck_v1.pdf" 120 222 18 "29,36,48" 1
Text $g "PDF - generated" 120 252 15 "93,105,120"
Fill-RoundRect $g 95 305 285 78 8 (Brush 255 255 255)
Text $g "review_notes.txt" 120 322 18 "29,36,48" 1
Text $g "2 human checks" 120 352 15 "93,105,120"
Fill-RoundRect $g 500 165 790 660 8 (Brush 255 255 255)
Draw-RoundRect $g 500 165 790 660 8 (PenC 200 207 218 2)
Text $g "2026 Sales Strategy" 575 245 42 "17,24,39" 1
TextBox $g "Generated presentation preview" 580 310 600 40 22 "83,94,110"
Fill-RoundRect $g 580 410 250 160 8 (Brush 232 240 254)
Fill-RoundRect $g 870 410 250 160 8 (Brush 235 248 238)
Text $g "Q1" 660 458 38 "37,99,235" 1
Text $g "Growth" 925 458 38 "34,139,80" 1
Fill-RoundRect $g 1320 165 160 48 8 (Brush 37 99 235)
Text $g "Revise" 1370 176 17 "255,255,255" 1
Fill-RoundRect $g 1320 245 160 48 8 (Brush 243 244 246)
Text $g "Download" 1348 256 17 "31,41,55" 1
TextBox $g "Location: figures/presentation_sample.pdf`nChecked: page count, title, file opens`nHuman check: source numbers, logo rights" 500 845 760 70 17 "73,83,98"
Text $g "Figure 14. Viewing a generated PDF or presentation in artifact viewer" 94 890 18 "85,94,108"
Save-Figure $bmp $g "figure_14_artifact_viewer.png"

# Figure 15
$pair = New-Canvas; $bmp = $pair[0]; $g = $pair[1]
$g.Clear([System.Drawing.Color]::FromArgb(250, 250, 250))
Fill-RoundRect $g 120 85 1360 800 8 (Brush 255 255 255)
Draw-RoundRect $g 120 85 1360 800 8 (PenC 190 197 208 2)
$g.FillRectangle((Brush 233 236 241), 120, 85, 1360, 48)
Text $g "Codex CLI - light theme" 150 96 18 "31,41,55" 1
$mono = New-Object System.Drawing.Font("Consolas", 25, [System.Drawing.FontStyle]::Regular)
$brushDark = Brush 30 41 59
$brushMuted = Brush 100 116 139
$lines = @(
    "PS C:\project> codex",
    "codex> /model",
    "Current model: gpt-5.5",
    "Available: gpt-5.5, gpt-5.4, gpt-5.4-mini",
    "",
    "codex> /permissions",
    "Workspace: write access to current folder",
    "Network: restricted",
    "Approval: ask before external apps or destructive commands",
    "",
    "codex> codex features list",
    "image input       enabled",
    "browser preview   enabled",
    "computer use      request approval"
)
$yy = 165
foreach ($line in $lines) {
    $b = $brushDark
    if ($line -like "Available:*" -or $line -like "Workspace:*" -or $line -like "Network:*" -or $line -like "Approval:*" -or $line -like "image*" -or $line -like "browser*" -or $line -like "computer*") {
        $b = $brushMuted
    }
    $g.DrawString($line, $mono, $b, 160, $yy)
    $yy += 46
}
$mono.Dispose()
$brushDark.Dispose()
$brushMuted.Dispose()
Text $g "Figure 15. Checking /permissions and /model in CLI" 140 910 18 "85,94,108"
Save-Figure $bmp $g "figure_15_cli_permissions_model.png"
