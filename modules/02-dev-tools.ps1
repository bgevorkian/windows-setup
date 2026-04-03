# Module: Dev Tools
Write-Host "  --- Dev Tools ---" -ForegroundColor Cyan

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

Install-App "Hashicorp.Terraform"          "Terraform"
Install-App "GnuWin32.Make"                "Make"
Install-App "ZedIndustries.Zed"            "Zed"
Install-App "Python.Python.3.14"           "Python"
Install-App "Anthropic.ClaudeCode"         "Claude Code"
