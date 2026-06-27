---
name: school-lab-report
description: Create per-task Chinese lab-report draft Markdown with task requirements, theory, formulas, code/file references, generated results, and initial result analysis. Use for the first writing pass before expansion, data-analysis extraction, Word rendering, or final hand-in packaging.
---

# School Lab Per-Task Draft Writer

## Core Standard

Create Markdown report sections that can be copied into a course lab report. Write in Chinese unless the user requests another language. The report should feel like a serious student lab submission: precise, detailed, formula-rich, and connected to actual code, data, figures, or measurements.

Use this skill for any course lab, not only machine vision. Examples include image processing, speech/audio processing, signal processing, digital communications, control systems, circuits, embedded systems, numerical methods, machine learning, data analysis, physics, and general programming experiments.

## Required Structure

For each experiment task, create or update one Markdown file with these sections in order:

1. `题目要求`
2. `涉及知识点与算法原理`
3. `代码文件与运行方式` or `实验材料与计算过程`
4. `实验结果`
5. `实验结果分析`

Use `代码文件与运行方式` when the task includes code. Use `实验材料与计算过程` when the task is mostly theoretical, measurement-based, or hand-computed.

## Workflow

1. Read the task statement and identify the course domain, input data, expected outputs, formulas, code paths, and result paths.
2. If code is required, implement or verify the code before writing the explanation.
3. Generate stable artifacts under obvious paths such as `code/`, `results/`, `data/`, or the repo's existing convention.
4. Write the Markdown after verification so the report matches the actual files and outputs.
5. Include exact run commands, input/output paths, numeric results, figures, and key parameters.
6. Make the principle section substantial: define variables, derive formulas from assumptions or definitions, show intermediate steps, and connect equations to the implemented steps.
7. When a task involves an algorithm, model structure, transform, metric, or optimization objective with many mathematical details, do not stop at listing core formulas. Explain where each formula comes from, why it is valid for this task, and give a small task-specific example using the problem's variables, data shape, parameter values, image/audio coordinates, or sample numeric values.
8. Make the analysis section concrete: explain whether the result meets the requirement, what parameters affected the result, and what error sources or limitations remain.

## Writing Rules

- Use LaTeX for equations. Prefer explicit derivations over only naming formulas.
- Use inline LaTeX for formulas that belong inside a sentence and display LaTeX only for formulas that should occupy their own line. For example, write `$G_x$` and `$R_{ci}$` inline rather than leaving `Gx`/`Rci` as plain text.
- For formula-heavy tasks, write a derivation chain instead of a formula list: start with definitions or modeling assumptions, derive the target expression step by step, define every symbol, then explain how the final expression maps to code or calculation.
- Include a task-specific example when it helps understanding. Good examples substitute a small image patch, signal sequence, coordinate point, confusion-matrix counts, transfer-function parameter, or model tensor shape from the current task. Avoid generic textbook examples that do not mention the actual experiment.
- Preserve assignment images, diagrams, and problem-statement figures as source facts. If the final DOCX must retain them, record their path or original anchor instead of silently dropping them.
- Start principle explanations from definitions, then build toward the task-specific algorithm or model.
- For algorithms, include input, output, main steps, parameter meaning, and complexity or limitations when relevant.
- For signal/audio tasks, explain sampling rate, time-domain and frequency-domain representations, convolution, filtering, FFT/STFT, spectral features, SNR, or recognition metrics as applicable.
- For image/vision tasks, explain coordinate systems, transforms, interpolation, thresholding, morphology, edge detection, contours, Hough voting, calibration, or geometric measurements as applicable.
- For control/circuit/physics tasks, explain model equations, transfer functions, differential equations, measurement units, fitting methods, and error propagation as applicable.
- For data/ML tasks, explain loss functions, metrics, normalization, training/testing split, model assumptions, and parameter effects as applicable.
- Do not present code screenshots. Reference code files and include only short, important snippets when useful.
- When including code snippets, use fenced code blocks with explicit language identifiers so later DOCX rendering can add syntax highlighting and line numbers.
- Include result images/tables/printed values in `实验结果`; interpret them in `实验结果分析`.

## Section Guidance

### 题目要求

Restate the task precisely. Include inputs, outputs, constraints, parameters, deliverables, and assumptions.

### 涉及知识点与算法原理

List the relevant knowledge points first, then explain each one. Include formulas and derivations. Good content usually includes:

- Variable definitions and units.
- Mathematical model or algorithm pipeline.
- Derivation of core equations, including intermediate steps rather than only the final expression.
- Parameter meanings and selection logic.
- Why this method fits the experiment.
- A task-specific worked example that connects the abstract formula to the actual assignment.
- The relationship between the mathematical expression and the implemented code, model layer, metric calculation, or experimental measurement.

### 代码文件与运行方式

List script paths, data paths, result paths, environment names, and run commands. Example:

```powershell
conda activate mv
python code/example.py
```

For non-code experiments, replace this with `实验材料与计算过程` and show the measurement/calculation procedure.

### 实验结果

Show generated figures, tables, logs, or important numeric outputs. Use Markdown image syntax for result images and fenced blocks for printed values.

### 实验结果分析

Analyze the result, not just repeat it. Explain correctness, trends, parameter sensitivity, error sources, and possible improvements. Connect visual or numeric observations back to the formulas and principles.

## Reference Template

When starting a new report section, read `references/report-section-template.md` and follow its structure. Adapt the template to the domain rather than copying placeholders literally.
