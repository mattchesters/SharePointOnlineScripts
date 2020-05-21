$site = "https://tenant.sharepoint.com"
$OutputCSV = ".\Results.csv"

$installed = Get-Module SharePointPnPPowerShell* -ListAvailable | Select-Object Version
if ($installed.Version -lt 3.21.2005.1){
    Write-Host "PnP Module Missing or Requires Update. Attempting now..."
    Install-Module SharePointPnPPowerShellOnline
}

Connect-PnPOnline -url $site -UseWebLogin
Write-Host "This will take a long time..."
$results = Find-PnPFile -Match *
$results | Where-Object {$_.Name -notlike "*.aspx"} | Select Name -ExpandProperty Path | Export-Csv -Path $OutputCSV -NoTypeInformation -Append
Write-Host "Complete! Results saved to: " $OutputCSV
