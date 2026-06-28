---
name: school-lab-report-pipeline
description: Orchestrate complete Chinese school lab-report delivery: run or verify experiments, quality-check or minimally supplement draft/process/analysis/summary Markdown, build and render-check the final Word `.docx`, then prepare the teacher hand-in package containing only the report, `result/`, and `code/`. Use as the single entrypoint so the user does not need to invoke component skills manually.
---

# School Lab Complete Delivery Pipeline

## Purpose

Use this as the single entrypoint for a complete lab report. The user should only need to invoke:

```text
$school-lab-report-pipeline
```

This skill coordinates the smaller specialized skills. It does not replace them; it decides when each one should be used and keeps the report workflow consistent.

## Component Skill Names

Keep the existing `$school-lab-*` skill names for backward compatibility, but treat their roles as follows:

- `$school-lab-report`: per-task draft writer for requirements, principles, code/result paths, and initial analysis.
- `$school-lab-md-expander`: process-section quality checker and conditional expander for `实验过程及内容` content.
- `$school-lab-data-analysis`: result-analysis quality checker/writer for `数据处理分析` from real outputs, preserving existing table layout.
- `$school-lab-method-conclusion`: method/steps and conclusion quality checker/writer, preserving concise existing summaries.
- `$school-lab-docx-report`: Word template filler, formatter, equation renderer, and DOCX visual QA owner.
- `$school-lab-report-pipeline`: complete delivery owner, including the final teacher-facing package.

## Pipeline

Run the workflow in this order:

1. **实验执行与结果生成**
   - Read the assignment.
   - Inspect provided data/images/audio/files.
   - Implement or run code.
   - Generate stable outputs under `code/`, `results/`, `data/`, or the repo convention.

2. **基础 Markdown 提取**
   - Use `school-lab-report`.
   - Produce per-task preliminary Markdown containing requirements, principles, code paths, result paths, and initial analysis.
   - For formula-heavy algorithms, model structures, transforms, objectives, or metrics, include derivation steps and a small task-specific worked example instead of only listing core formulas.

3. **实验过程及内容质量检查与必要补写**
   - Use `school-lab-md-expander`.
   - Check each task one by one before expanding.
   - If the existing Markdown is already detailed, formula-complete, and Word-ready, keep it as the authoritative process source and do not rewrite it.
   - Save a checked or expanded process source under `expanded/` only when useful for pipeline bookkeeping; unchanged copies must remain unchanged.
   - Ensure process source files are detailed enough for direct Word insertion.
   - Ensure `实验原理` derives important formulas from definitions or assumptions, explains intermediate steps and symbols, and includes examples tied to the assignment's data, parameters, coordinates, tensors, or measurements.
   - Preserve correct original formulas exactly. Add missing explanations around formulas; do not regenerate formulas from scratch.
   - Preserve original problem statements and numbering in the checked process source.
   - For concept questions, write direct answers under each original problem without extra subsection labels.
   - For programming questions, use `题目分析`, `实验原理`, `实验设计`, `核心代码`, and `代码说明` as bold unnumbered labels under each original problem.
   - Keep these files focused on requirements, theory, derivations, algorithms, code design, and code text.
   - Do not include result images, result tables, metrics tables, result captions, or result interpretation in these process files.

4. **数据处理分析质量检查与必要补写**
   - Use `school-lab-data-analysis`.
   - If an existing `analysis/*数据处理分析.md` already has well-arranged tables, figures, result files, and per-task analysis, use it as the authoritative source.
   - Do not automatically create or prefer `*_详细版.md`; detailed rewrites often break table layout.
   - Extract actual results from result images, CSV files, logs, tables, and metrics.
   - For each task, keep the template-style subsections `结果文件`, `实验结果展示`, `结果数据表`, and `结果分析`.
   - Preserve existing Markdown table structure: column order, row order, compact labels, path cells, and alignment markers.
   - Add `误差来源与改进` only when the actual result differs noticeably from the theoretical/expected result, the metric is poor, the output is unstable, or an anomaly needs explanation.
   - Write 2-3 substantial `结果分析` paragraphs for each task with real evidence, covering observed result, algorithm/parameter explanation, and relevant limitations or improvements.
   - Preserve any result-related content moved out of process Markdown. Moving content between sections must not reduce or delete it.
   - Save analysis Markdown under `analysis/`.

5. **方法步骤与实验结论质量检查与必要补写**
   - Use `school-lab-method-conclusion`.
   - If an existing `summary/*方法步骤与实验结论.md` is already concise and complete, use it as the authoritative source.
   - Do not automatically create or prefer `*_详细版.md`; `方法、步骤` usually should remain concise.
   - Generate or supplement concise `方法、步骤` only when required points are missing.
   - Generate or supplement first-person completed-tense `实验结论` only when required completion facts are missing.
   - Save summary Markdown under `summary/`.

