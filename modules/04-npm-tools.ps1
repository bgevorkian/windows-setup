# Module: NPM Tools (Claude Code MCP servers)
Write-Host "  --- NPM Tools (MCP servers) ---" -ForegroundColor Cyan

# Add common Node.js paths in case winget PATH hasn't propagated yet
$env:PATH = "$env:PROGRAMFILES\nodejs;$env:APPDATA\npm;$env:PATH"

if (Get-Command npm -ErrorAction SilentlyContinue) {
    Write-Host ""
    Write-Host "  [postgresql-mcp] npm install -g @sarmadparvez/postgresql-mcp" -ForegroundColor White
    npm install -g "@sarmadparvez/postgresql-mcp"
    Write-Host ""
    Write-Host "  [mssql-mcp] npm install -g @iforge.it/mssql-mcp" -ForegroundColor White
    npm install -g "@iforge.it/mssql-mcp"
} else {
    Write-Host "  [SKIP] npm not found" -ForegroundColor Yellow
}
