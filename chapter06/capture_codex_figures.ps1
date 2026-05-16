$ErrorActionPreference = "Stop"

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("11", "12", "13", "14", "15")]
    [string]$Figure,

    [int]$DelaySeconds = 5
)

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

$outDir = Join-Path $PSScriptRoot "figures"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$names = @{
    "11" = "figure_11_actual_codex_tasks_thread.png"
    "12" = "figure_12_actual_browser_preview_comment.png"
    "13" = "figure_13_actual_computer_use_permission.png"
    "14" = "figure_14_actual_artifact_viewer.png"
    "15" = "figure_15_actual_cli_permissions_model.png"
}

Write-Host ""
Write-Host "Prepare the screen for Figure $Figure."
Write-Host "Capture starts in $DelaySeconds seconds."
Write-Host "Tip: keep private paths, emails, tokens, and customer data hidden."
Write-Host ""

for ($i = $DelaySeconds; $i -ge 1; $i--) {
    Write-Host "$i..."
    Start-Sleep -Seconds 1
}

$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = New-Object System.Drawing.Bitmap($bounds.Width, $bounds.Height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)

$path = Join-Path $outDir $names[$Figure]
$bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)

$graphics.Dispose()
$bitmap.Dispose()

Write-Host ""
Write-Host "Saved: $path"