6. **Word 报告填充与渲染检查**
   - Use `school-lab-docx-report`.
   - Insert generated Markdown artifacts into the provided Word template.
   - Treat prepared Markdown as the source of record. Do not summarize, compress, or shorten `expanded/`, `analysis/`, or `summary/` content during Word insertion.
   - Prefer original or checked `analysis/*.md` and `summary/*.md` over `*_详细版.md` when the originals are already good.
   - Preserve cover, fixed template labels, teacher review areas, notes, and frames.
   - Preserve original problem statements already present in `实验过程及内容`; insert generated content below them instead of replacing them.
   - Preserve embedded pictures/diagrams already present in problem statements; these are assignment assets, not generated result figures.
   - Snapshot original DOCX media/drawing/equation relationships before editing and verify they are still present after insertion.
   - Convert inline variables and short formulas to inline OMML, while keeping display formulas as centered standalone equations.
   - Size figures and tables adaptively from natural/content width instead of forcing every object to maximum page width.
   - Format figure captions as centered 宋体 六号 bold text.
   - Render fenced code blocks as syntax-highlighted Word code tables with a left line-number gutter, not plain pasted paragraphs.
   - Before inserting `实验过程及内容`, run a section-boundary pass that strips or moves any result material from process Markdown.
   - Insert `数据处理分析` from `analysis/*.md` with all result files, figures, result data tables, and analysis paragraphs preserved.
   - If a reference report such as `Lab1.docx` is provided, use its same section formatting as the style authority.
   - Convert formulas to visible Word equations.
   - Render and visually inspect the final DOCX.

7. **提交材料整理**
   - After the final DOCX passes render QA, create a clean teacher-facing folder under `output/<lab>_提交材料/` unless the user specifies another path.
   - The folder should contain exactly the final report `.docx`, a singular `result/` folder, and a `code/` folder.
   - Copy or rename the final report into the package root.
   - Curate `result/` from the actual result artifacts referenced in the report. Exclude render QA images/PDFs, temporary XML, old outputs, scratch plots, and unrelated intermediate files.
   - Curate `code/` from reproducible source files only. Include scripts, notebooks, helper modules, config files, and small required examples; exclude virtual environments, caches, generated outputs, raw bulky datasets unless required, and hidden tool folders.
   - If working outputs were generated under `results/`, do not submit the whole folder blindly; select the final files and place them in `result/`.
   - List the final package tree and verify there are no unrelated files before reporting completion.


## Artifact Layout

Prefer this folder structure:

```text
code/
results/
data/
expanded/
analysis/
summary/
output/
```

Suggested working files:

```text
expanded/<lab>_<task>_过程稿.md
analysis/<lab>_数据处理分析.md
summary/<lab>_方法步骤与实验结论.md
output/<lab>_实验报告.docx
```

Suggested teacher-facing package:

```text
output/<lab>_提交材料/
├── <lab>_实验报告.docx
├── result/
└── code/
```

## Formula Rule

The final Word report must not contain raw LaTeX as the final formula display. During the DOCX phase, formulas should become visible Word equations, preferably native OMML.

If the current environment supports Microsoft Office `MML2OMML.XSL`, use MathML -> OMML conversion. If not, use a verified fallback such as high-resolution equation images, but never leave raw `$$...$$`, `\frac{...}`, or `\sqrt{...}` in final DOCX.

This rule also applies to inline formulas and short variables with subscripts/superscripts. Convert `$...$`, `\(...\)`, `x_i`, `Q_{11}`, `H^{-1}`, `p_k`, and similar mathematical symbols into inline OMML when they appear in report prose. Do not fake formula rendering by simplifying LaTeX into plain text inside an `m:oMath` container.

## User Interaction

Do not ask the user to remember or invoke the component skills manually. If this pipeline is triggered, perform the component phases internally.

Only ask questions when required information is missing and cannot be inferred safely, such as:

- Which DOCX is the final report target if multiple candidates exist.
- Whether to overwrite an existing final output file.
- Missing source data that prevents experiment execution.

## Quality Gate

Before final delivery:

- All source tasks have preliminary Markdown or a user-provided extracted Markdown source.
- Each task has a checked process Markdown source; it may be the original source if already sufficient, or a minimally supplemented version if content was incomplete.
- Formula-heavy tasks include derivation chains and task-specific examples in the principle/process content, not only final formulas.
- Correct formulas from the source Markdown have not been unnecessarily rewritten during process-source preparation.
- Data-analysis Markdown references real result files.
- Data-analysis Markdown preserves result-file lists, result displays, result tables, existing table layout, and detailed analysis for every task.
- Every task with real result evidence has 2-3 substantial result-analysis paragraphs, not only captions or one-sentence conclusions.
- Method/conclusion Markdown exists and remains concise; it is not replaced by an unnecessary detailed version.
- DOCX formulas are rendered, not raw source.
- Original template/problem images, drawings, text boxes, and equation objects have not been lost, including figures embedded in task statements.
- Inline formulas such as `G_x`, `G_y`, `R_{ci}`, and `\mu_{R_i}` render as inline Word equations in their original sentences, not as plain spell-checked text.
- Figures and tables use adaptive, visually balanced widths; they are not all stretched to the maximum page width.
- Figure captions are centered 宋体 六号 bold text.
- Code blocks are native Word text with syntax highlighting and an accurate left line-number gutter.
- A clean teacher-facing package exists with only the final report DOCX, `result/`, and `code/`.
- The package tree has been listed and checked for unrelated intermediate artifacts.
- `实验过程及内容` does not contain result figures/tables/metrics that belong in `数据处理分析`.
- Any result material moved out of `实验过程及内容` appears in `数据处理分析` without content loss.
- Final DOCX is checked against prepared Markdown so no task, formula derivation, result figure, result table, result path, or analysis paragraph has been silently shortened or omitted.
- Final DOCX formatting for `实验过程及内容` matches the provided reference report when one is available.
- DOCX has been rendered and visually inspected, or render failure is disclosed.
