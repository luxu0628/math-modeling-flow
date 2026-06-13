# math-modeling-flow 一键安装（Windows PowerShell）
# 1) 把本仓库捆绑的 skills/ 装入 ~/.claude/skills/
# 2) 从原仓库现场拉取 2 个未声明许可的上游 skill（本仓库不再分发其代码）
# 用法：在仓库根目录执行  powershell -ExecutionPolicy Bypass -File install.ps1

$ErrorActionPreference = "Stop"
$dst  = Join-Path $env:USERPROFILE ".claude\skills"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
New-Item -ItemType Directory -Force $dst | Out-Null

function Install-Skill($srcPath, $name) {
    $target = Join-Path $dst $name
    if (Test-Path $target) { Remove-Item $target -Recurse -Force }
    Copy-Item $srcPath $target -Recurse
    Write-Host "  + $name"
}

Write-Host "[1/3] 安装捆绑 skills（MIT 上游）..."
Get-ChildItem (Join-Path $root "skills") -Directory | ForEach-Object {
    Install-Skill $_.FullName $_.Name
}

Write-Host "[2/3] 安装编排器 math-modeling-flow ..."
$flow = Join-Path $dst "math-modeling-flow"
if (Test-Path $flow) { Remove-Item $flow -Recurse -Force }
New-Item -ItemType Directory -Force $flow | Out-Null
Copy-Item (Join-Path $root "SKILL.md") $flow
Copy-Item (Join-Path $root "references") (Join-Path $flow "references") -Recurse
Write-Host "  + math-modeling-flow"

Write-Host "[3/3] 从原仓库拉取未声明许可的上游（需要 git 与网络）..."
$tmp = Join-Path $env:TEMP "mmflow-deps"
if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
git clone --depth 1 https://github.com/xuec699-sudo/math-modeling-skills (Join-Path $tmp "contest")
Remove-Item (Join-Path $tmp "contest\.git") -Recurse -Force
Install-Skill (Join-Path $tmp "contest") "math-modeling-contest"
git clone --depth 1 https://github.com/Lupynow/math-modeling-skills (Join-Path $tmp "lupynow")
Install-Skill (Join-Path $tmp "lupynow\skills\math-modeling-solver") "math-modeling-solver"
Install-Skill (Join-Path $tmp "lupynow\skills\math-modeling-paper")  "math-modeling-paper"
Remove-Item $tmp -Recurse -Force

Write-Host ""
Write-Host "安装完成。已就位的 skill："
Get-ChildItem $dst -Directory | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") } |
    ForEach-Object { Write-Host ("  - " + $_.Name) }
Write-Host ""
Write-Host '验证：对 Claude 说 "用 math-modeling-flow 跑这道题，Manual 模式"'
