# remote_stop_capture.ps1
# Detiene mitmdump si el archivo PID existe

$PidFile = "$env:TEMP\mitmproxy.pid"

if (Test-Path $PidFile) {
    $Pid = Get-Content $PidFile
    Write-Output "[*] Stopping MITM process with PID $Pid ..."

    try {
        Stop-Process -Id $Pid -Force
        Remove-Item $PidFile -Force
        Write-Output "[?] MITM stopped."
    }
    catch {
        Write-Output "[X] Failed to stop process: $_"
    }
}
else {
    Write-Output "[X] No PID file found. MITM may not be running."
}

