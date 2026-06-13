#!/usr/bin/env bash
# math-modeling-flow 一键安装（macOS / Linux）
# 1) 把本仓库捆绑的 skills/ 装入 ~/.claude/skills/
# 2) 从原仓库现场拉取 2 个未声明许可的上游 skill（本仓库不再分发其代码）
set -euo pipefail

DST="$HOME/.claude/skills"
ROOT="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$DST"

install_skill() {  # $1=src $2=name
  rm -rf "$DST/$2"
  cp -r "$1" "$DST/$2"
  echo "  + $2"
}

echo "[1/3] 安装捆绑 skills（MIT 上游）..."
for d in "$ROOT/skills"/*/; do
  install_skill "$d" "$(basename "$d")"
done

echo "[2/3] 安装编排器 math-modeling-flow ..."
rm -rf "$DST/math-modeling-flow"
mkdir -p "$DST/math-modeling-flow"
cp "$ROOT/SKILL.md" "$DST/math-modeling-flow/"
cp -r "$ROOT/references" "$DST/math-modeling-flow/references"
echo "  + math-modeling-flow"

echo "[3/3] 从原仓库拉取未声明许可的上游（需要 git 与网络）..."
TMP="$(mktemp -d)"
git clone --depth 1 https://github.com/xuec699-sudo/math-modeling-skills "$TMP/contest"
rm -rf "$TMP/contest/.git"
install_skill "$TMP/contest" "math-modeling-contest"
git clone --depth 1 https://github.com/Lupynow/math-modeling-skills "$TMP/lupynow"
install_skill "$TMP/lupynow/skills/math-modeling-solver" "math-modeling-solver"
install_skill "$TMP/lupynow/skills/math-modeling-paper"  "math-modeling-paper"
rm -rf "$TMP"

echo ""
echo "安装完成。已就位的 skill："
for d in "$DST"/*/; do
  [ -f "$d/SKILL.md" ] && echo "  - $(basename "$d")"
done
echo ""
echo '验证：对 Claude 说 "用 math-modeling-flow 跑这道题，Manual 模式"'
