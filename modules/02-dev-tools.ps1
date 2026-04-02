# Module: Dev Tools
Write-Host "  --- Dev Tools ---" -ForegroundColor Cyan

function Install-App($id, $name) {
    Write-Host "  $name... " -NoNewline
    $result = winget install $id --accept-source-agreements --accept-package-agreements --silent 2>&1
    if ($result -match "already installed") {
        Write-Host "already installed" -ForegroundColor DarkGray
    } else {
        Write-Host "done" -ForegroundColor Green
    }
}

Install-App "Hashicorp.Terraform"          "Terraform"
Install-App "GnuWin32.Make"                "Make"
Install-App "ZedIndustries.Zed"            "Zed"
Install-App "Python.Python.3.14"           "Python"
Install-App "Anthropic.ClaudeCode"         "Claude Code"
