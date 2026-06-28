---
name: school-lab-md-expander
description: Quality-check and, only when necessary, expand Chinese lab-report Markdown into Word-ready `实验过程及内容` Markdown. Use when Codex needs to preserve original problem statements, assignment images, formulas, and already-good content while adding only missing theory, derivations, algorithm design, code text, or implementation explanation before DOCX insertion.
---

# School Lab Process Section Expander

## Purpose

Use this skill to quality-check existing lab-report Markdown and expand it only when it is actually too short or incomplete. This skill is intentionally separate from DOCX editing: it prepares a Word-ready content source first, then a DOCX-focused skill can insert that content into a Word template.

Use this skill before `school-lab-docx-report` fills `实验过程及内容`, but do not assume a new "detailed version" must always be generated. If the extracted or user-provided Markdown is already detailed, formula-complete, and structurally suitable, treat that original Markdown as the authoritative Word-ready source and do not rewrite it.

## Inputs

Use all available materials:

- Original lab assignment PDF/DOCX.
- Original embedded assignment images, diagrams, charts, equation objects, and problem-statement pictures.
- Existing preliminary Markdown files.
- Source code files.
- Result images, CSV files, logs, metrics, or printed outputs.
- Current report text if available.

Do not overwrite the original preliminary Markdown unless the user asks. If the source Markdown is already sufficient, keep it as the canonical process source; optionally copy it unchanged under `expanded/` only for pipeline bookkeeping. If content is incomplete and real expansion is needed, create an expanded file with a clear name, for example:

```text
expanded/Lab1_实验过程及内容_过程稿.md
```

or, for per-task expansion:

```text
expanded/Lab1_编程题3_2_检测围棋棋子_补写.md
```

## Expansion Rules

- Run a quality gate before expanding. Check whether the source Markdown already preserves the problem statements, contains adequate theory, derivations, code text, code explanation, and correct formula notation. If it passes, do not produce a rewritten detailed version.
- Preserve all verified facts, paths, numerical results, and conclusions from the original Markdown.
- Treat problem-statement images and diagrams as original assignment content, not as result images. Preserve their references or record their DOCX anchor so the DOCX phase can keep them with the problem text.
- Expand only the missing parts; do not shrink, paraphrase away, or replace detailed original content with a shorter summary or a "more polished" rewrite.
- Do not rewrite correct formulas. Preserve original LaTeX formula source exactly unless there is a clear syntax error, missing delimiter, or user-requested correction.
- When adding derivations around existing formulas, add surrounding explanation before or after the formula instead of regenerating the formula body.
- If code exists, read the actual code and explain its design. Do not rely only on the Markdown description.
- If result files exist, record their paths only as handoff metadata for `school-lab-data-analysis`. Do not display result images/tables or write result interpretation inside the process-section expansion.
- If the original Markdown lacks enough theory, add definitions, formulas, derivations, parameter explanations, and task-specific worked examples.
- If the task involves an algorithm, model structure, transform, objective function, metric, or other formula-heavy material, the `实验原理` content must be more than a list of final formulas. Derive the formula from definitions or assumptions, explain each intermediate step, define every symbol, and show how the formula applies to this exact assignment.
- If a result or metric is missing, state the gap or run the code when appropriate before writing the expansion.
- Write in Chinese unless the user requests otherwise.
- Avoid second-person wording. Use objective report prose, and use first-person only when describing completed work or conclusions.

## Required Structure For `实验过程及内容`

Preserve the original assignment problem statements exactly. Do not delete, rewrite, renumber, summarize, or replace problem text already present in the template/report. Expanded content is appended under the original problem statement.
If a problem statement includes a picture or diagram, preserve a placeholder/reference for that asset in the expanded Markdown or a handoff note for the DOCX phase. Do not reduce the task to text-only when the source problem had a required image.

For concept questions:

- Keep the original problem heading and number, such as `1.1 ...`, `1.2 ...`.
- Directly answer below the problem statement.
- Do not add `题目分析`, `实验原理`, `实验设计`, `核心代码`, `代码说明`, `本题小结`, or any extra subsection heading.
- Do not split the concept answer into artificial report modules. Use ordinary paragraphs and formulas only when needed.
- When the concept question is mathematical, include the necessary derivation process and a small example tied to the problem, not only the final conclusion.

For programming or implementation questions:

1. Keep the original problem heading and number, such as `2.1 ...`, `2.2 ...`, `3.3 ...`.
2. Under the original problem statement, use exactly these bold label headings, without numbering:
   - `题目分析`
   - `实验原理`
   - `实验设计`
   - `核心代码`
   - `代码说明`
3. Put detailed explanations under each bold label. If content under a label needs internal ordering, use the user's lower-level numbering rules such as `(1)`, `1)`, and `a.`.
4. Do not add `题目要求`, `涉及知识点`, `算法流程`, `代码设计与关键代码`, `实验材料与运行方式`, `本题结果和过程解释`, or `本题小结` as final process-section headings.

