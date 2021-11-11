$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Key", "API_KEY")
$headers.Add("Accept", "application/json")
#$headers.Add("Cookie"")

$nodes = Get-Content "SOURCEFILE.txt"
$abuseips = foreach($node in $nodes) {
  $response = Invoke-RestMethod ("https://api.abuseipdb.com/api/v2/check?ipAddress=$($node)") -Method 'GET' -Headers $headers -TimeoutSec 0.015 
  $response | ConvertTo-Json -depth 100 | ConvertFrom-Json 
} 
$abuseips | select -ExpandProperty Data | select ipAddress, abuseConfidenceScore, isp, domain, countryCode, totalReports, lastReportedAt | ConvertTo-CSV -NoTypeInformation | Set-Content -Path .\OUTPUTFILE.csv
