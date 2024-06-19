Copy-Item $PROFILE "./pwsh/Microsoft.PowerShell_profile.ps1"
Copy-Item "$env:USERPROFILE/.config/starship.toml" "./starship/starship.toml"
Copy-Item "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json" "./term/settings.json"
