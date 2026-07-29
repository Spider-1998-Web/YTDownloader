param(
    [Parameter(Mandatory = $true)][string]$Url,
    [Parameter(Mandatory = $true)][string]$OutFile,
    [string]$Label = "Downloading"
)

$ErrorActionPreference = "Stop"
$barWidth = 40

try {
    $request = [System.Net.HttpWebRequest]::Create($Url)
    $request.UserAgent = "Mozilla/5.0"
    $response = $request.GetResponse()
    $totalBytes = $response.ContentLength
    $responseStream = $response.GetResponseStream()

    $targetStream = New-Object System.IO.FileStream($OutFile, [System.IO.FileMode]::Create)
    $buffer = New-Object byte[] 65536
    $totalRead = 0

    Write-Host "$Label`:"

    while ($true) {
        $read = $responseStream.Read($buffer, 0, $buffer.Length)
        if ($read -le 0) { break }
        $targetStream.Write($buffer, 0, $read)
        $totalRead += $read

        if ($totalBytes -gt 0) {
            $percent = [math]::Round(($totalRead / $totalBytes) * 100)
            $filled = [math]::Round(($percent / 100) * $barWidth)
            if ($filled -gt $barWidth) { $filled = $barWidth }
            $bar = ('#' * $filled).PadRight($barWidth, '-')
            $mbRead = [math]::Round($totalRead / 1MB, 1)
            $mbTotal = [math]::Round($totalBytes / 1MB, 1)
            Write-Host -NoNewline ("`r  [{0}] {1,3}%  {2,6:N1} MB / {3,-6:N1} MB" -f $bar, $percent, $mbRead, $mbTotal)
        }
    }

    Write-Host ""
    $targetStream.Close()
    $responseStream.Close()
    $response.Close()
    exit 0
}
catch {
    Write-Host ""
    Write-Host "  ERROR: $($_.Exception.Message)"
    exit 1
}
