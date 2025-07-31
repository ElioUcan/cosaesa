param (
    [string]$BrowserPath,
    [string]$Mode
)

# Validar que la ruta del navegador existe
if (!(Test-Path $BrowserPath)) {
    Write-Output "[X] Navegador no encontrado: $BrowserPath"
    exit 1
}

# Definir la URL y el proxy
$Url = "http://httpbin.org"
$Proxy = "--proxy-server=127.0.0.1:8080"

# Construir los argumentos para el navegador
$Args = $Proxy

# Validar y agregar el modo "incognito" si aplica
if ($Mode -eq "incognito") {
    if ($BrowserPath -like "*firefox.exe") {
        $Args += " -private-window"
    } else {
        $Args += " --incognito"
    }
}

# Agregar la URL a los argumentos, asegurándote de que esté entre comillas
$Args += " `"$Url`""

# Construir el comando completo, incluyendo el path del navegador entre comillas
# Esta es la parte que vamos a simplificar.
# Ahora, la línea de comando no se construye para VBScript directamente
$Command = "`"$BrowserPath`" $Args"

# --- CAMBIO IMPORTANTE ---
# La forma de pasar el comando a VBScript será más simple y directa.
# En lugar de usar Chr(34) y múltiples concatenaciones, creamos una sola cadena.
# El VBScript debería poder ejecutar esto sin problemas.
$VbsLine = 'WshShell.Run "' + $Command.Replace('"', '""') + '", 0, False'

# Definir la ruta del archivo VBS
$VbsPath = "$env:TEMP\launch_browser.vbs"

# Crear el contenido del archivo VBS
$VbsContent = @"
Set WshShell = CreateObject("WScript.Shell")
$VbsLine
"@

# Guardar el archivo VBS y ejecutarlo
$VbsContent | Out-File -Encoding ASCII -FilePath $VbsPath
Start-Process "wscript.exe" -ArgumentList "`"$VbsPath`""