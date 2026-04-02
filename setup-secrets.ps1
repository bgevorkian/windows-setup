# setup-secrets.ps1 — Fetch env vars from GitHub repo variables and set as Windows user env
# Usage: pwsh -File setup-secrets.ps1
#
# First time: store your secrets as GitHub repo variables:
#   gh variable set LDAP_PASSWD --body "your-password" --repo bgevorkian/windows-setup
#   gh variable set YOUTRACK_TOKEN --body "your-token" --repo bgevorkian/windows-setup
#   gh variable set MEMORYGRAPH_AUTH --body "your-auth" --repo bgevorkian/windows-setup
#
# Then on any new machine, run this script to pull them into Windows env.
# Requires: gh auth login

$repo = "bgevorkian/windows-setup"

$vars = @(
    "LDAP_PASSWD",
    "YOUTRACK_TOKEN",
    "MEMORYGRAPH_AUTH"
)

Write-Host ""
Write-Host "  Syncing environment variables from GitHub Variables" -ForegroundColor Cyan
Write-Host "  Repo: $repo" -ForegroundColor DarkGray
Write-Host ""

# Check gh auth
gh auth status 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Not logged in to GitHub CLI. Run: gh auth login" -ForegroundColor Red
    exit 1
}

foreach ($name in $vars) {
    $value = gh variable get $name --repo $repo 2>$null

    if ($LASTEXITCODE -ne 0 -or -not $value) {
        Write-Host "  [$name] not found in repo variables — skipping" -ForegroundColor Yellow
        Write-Host "    To add: gh variable set $name --body `"value`" --repo $repo" -ForegroundColor DarkGray
        continue
    }

    [System.Environment]::SetEnvironmentVariable($name, $value, "User")
    Write-Host "  [$name] set in user environment" -ForegroundColor Green
}

Write-Host ""
Write-Host "  Done. Restart terminal for changes to take effect." -ForegroundColor Cyan
Write-Host ""
