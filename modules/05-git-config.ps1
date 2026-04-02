# Module: Git Config (delta integration)
Write-Host "  --- Git Config ---" -ForegroundColor Cyan

if (Get-Command git -ErrorAction SilentlyContinue) {
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.side-by-side true
    git config --global delta.line-numbers true
    git config --global merge.conflictstyle diff3
    Write-Host "  Git configured with delta" -ForegroundColor Green
} else {
    Write-Host "  [SKIP] git not found" -ForegroundColor Yellow
}
