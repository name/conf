$ProgressPreference = 'SilentlyContinue'

# Install Starship prompt
Invoke-Expression (&starship init powershell)
function Invoke-Starship-PreCommand {
    $host.ui.RawUI.WindowTitle = Split-Path -Path (Get-Location) -Leaf
}

# Set location to user profile
Set-Location $env:USERPROFILE

Clear-Host

$method = @'
                                                                                      
                                      88                               88 88          
                                ,d    88                               88 ""   ,d     
                                88    88                               88      88     
88,dPYba,,adPYba,   ,adPPYba, MM88MMM 88,dPPYba,   ,adPPYba,   ,adPPYb,88 88 MM88MMM  
88P'   "88"    "8a a8P_____88   88    88P'    "8a a8"     "8a a8"    `Y88 88   88     
88      88      88 8PP"""""""   88    88       88 8b       d8 8b       88 88   88     
88      88      88 "8b,   ,aa   88,   88       88 "8a,   ,a8" "8a,   ,d88 88   88,    
88      88      88  `"Ybbd8"'   "Y888 88       88  `"YbbdP"'   `"8bbdP"Y8 88   "Y888 

'@

$personal = @'
                                                                                 
                               88         88                        88           
                               88   ,d    ""                        88           
                               88   88                              88           
88,dPYba,,adPYba,  88       88 88 MM88MMM 88  ,adPPYba,  8b,dPPYba, 88,dPPYba,   
88P'   "88"    "8a 88       88 88   88    88 a8"     "8a 88P'   "Y8 88P'    "8a  
88      88      88 88       88 88   88    88 8b       d8 88         88       d8  
88      88      88 "8a,   ,a88 88   88,   88 "8a,   ,a8" 88         88b,   ,a8"  
88      88      88  `"YbbdP'Y8 88   "Y888 88  `"YbbdP"'  88         8Y"Ybbd8"'   

'@

if ($env:COMPUTERNAME -like '*laptop*') {
    Write-Host $method -ForegroundColor Cyan
} else {
    Write-Host $personal -ForegroundColor Cyan
}

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
        [string]$Url
    )

    $uri = [System.Uri]::new($Url)
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    try {
        $tcpClient.Connect($uri.Host, $uri.Port)
        $sslStream = New-Object System.Net.Security.SslStream($tcpClient.GetStream())
        try {
            $sslStream.AuthenticateAsClient($uri.Host)
            $cert = $sslStream.RemoteCertificate

            $certInfo = @{
                Url           = $Url
                Subject       = $cert.Subject
                Issuer        = $cert.Issuer
                NotBefore     = $cert.GetEffectiveDateString()
                NotAfter      = $cert.GetExpirationDateString()
                DaysRemaining = ($cert.NotAfter - (Get-Date)).Days
            }

            return New-Object -TypeName PSObject -Property $certInfo
        }
        catch {
            Write-Error "Error checking SSL certificate for $Url : $_"
        }
        finally {
            $sslStream.Dispose()
        }
    }
    catch {
        Write-Error "Error connecting to $Url : $_"
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
