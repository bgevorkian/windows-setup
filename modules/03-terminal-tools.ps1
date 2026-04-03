# Module: Terminal Tools
Write-Host "  --- Terminal Tools ---" -ForegroundColor Cyan

function Install-App($id, $name) {
    Write-Host ""
    Write-Host "  [$name] winget install $id" -ForegroundColor White
    winget install $id --accept-source-agreements --accept-package-agreements --silent
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [$name] OK" -ForegroundColor Green
    } else {
        Write-Host "  [$name] exit code: $LASTEXITCODE" -ForegroundColor Yellow
    }
}

Install-App "DEVCOM.JetBrainsMonoNerdFont"  "JetBrains Mono Nerd Font"
Install-App "JanDeDobbeleer.OhMyPosh"       "Oh My Posh"
Install-App "ajeetdsouza.zoxide"            "zoxide"
Install-App "eza-community.eza"             "eza"
Install-App "junegunn.fzf"                  "fzf"
Install-App "sharkdp.bat"                   "bat"
Install-App "sharkdp.fd"                    "fd"
Install-App "BurntSushi.ripgrep.MSVC"       "ripgrep"
Install-App "aristocratos.btop4win"         "btop"
Install-App "bootandy.dust"                 "dust"
Install-App "XAMPPRocky.tokei"              "tokei"
Install-App "JesseDuffield.lazygit"         "lazygit"
Install-App "dandavison.delta"              "delta"
Install-App "GnuWin32.File"                 "GnuWin32 File"
Install-App "sxyazi.yazi"                   "yazi"
Install-App "charmbracelet.glow"            "glow"
Install-App "Neovim.Neovim"                 "Neovim"
