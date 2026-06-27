---
name: school-lab-data-analysis
description: Generate the Chinese `数据处理分析` Markdown section from actual experiment outputs: result images, CSV/TSV/XLSX tables, logs, metrics, and figures. Use when Codex needs to curate evidence, write result interpretation, and provide compact figure/table metadata for DOCX insertion.
---

# School Lab Result Analysis Writer

## Purpose

Use this skill after experiments have been executed and after per-task Markdown has been expanded. It produces the `数据处理分析` section as a standalone Markdown artifact that can later be inserted into a Word report by `school-lab-docx-report`.

This skill focuses on results, evidence, figures, tables, metrics, and interpretation. It should not repeat the full theory derivation from `实验过程及内容`.

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

For each task, write:

1. `结果文件`
2. `实验结果展示`
3. `结果数据表`
4. `结果分析`
5. `误差来源与改进`

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

For every task, answer:

- The output shows what.
- Which visual or numeric evidence supports correctness.
- Which parameters controlled the result.
- What errors may remain.
- How the result could be improved.

Use concise formulas only when needed to analyze metrics, errors, angles, distances, or evaluation scores.
