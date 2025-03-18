$ProgressPreference = 'SilentlyContinue'

# Install Starship prompt
Invoke-Expression (&starship init powershell)
function Invoke-Starship-PreCommand {
    $host.ui.RawUI.WindowTitle = Split-Path -Path (Get-Location) -Leaf
}

Clear-Host

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
            $history = $history[$startIndex..($totalCommands - 1)]
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

function tree {
    param (
        [string]$path = ".",
        [string[]]$ignore = @(".git", "__pycache__", "node_modules", ".idea", ".vscode"),
        [int]$max_depth = $null,
        [string]$output = $null
    )
  
    function get_directory_tree {
        param (
            [string]$root_path = ".",
            [string[]]$ignore_patterns = @(),
            [int]$max_depth = $null,
            [int]$current_depth = 0,
            [string]$indent = ""
        )
  
        if ($null -ne $max_depth -and $current_depth -gt $max_depth) { return }
  
        try {
            $items = Get-ChildItem -Path $root_path -ErrorAction Stop | Sort-Object Name
        }
        catch {
            Write-Output "$indent├── [Access Denied]"
            return
        }
  
        $total_items = ($items | Where-Object {
                $item_name = $_.Name
                -not ($ignore_patterns | Where-Object { $item_name -like "*$_*" })
            }).Count
  
        $current_item = 0
  
        foreach ($item in $items) {
            $should_ignore = $ignore_patterns | Where-Object { $item.Name -like "*$_*" }
            if ($should_ignore) { continue }
  
            $current_item++
            $is_last = ($current_item -eq $total_items)
            $prefix = if ($is_last) { "└── " } else { "├── " }
            $new_indent = if ($is_last) { $indent + "    " } else { $indent + "│   " }
  
            Write-Output "$indent$prefix$($item.Name)"
            if ($item.PSIsContainer) {
                get_directory_tree -root_path $item.FullName -ignore_patterns $ignore_patterns -max_depth $max_depth -current_depth ($current_depth + 1) -indent $new_indent
            }
        }
    }
  
    $absolute_path = (Resolve-Path $path).Path
    $tree_output = @("$absolute_path")
    $tree_output += get_directory_tree -root_path $absolute_path -ignore_patterns $ignore -max_depth $max_depth
  
    if ($output) {
        $tree_output | Out-File -FilePath $output -Encoding utf8
        Write-Host "Tree structure written to $output"
    }
    else {
        $tree_output
    }
}
