# Function to sync directories
function Sync-Directory($name, $source, $destination) {
    if (!(Test-Path $source)) {
        Write-Host "$name sync failed - Source not found: $source"
        return
    }

    if (!(Test-Path $destination)) {
        New-Item -ItemType Directory -Path $destination | Out-Null
    } else {
        # Remove existing files and folders in the destination
        Get-ChildItem -Path $destination -Recurse | Remove-Item -Force -Recurse
    }

    # Copy all items from source to destination
    Copy-Item -Path "$source\*" -Destination $destination -Recurse -Force
    Write-Host "$name synced successfully"
    Write-Host "  Source: $source"
    Write-Host "  Destination: $destination"
}

# Function to sync single files
function Sync-File($name, $source, $destination) {
    if (!(Test-Path $source)) {
        Write-Host "$name sync failed - Source not found: $source"
        return
    }

    $destination_dir = Split-Path -Parent $destination
    if (!(Test-Path $destination_dir)) {
        New-Item -ItemType Directory -Path $destination_dir | Out-Null
    }

    Copy-Item $source $destination -Force
    Write-Host "$name synced successfully"
    Write-Host "  Source: $source"
    Write-Host "  Destination: $destination"
}

# Backup PowerShell profile
Sync-File "PowerShell Profile" $PROFILE "./pwsh/Microsoft.PowerShell_profile.ps1"

# Backup Starship config
Sync-File "Starship Config" "$env:USERPROFILE/.config/starship.toml" "./starship/starship.toml"

# Backup Windows Terminal settings
$term_path = (Get-Item -Path "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json").FullName
Sync-File "Windows Terminal Settings" $term_path "./term/settings.json"

# Backup Helix config
Sync-File "Helix Config" "$env:AppData/helix\config.toml" "./helix/config.toml"

# Backup Neovim config
Sync-Directory "Neovim Config" "$env:LOCALAPPDATA\nvim" ".\nvim"

Write-Host "Configuration push completed."

