---
name: math-modeling-flow
description: >
  数学建模竞赛端到端总流程编排器（中文，面向本科高教社杯 CUMCM，可适配美赛）。
  当用户要从赛题到论文完整解一道数学建模题，或要把"构思→拆题→选模→编码→出图→写作→交付"
  串成一条可控流程时使用。Orchestrator for math-modeling contests; routes each stage to the
  best specialist skill and overlays Chinese / CUMCM / academic-integrity rules.
  触发词：数学建模流程、国赛全流程、CUMCM、高教社杯、从赛题到论文、建模agent流、数模流水线、
  math modeling pipeline、contest workflow。
  本 skill 不自己解题，而是按门(G0–G6)把活分派给最合适的专科 skill。
metadata:
  competition: CUMCM（本科·高教社杯）为主，可适配 MCM/ICM
  role: orchestrator / router（本身不解题）
  version: "1.0"
---

# 数学建模 · 综合流程编排器

## 这是什么
一条把多个现成 skill 串起来的**数学建模端到端流程**。它本身不解题、不写作，而是
**按阶段把任务路由给最强的那个专科 skill**，并统一叠加「中文 / CUMCM 规范 / 学术诚信」三层约束。

## 架构：一根脊柱 + 四类器官
- 🦴 **脊柱（总指挥）**：`math-modeling-contest` —— 已内置 3 角色、G1–G6 门、状态日志、速度档。
  **整个流程以它的门为时间轴；其它 skill 不得抢占编排权。**
- 📚 内容库：`math-modeling-solver` + `math-modeling-paper`
- 🎨 出图：`nature-figure`（按需 `nature-writing` / `nature-polishing` / `nature-academic-search`）
- ⚙️ 过程纪律：`brainstorming` / `systematic-debugging` / `verification-before-completion`
- 🏛️ 治理交付（**只取器官，不跑它的 14 步毕业论文流**）：`chinese-thesis-workbench` 的
  AIGC 降痕 + DOCX 生成 + 质量门核对

各 skill 的来源与安装见 [_装配说明.md](_装配说明.md)。

## 启动
用户给赛题后，先用 `math-modeling-contest` 的 Friendly Mode 用编号选项确认：
赛题类型（默认 CUMCM 本科）、题号、附件齐否、速度档（默认 Standard）、Manual/Autopilot（默认 Manual）。
然后按下表逐门推进。

## 门 → 路由表

| 门 | 干什么 | 调用谁 | 叠加 / 产物 |
|---|---|---|---|
| **G0 构思立项** | 框定题意、目标、成功标准 | `brainstorming`（**终点改为"模型方案确认"**，不是写代码） | 题意框定 + 成功标准 |
| **G1 拆题** | 12 类本质 + 子问题 DAG | `math-modeling-contest`·G1 + `math-modeling-solver`·阶段1 | 中文；子问题依赖图；**参数交叉核参**：PDF 文字层常丢图/表内参数，所有数值参数必须从 docx/附件第二来源交叉提取、核对一致后方可使用，缺口与不一致记入 decision_log |
| **G1.5 文献** | 先看别人怎么解 | `math-modeling-solver`·阶段1.5 + `nature-academic-search` | 候选模型须有文献支撑 |
| **G2 选模** | 95+ 矩阵 / playbook 出候选 | `math-modeling-solver`·阶段2 | 若本地备有历年官方评阅要点则对照给分点；**路线自由**（见范式§五）；⚠️候选我列，**用户拍板** |
| **G3 代码+复现** | 模板跑出真实结果 | `math-modeling-solver`·阶段3 + `systematic-debugging` + `verification-before-completion` | **真实运行→结果落盘冻结**；有余力用**第二方法互验**主结果（范式§四） |
| **G4 出图** | 从冻结结果出图 | `nature-figure`（**锁 Python + 中文标签 + CUMCM 图规范**） | 不从声称的数插值画图；图表编号+标题+图后必有分析（范式§三） |
| **G5 写作** | CUMCM 结构/摘要/检验/句库 | `math-modeling-paper` + `nature-writing`/`nature-polishing` 润语言 | 建议配合 [CUMCMThesis](https://github.com/latexstudio/CUMCMThesis) 等官方格式模板；从冻结结果+claim-evidence map 写；**摘要逐条过范式§一硬清单** |
| **G6 治理交付** | 证据核对→质量门→去AI腔→DOCX | `chinese-thesis-workbench`（仅治理器官） | 终稿 + 附录 + AI 使用说明 |

贯穿全程：`math-modeling-contest` 的**状态日志 + 角色 handoff + 速度档**；需要时用
并行子 agent 同时跑建模/编码/论文三角色。

## 高分论文范式（G2/G3/G4/G5 的叠加规则）
从 13 篇公开渠道的真实国赛优秀论文/特等奖提炼，**写作与检验时必须加载**：[references/高分论文范式.md](references/高分论文范式.md)。
速记版：① 摘要硬清单——标题=方法+对象、"针对问题N"逐段（模型名→做法→**量化结果进摘要**）、交付物点名、关键词5个；
② 正文骨架——问题重述→逐问分析（写"为什么"）→假设4–6条+符号三线表→逐问"建模→求解→结果→分析"；
③ 证据——图表编号+图后必有分析、自定义指标先定义后使用、**永远有对照组**、迭代给收敛证据；
④ 检验之王——第二方法互验主结果；⑤ 同题路线自由，选最能做扎实的，全文叙事统一。

## 可选本地资料区（有则用，无则跳过）
若用户工作目录备有以下资料，对应门会主动引用；没有也不影响流程运行：
- `优秀论文/`（历年获奖论文、官方评阅要点）→ G2 对照给分点、G5 学结构
- `算法模型库/`（按问题类型整理的模型代码与笔记）→ G2/G3 取材
- `论文模板/`（当年官方 Word/LaTeX 模板）→ G5/G6 排版

## 速度档（别全程最高）
Fast（可行性 / 极短 ddl）｜ Standard（默认）｜ Championship（决赛冲刺）。由脊柱统一控制。

## 诚信红线（任何门都不得越过）
1. **AI 必申报**：CUMCM 要求声明 AI 使用。G6 的 "AIGC 降痕" 只用于**去 AI 腔提质**，
   **不得用于规避申报**；最终须交一份 AI 使用说明。
2. **不自治选模 / 不代写正文**：G2 模型、G5 论点由人定；skill 只给候选与初稿陪你改。
3. **结果先于图文**：先有真实运行的冻结结果，再出图、再写作；禁止"先写结论再插值画图"。
4. **学形不抄实**：优秀论文 / 评阅要点用于学结构与给分点，不抄内容。
5. **赛中保密**：竞赛窗口期内涉赛题数据只在本地处理。

## 冲突处理
- 若 `math-modeling-solver`/`-paper` 或 `chinese-thesis-workbench` 试图"接管整个流程"，
  **以本编排器 + `math-modeling-contest` 的门为准**，它们只在被路由到时执行自己那一段。
- `chinese-thesis-workbench` 的 14 步毕业论文流、E-R 图、第四章实现绑定等**不适用竞赛**，
  只调用它的治理器官（AIGC 降痕 / DOCX / 质量门）。

## 装配
见 [_装配说明.md](_装配说明.md)：把上游 skill 装到 Claude Code 能加载的位置，并按各自 `name` 字段路由。
