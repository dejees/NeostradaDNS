Param ($content)

# INPUT (move to param or $env:)
$myToken      = $env:NEOTOKEN
$myDomain     = '<Put domain name here>'
$myDNSname    = '<Put record name here>'
$myTtl        = 60

# FUNCTIONS
Function Get-NeoDomain {
  Param (
    [Parameter(Mandatory = $true)][string]$name
  )

  $myDomainsRaw = Invoke-WebRequest -UseBasicParsing -Uri 'https://api.neostrada.com/api/domains' -Headers @{Authorization = "Bearer $myToken"}
  $myDomains = ($myDomainsRaw.Content | ConvertFrom-Json).results
  
  # Return only domain $name
  $myDomains | Where-Object -Property description -eq $name
}

Function Get-NeoDNSRecord {
  Param (
    [Parameter(Mandatory = $true)]$dns_id,
    [Parameter(Mandatory = $true)][string]$name
  )

  $myDNSRaw = Invoke-WebRequest -UseBasicParsing  -Uri "https://api.neostrada.com/api/dns/$dns_id" -Headers @{Authorization = "Bearer $myToken"}
  $myDNS = ($myDNSRaw.Content | ConvertFrom-Json).results

  # Return only record $name
  $myDNS | Where-Object -Property name -eq $name
}

Function Update-NeoDNSRecord {
  Param (
    [Parameter(Mandatory = $true)]$dns_id,
    [Parameter(Mandatory = $true)]$recordid,
    [Parameter(Mandatory = $true)][string]$content,
    [Parameter(Mandatory = $true)][Int16]$ttl
  )

  $body = @{
    record_id = $recordid
    content = $content
    prio = 0
    ttl = $ttl
  }

  $uri = "https://api.neostrada.com/api/dns/edit/$dns_id"
  $res = Invoke-WebRequest -UseBasicParsing  -Method PATCH -Uri $uri -Debug -Verbose -Headers @{Authorization = "Bearer $myToken"} -ContentType 'application/json' -Body ($body | ConvertTo-Json)

  $res
}


# MAIN
$intDomain = Get-NeoDomain -name $myDomain

if ($intDomain.description.Length -ne 0) {
  $intDNS_id = $intDomain.dns_id
  $intDNSRecord = Get-NeoDNSRecord -dns_id $intDNS_id -name $myDNSname
  $intDNSRecord_id = $intDNSRecord.id
  Update-NeoDNSRecord -dns_id $intDNS_id -recordid $intDNSRecord_id -content $content -ttl $myTTL
} 
else {
  Write-Host 'Domain does not exists.'
}
