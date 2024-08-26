$ProgressPreference = 'SilentlyContinue'

# Install Starship prompt
Invoke-Expression (&starship init powershell)
function Invoke-Starship-PreCommand {
    $host.ui.RawUI.WindowTitle = Split-Path -Path (Get-Location) -Leaf
}

# Set location to user profile
Set-Location $env:USERPROFILE

Clear-Host

$quotes = @(
    "Don't talk to me like I'm a machine, I'm not that."
    "No matter where you go, everyone's connected."
    "If you're not remembered, then you never existed."
    "I promise you I'll always be right here. I'm right next to you, forever."
)

# Pick a random quote
$quote = $quotes | Get-Random
Write-Host "$quote"

function ll { Get-ChildItem -Force -ErrorAction SilentlyContinue -ErrorVariable +err | Format-Table -AutoSize }

function ls { Get-ChildItem -Force -ErrorAction SilentlyContinue -ErrorVariable +err | Format-Wide -Column 5 }

# Mirror Linux traceroute command using tracert
function traceroute {
    param(
        [Parameter(Mandatory = $true)]
        [string]$IPAddress
    )

    tracert $IpAddress
}

# Check SSL certificate of a website
function cert {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url,
        [Parameter(Mandatory = $false)]
        [int]$Port = 443
    )

    $uri = [System.Uri]::new($Url)
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    try {
        $tcpClient.Connect($uri.Host, $Port)
        $sslStream = New-Object System.Net.Security.SslStream($tcpClient.GetStream())
        try {
            $sslStream.AuthenticateAsClient($uri.Host)
            $cert = $sslStream.RemoteCertificate

            $certInfo = @{
                Url           = $Url
                Port          = $Port
                Subject       = $cert.Subject
                Issuer        = $cert.Issuer
                NotBefore     = $cert.GetEffectiveDateString()
                NotAfter      = $cert.GetExpirationDateString()
                DaysRemaining = ($cert.NotAfter - (Get-Date)).Days
            }

            return New-Object -TypeName PSObject -Property $certInfo
        }
        catch {
            Write-Error "Error checking SSL certificate for ${$Url}:${$Port} : ${$_}"
        }
        finally {
            $sslStream.Dispose()
        }
    }
    catch {
        Write-Error "Error connecting to ${$Url}:${$Port} : ${$_}"
    }
    finally {
        $tcpClient.Dispose()
    }
}

# Mirror Linux tail command with a parameter for number of lines and a continuous switch that reads the file every second
function tail {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $false)]
        [int]$Lines = 10
    )

    Get-Content $Path -Tail $Lines -Wait
}

function lookup {
    param(
        [Parameter(Mandatory = $false)]
        [string]$IpAddress
    )

    if ($IpAddress -eq '') {
        $url = "https://ipinfo.io/json?token=812632c2910f97"
    }
    else {
        $url = "https://ipinfo.io/$IpAddress/json?token=812632c2910f97"
    }

    $response = Invoke-RestMethod $url
    
    $result = [ordered]@{
        IP           = $response.ip
        Hostname     = $response.hostname
        City         = $response.city
        Region       = $response.region
        Country      = $response.country
        PostalCode   = $response.postal
        Latitude     = $response.loc.Split(',')[0]
        Longitude    = $response.loc.Split(',')[1]
        Timezone     = $response.timezone
        Organization = $response.org
    }
    
    Write-Output $result
}

function repos {
    Set-Location "C:\Users\cmaddex\OneDrive - SNC Ltd\Repos"
}

function hst {
    param (
        [int]$Count = 10
    )

    $historyPath = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
    
    if (Test-Path $historyPath) {
        $history = Get-Content $historyPath
        $totalCommands = $history.Count

        if ($Count -gt 0) {
            $startIndex = [Math]::Max(0, $totalCommands - $Count)
            $history = $history[$startIndex..($totalCommands-1)]
        }

        for ($i = 0; $i -lt $history.Count; $i++) {
            $commandNumber = $totalCommands - $history.Count + $i + 1
            Write-Output ("{0,6}  {1}" -f $commandNumber, $history[$i])
        }
    }
    else {
        Write-Warning "History file not found at $historyPath"
    }
}