For programming questions, include code as text, not screenshots. Prefer complete code if the report needs it; otherwise include key code plus a path to the full file.

## Result Boundary Rule

This skill prepares the Markdown source for `实验过程及内容`. It must not become a result-analysis writer.

Keep in the process Markdown:

- Original problem statements and numbering.
- Knowledge points and definitions.
- Algorithm/theory principles.
- Formula derivations and variable explanations.
- Experiment design and implementation flow.
- Code design, code paths, and code text.
- Parameter choices and implementation notes.

Do not include in the process Markdown:

- Sections titled `实验结果`, `结果展示`, `结果分析`, `数据处理分析`, `实验结果分析`, `输出结果`, `结果文件`, or `运行结果`.
- Result images, comparison figures, masks, overlays, error maps, output screenshots, or figure captions for results.
- CSV metric tables, run-output summaries, accuracy tables, component tables, or result-statistics tables.
- Detailed discussion of whether the observed result is good or bad.

If the input draft already contains those result materials, preserve the factual paths and metrics in a short handoff note for the data-analysis phase, then exclude them from the process expansion. A suitable handoff note is:

```markdown
> 数据处理分析素材：结果文件见 `results/...`，对应指标/图片将在“数据处理分析”部分整理。
```

Do not insert that handoff note into the final Word `实验过程及内容` if the report style requires strict separation.

## Depth Requirements

If expansion is needed, the added content must make the Markdown materially richer. For every important method or concept that is missing detail:

- Define variables and units.
- Explain the underlying model or algorithm.
- Derive the formula or explain how the formula is obtained, including key intermediate steps.
- Explain why the method is suitable for the task.
- Explain parameter choices and their effect.
- Connect formulas to code implementation.
- Include at least one task-specific worked example when the principle would otherwise be abstract. The example should use the assignment's own objects, such as a coordinate point, kernel window, signal sample, model input tensor, confusion-matrix counts, measured component value, or parameter setting.

For model-structure tasks, explain the data flow through the structure, the dimensional change or state update at each important layer/block, and how the equations produce the model output. If the model has a loss function or evaluation metric, derive or explain it and connect it to the training/evaluation code.

For image/vision tasks, include coordinate systems, transforms, interpolation, thresholding, edge detection, contours, Hough voting, geometric measurement, or polar mapping as applicable.

For speech/audio/signal tasks, include sampling, time/frequency-domain representation, convolution, filtering, FFT/STFT, windowing, spectral features, SNR, or recognition metrics as applicable.

For control/circuit/physics/data tasks, include model equations, transfer functions, differential equations, measurement units, fitting, metrics, error propagation, or assumptions as applicable.

## Formula Requirements

Use LaTeX in the Markdown source:

```markdown
$$
X[k]=\sum_{n=0}^{N-1}x[n]e^{-j2\pi kn/N}
$$
```

The downstream DOCX skill is responsible for converting equations to visible Word equations. This skill must provide complete equation source and variable explanations.

Formula preservation is mandatory:

- If an existing Markdown formula is already correct, keep its LaTeX source unchanged.
- Do not "improve" formulas by retyping them from memory, simplifying them, changing symbols, changing indexes, or converting them to plain text.
- Do not merge several existing formulas into one newly written formula unless the user explicitly asks.
- If a formula looks wrong, mark the suspected issue and fix only the minimal syntax or notation needed after checking context.

Do not write only a compact formula inventory such as "the algorithm uses equation A, B, and C." A complete principle section should usually contain:

1. The problem-specific symbols and assumptions.
2. The derivation or reasoning path from assumptions to the target formula.
3. The meaning and unit or range of each variable.
4. A short worked example using this task's data, parameters, or shapes.
5. A sentence explaining how the formula is implemented in code or used in the experiment.

## Code Requirements

For programming tasks:

- Include code in fenced code blocks.
- Always add the language identifier to fenced code blocks, such as `python`, `matlab`, `cpp`, or `bash`, so the DOCX phase can apply correct syntax highlighting.
- Keep code text accurate to the actual script.
- Preserve indentation, blank lines, comments, and import order exactly; do not reflow code as prose.
- Explain each important block before or after the code.
- Mention input and output paths.
- Discuss how the code implements the formulas or algorithm steps.

## Output Checklist

Before finishing, check that the process Markdown:

- Is either the original Markdown accepted as sufficient, or a minimally expanded version that only adds missing content.
- Retains original result paths and code paths.
- Preserves all correct original formulas and inline variables without unnecessary rewriting.
- Has enough derivation detail for the theory to be reproducible, not just final formulas.
- Uses task-specific examples for formula-heavy algorithms or model structures.
- Contains code for programming tasks.
- Does not put result images, result tables, result captions, metrics tables, or result interpretation into `实验过程及内容`.
- Can be inserted directly into a Word report section with minimal content rewriting.

For a reusable template, read `references/expanded-process-template.md`.
