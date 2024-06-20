Copy-Item "./pwsh/Microsoft.PowerShell_profile.ps1" $PROFILE
Copy-Item "./starship/starship.toml" "$env:USERPROFILE/.config/starship.toml"
$term_path = (Get-Item -Path "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json").FullName
Copy-Item "./term/settings.json" $term_path
Copy-Item "./helix/config.toml" "$env:AppData/helix\config.toml"
