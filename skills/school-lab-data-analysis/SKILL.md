---
name: school-lab-data-analysis
description: Generate or quality-check the Chinese `数据处理分析` Markdown section from actual experiment outputs while preserving existing well-formatted tables, necessary result figures, and analysis text. Use when Codex needs to curate image/table evidence, write missing result interpretation, or prepare compact figure/table metadata for DOCX insertion without creating unnecessary detailed rewrites or result-file lists.
---

# School Lab Result Analysis Writer

## Purpose

Use this skill after experiments have been executed and after process Markdown has been checked or, only if necessary, supplemented. It produces or validates the `数据处理分析` section as a standalone Markdown artifact that can later be inserted into a Word report by `school-lab-docx-report`.

Do not assume a new `详细版` is needed. If an existing `数据处理分析.md` already has necessary figures, Markdown tables, and substantial per-task analysis, treat it as the authoritative source. Only add missing analysis paragraphs or missing image/table evidence; do not rewrite the whole file.

This skill focuses on results, evidence, figures, tables, metrics, and interpretation. It should not repeat the full theory derivation from `实验过程及内容`, but it must give enough result reasoning for the report to stand on its own.

It is the owner of result material that must be excluded from `实验过程及内容`. If process Markdown contains sections such as `实验结果`, `结果展示`, `结果分析`, `数据处理分析`, `输出结果`, or `运行结果`, extract the useful facts, figures, tables, and metrics here instead of leaving them in the process section. Do not create a separate `结果文件` subsection or standalone result-file list in the final analysis; paths should appear only as figure/table sources when needed.

## Inputs

Use all available evidence:

- Checked process Markdown from `school-lab-md-expander`; this may be the original Markdown if it already passed quality checks.
- Existing `analysis/*.md` files, especially already formatted tables and result subsections.
- Result images under `results/` or equivalent folders.
- CSV/TSV/XLSX tables.
- Program logs and printed metrics.
- Code files when needed to understand result meaning.
- Original assignment requirements.

## Output Location

Create a standalone Markdown file such as:

```text
analysis/Lab1_数据处理分析.md
```

or per-task files:

```text
analysis/Lab1_3_2_检测围棋棋子_数据处理分析.md
```

Do not overwrite raw experiment outputs.

Do not automatically create `*_详细版.md`. Use the existing `数据处理分析.md` when it is already good. If an additional working file is truly needed, prefer a neutral name such as `*_补充.md` or `*_修订.md`, and preserve the original table layout.

## Required Structure

For each task, write these subsections and keep them in the downstream DOCX:

1. `实验结果展示`
2. `结果数据表`
3. `结果分析`
4. `误差来源与改进` when needed

`实验结果展示`, `结果数据表`, and `结果分析` are mandatory whenever image/table evidence exists. Do not write `结果文件` as a subsection, and do not add a file-list table whose only purpose is to enumerate output paths. `误差来源与改进` is conditional: write it when the actual result differs noticeably from the theoretical or expected result, the metric is poor, the output is unstable, or an anomaly needs explanation. If the result matches the expectation well, omit the separate error subsection or replace it with a brief improvement note inside `结果分析`. Do not drop the template's core image/table evidence just because the final report is being converted to Word.

If a task has no image or table, explain why and include the available numeric/log evidence.

If an existing analysis file already has a `结果文件` section, migrate only the useful image/table references into `实验结果展示` or `结果数据表`, then remove the standalone `结果文件` section from the final Markdown. If an existing analysis file already uses the image/table/analysis structure, preserve its section order and heading text. Do not create a second detailed version that changes the organization.

## Writing Rules

- Use Chinese report prose.
- Use first-person only when describing completed work or conclusions; otherwise use objective analysis.
- Reference actual file paths only as figure/table sources when useful; do not discuss output files as an independent result item.
- Include Markdown image links for figures.
- Build tables from actual measured/detected values whenever possible.
- Explain what each result proves and whether it satisfies the task.
- Discuss parameter effects and limitations. Discuss error sources only when the actual result and theoretical/expected result differ noticeably, or when the result is abnormal or unsatisfactory.
- Do not fabricate metrics. If a metric is absent, state that it is unavailable or compute it from available data when appropriate.
- Treat images, CSV tables, logs, metric summaries, and result captions removed from `实验过程及内容` as first-class inputs for this section.
- Do not write only a short caption-style summary. Each task's `结果分析` must usually contain 2-3 substantial Chinese paragraphs.
- If one task has several result images or tables, analyze them one by one instead of merging them into a single vague paragraph.
- Preserve all useful content from process Markdown or existing analysis drafts. Do not summarize, compress, merge away, or delete paragraphs when the analysis Markdown is prepared for DOCX insertion.
- Preserve existing Markdown tables exactly unless there is a factual error. Do not convert a well-formatted result table into paragraphs, split it into scattered lists, reorder columns, or widen columns with verbose text.
- If a table needs additional explanation, add prose before or after the table; do not destroy the table's original layout.

## Figure Rules

Each result image should have:

```markdown
![图 X 结果说明](results/example.png)

图 X 结果说明文字
```

Downstream DOCX insertion should convert captions to 六号加粗居中.
For each figure, keep enough metadata for the DOCX phase to size it well: path, what it shows, and whether it needs small, medium, or near-page-width display. Do not imply that every image should be stretched to the maximum page width.

## Table Rules

Prepare Markdown tables that can become three-line Word tables later. Keep columns compact and meaningful.
When a table is compact, keep it compact. Avoid unnecessary wide columns or verbose text that would force the downstream DOCX table to occupy the full page width.
Downstream DOCX insertion must center the whole Word table object, not merely center text inside table cells.
Existing manually arranged Markdown tables are formatting source material. Keep their row order, column order, alignment markers, short labels, and path text unless correction is required.

Example:

```markdown
| 题目 | 图表证据 | 关键结果 | 判断 |
|---|---|---|---|
| 3.2 | results/weiqi_detected.png | 检测到黑白棋子中心 | 满足要求 |
```

## Analysis Requirements

For every task, write 2-3 substantial paragraphs in `结果分析` and answer:

- The output shows what.
- Which visual or numeric evidence supports correctness.
- Which parameters controlled the result.
- What errors may remain.
- How the result could be improved.

Recommended paragraph rhythm:

1. Describe the visible or numeric result, cite the exact figure/table/log, and state whether it meets the requirement.
2. Connect the observed result to the algorithm or model: explain why the parameter, threshold, transform, feature, metric, or training behavior produced this outcome.
3. Discuss limitations, edge cases, and practical improvements. Expand into error-source analysis only when the actual result has a clear gap from the theoretical/expected result, the metric is poor, or the output is abnormal. If `误差来源与改进` is written as a separate subsection, this third paragraph can briefly point to it but should not disappear.

Use concise formulas only when needed to analyze metrics, errors, angles, distances, or evaluation scores.
