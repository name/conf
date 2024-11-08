# Perform git pull
git pull

# Function to sync directories
function Sync-Directory($name, $source, $destination) {
    if (!(Test-Path $source)) {
        Write-Host "$name sync failed - Source not found: $source"
        return
    }

    if (Test-Path $destination) {
        # Remove existing files and folders in the destination
        Get-ChildItem -Path $destination -Recurse | Remove-Item -Force -Recurse
    }
    else {
        New-Item -ItemType Directory -Path $destination | Out-Null
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

    Copy-Item $source $destination -Force
    Write-Host "$name synced successfully"
    Write-Host "  Source: $source"
    Write-Host "  Destination: $destination"
}

# Pull PowerShell profile
Sync-File "PowerShell Profile" "./pwsh/Microsoft.PowerShell_profile.ps1" $PROFILE

# Pull Starship config
Sync-File "Starship Config" "./starship/starship.toml" "$env:USERPROFILE/.config/starship.toml"

# Pull Windows Terminal settings
$term_path = (Get-Item -Path "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json").FullName
Sync-File "Windows Terminal Settings" "./term/settings.json" $term_path

# Pull Neovim config
Sync-Directory "Neovim Config" ".\nvim" "$env:LOCALAPPDATA\nvim"

# Pull Glaze WM config from %userprofile%\.glzr\glazewm\config.yaml
Sync-File "Glaze" ".\glaze\config.yaml" "$env:USERPROFILE\.glzr\glazewm\config.yaml"

Write-Host "Configuration pull completed."
