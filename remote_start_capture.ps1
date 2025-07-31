param (
    [string]$LogFile
)

$MitmPath = "mitmdump"

# Crear carpeta del log
$folder = [System.IO.Path]::GetDirectoryName($LogFile)
if (!(Test-Path $folder)) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

# Lanzar mitmdump muy simplificado y explícito
Start-Process -FilePath $MitmPath -ArgumentList "-w `"$LogFile`"" -WindowStyle Hidden
