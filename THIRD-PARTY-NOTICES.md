# 第三方组件声明 / Third-Party Notices

本仓库是一个编排器 + 依赖合集。第三方 skill 按其许可分两种集成方式：

## 一、随仓库分发（vendored，均为 MIT 许可）

以下 skill 的副本位于 `skills/`，每个文件夹内保留上游 LICENSE 原文：

| skill | 上游仓库 | 许可 | 本仓库改动 |
|---|---|---|---|
| `nature-figure` | [Yuan1z0825/nature-skills](https://github.com/Yuan1z0825/nature-skills) | MIT © 2026 Yuan Yizhe | **精简**：移除 `assets/` 内演示图片(png/pdf，约29M)，保留 .py 示例与全部运行文件；完整画廊见上游 |
| `nature-writing` / `nature-polishing` / `nature-academic-search` | 同上 | MIT © 2026 Yuan Yizhe | 无修改 |
| `brainstorming` / `systematic-debugging` / `verification-before-completion` | [obra/superpowers](https://github.com/obra/superpowers) | MIT © 2025 Jesse Vincent | 无修改（仅从全集中抽取这 3 个） |
| `chinese-thesis-workbench` | [ZyhSechub/chinese-thesis-workbench-skill](https://github.com/ZyhSechub/chinese-thesis-workbench-skill) | MIT © 2026 Zyhsec | 无修改 |

## 二、安装时从原仓库拉取（不随本仓库分发）

以下上游仓库**未声明开源许可**（默认版权保留），故本仓库**不分发其代码**，
由 `install.ps1` / `install.sh` 在安装时从原仓库 `git clone` 获取，版权归原作者：

| skill | 上游仓库 | 状态 |
|---|---|---|
| `math-modeling-contest` | [xuec699-sudo/math-modeling-skills](https://github.com/xuec699-sudo/math-modeling-skills) | 无 LICENSE 文件 |
| `math-modeling-solver` / `math-modeling-paper` | [Lupynow/math-modeling-skills](https://github.com/Lupynow/math-modeling-skills) | 无 LICENSE 文件 |

> 若上述作者补充了许可或对本集成方式有任何意见，请提 Issue，我们将第一时间响应（包括移除）。
> If you are an upstream author and have concerns about this integration, please open an issue — we will respond promptly, including removal on request.

## 三、本仓库自有内容

`SKILL.md`、`README.md`、`references/高分论文范式.md`、安装脚本与本文件以 MIT 许可发布（见根目录 LICENSE）。
