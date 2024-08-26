# Intro
I'm using free SSL Certificates from https://letsencrypt.org/. During the update process a DNS TXT record needs to be updated. Since I'm using Neostrada to host DNS, I have created a powershell script to process this change.

# How to use
- Get API Token from Neostrada
- $env:NEOTOKEN='youtoken here'
- edit the script to adjust input values
- .\Update-NEODNSRecord.ps1 -content 'new value for text record here'

