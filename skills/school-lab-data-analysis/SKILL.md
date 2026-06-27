---
name: school-lab-data-analysis
description: Generate the Chinese `数据处理分析` Markdown section from actual experiment outputs: result images, CSV/TSV/XLSX tables, logs, metrics, and figures. Use when Codex needs to curate evidence, write result interpretation, and provide compact figure/table metadata for DOCX insertion.
---

# School Lab Result Analysis Writer

## Purpose

Use this skill after experiments have been executed and after per-task Markdown has been expanded. It produces the `数据处理分析` section as a standalone Markdown artifact that can later be inserted into a Word report by `school-lab-docx-report`.

This skill focuses on results, evidence, figures, tables, metrics, and interpretation. It should not repeat the full theory derivation from `实验过程及内容`, but it must give enough result reasoning for the report to stand on its own.

It is the owner of result material that must be excluded from `实验过程及内容`. If expanded process Markdown contains sections such as `实验结果`, `结果展示`, `结果分析`, `数据处理分析`, `输出结果`, or `运行结果`, extract those facts, paths, figures, tables, and metrics here instead of leaving them in the process section.

## Inputs

Use all available evidence:

- Expanded Markdown from `school-lab-md-expander`.
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

## Required Structure

For each task, write these subsections and keep them in the downstream DOCX:

1. `结果文件`
2. `实验结果展示`
3. `结果数据表`
4. `结果分析`
5. `误差来源与改进`

`结果文件`, `实验结果展示`, `结果数据表`, and `结果分析` are mandatory whenever evidence exists. `误差来源与改进` is preferred but may be shorter when the assignment has little error discussion. Do not drop the template's result-related points just because the final report is being converted to Word.

If a task has no image or table, explain why and include the available numeric/log evidence.

## Writing Rules

- Use Chinese report prose.
- Use first-person only when describing completed work or conclusions; otherwise use objective analysis.
- Reference actual file paths for every figure/table.
- Include Markdown image links for figures.
- Build tables from actual measured/detected values whenever possible.
- Explain what each result proves and whether it satisfies the task.
- Discuss parameter effects, error sources, and limitations.
- Do not fabricate metrics. If a metric is absent, state that it is unavailable or compute it from available data when appropriate.
- Treat images, CSV tables, logs, metric summaries, and result captions removed from `实验过程及内容` as first-class inputs for this section.
- Do not write only a short caption-style summary. Each task's `结果分析` must usually contain 2-3 substantial Chinese paragraphs.
- If one task has several result images or tables, analyze them one by one instead of merging them into a single vague paragraph.
- Preserve all useful content from already-expanded Markdown or existing analysis drafts. Do not summarize, compress, merge away, or delete paragraphs when the analysis Markdown is prepared for DOCX insertion.

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

Example:

```markdown
| 题目 | 结果文件 | 关键结果 | 判断 |
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
3. Discuss limitations, edge cases, possible error sources, and practical improvements. If `误差来源与改进` is written as a separate subsection, this third paragraph can be coordinated with it but should not disappear.

Use concise formulas only when needed to analyze metrics, errors, angles, distances, or evaluation scores.
