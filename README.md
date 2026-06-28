# School Lab Report Workflow

这个项目把“课程实验从执行到最终 Word 报告交付”的 Codex skills 独立出来，方便后续集中维护、同步和复用。它适合需要从实验题目、代码、结果图表、Markdown 草稿一路整理到最终 `.docx` 报告和教师提交材料的课程实验。

推荐总入口：

```text
$school-lab-report-pipeline
```

## 项目结构

```text
school-lab-report-workflow/
├── README.md
├── skills-manifest.json
├── docs/
│   └── workflow.md
├── scripts/
│   ├── sync-to-codex.ps1
│   ├── sync-from-codex.ps1
│   └── validate-project.ps1
└── skills/
    ├── school-lab-report/
    ├── school-lab-md-expander/
    ├── school-lab-data-analysis/
    ├── school-lab-method-conclusion/
    ├── school-lab-docx-report/
    └── school-lab-report-pipeline/
```

## 完整工作流

`$school-lab-report-pipeline` 是完整交付入口。通常只需要在 Codex 中调用这个 skill，它会按顺序编排下面所有组件 skill，并在每个阶段生成可追踪的中间产物。

### 1. 实验执行与结果生成

先读取实验题目、模板、已有数据和参考材料，再编写或运行实验代码。生成的稳定产物建议放在这些目录中：

```text
code/
results/
data/
```

这一阶段要确保报告后续引用的代码、图片、表格、日志和指标是真实存在且可复现的，而不是只写文字描述。

### 2. 分题基础报告初稿

使用 `$school-lab-report`。

这个阶段为每道题生成基础 Markdown，内容包括：

- 题目要求、输入输出、限制条件和交付物。
- 涉及知识点、算法原理、公式推导、变量定义和结合题目的例子。
- 代码文件、运行命令、数据路径和结果路径。
- 初步实验结果和结果分析。

代码片段必须使用带语言标识的 fenced code block，例如：

````markdown
```python
python code/main.py
```
````

这样后续 Word 阶段才能正确做语法高亮和行号。

### 3. 实验过程及内容质量检查与必要补写

使用 `$school-lab-md-expander`。

这个阶段先检查基础 Markdown 或已经提取出的 Markdown 是否能直接放入 Word 报告 `实验过程及内容`。如果原稿已经完整、公式正确、结构合适，就直接把原稿作为权威来源，不再强制生成一份“详细版”。只有缺少理论、公式推导、算法设计、核心代码或代码说明时，才补写缺失部分。对于算法、模型结构、评价指标、变换或优化目标涉及较多数学公式的题目，`实验原理` 不能只给核心公式，还要写出推导过程、符号含义，并结合题目给出小例子。

公式保护是硬规则：原稿中已经正确的 LaTeX 公式不要为了扩写而重写。需要补充推导时，在公式前后增加解释，不要替换变量、合并公式或把公式改成普通文字。

对于概念题，直接在原题下面回答，不额外添加 `题目分析`、`实验原理` 等标签。

对于编程题，使用固定的无编号加粗标签：

```text
题目分析
实验原理
实验设计
核心代码
代码说明
```

这一阶段不能放结果图片、结果表格、指标表或结果解释。结果相关内容统一交给 `数据处理分析` 阶段。

### 4. 数据处理分析生成

使用 `$school-lab-data-analysis`。

这个阶段从真实实验输出中生成 `数据处理分析` Markdown，包括：

- 结果文件路径。
- 结果图片和图注。
- CSV/TSV/XLSX、日志或指标整理出的结果表。
- 每道题两到三段实质性的结果分析。
- 参数影响、局限性和改进方向；只有实际结果与理论或预期结果差距较大时，才重点写误差来源。

每道题应尽量保留模板中的 `结果文件`、`实验结果展示`、`结果数据表`、`结果分析` 等结果相关点。其他点可以按证据多少适当简洁，但 `结果分析` 必须写充分：先说明图表或数值结果展示了什么，再结合算法、参数、阈值、模型或指标解释为什么得到这个结果，最后讨论局限或改进方向。`误差来源与改进` 不是每题都强制写，主要在实际结果和理论/预期结果差距明显、指标较差、输出异常或结果不稳定时单独展开。

如果 `实验过程及内容` 的扩写文件里混入了结果展示、结果分析、运行输出或指标表，也应在这个阶段抽取出来，避免最终 Word 报告的章节边界混乱。注意这是移动到 `数据处理分析`，不是删减；结果文件、图表、指标和分析段落必须完整保留。

### 5. 方法步骤与实验结论生成

使用 `$school-lab-method-conclusion`。

这个阶段生成两个最终报告章节：

- `方法、步骤`：按题目或任务组概括实验设计与执行过程，不重复长篇公式推导。
- `实验结论`：使用第一人称完成式，例如“我完成了……我掌握了……我分析了……”。

建议输出到：

```text
summary/<实验名>_方法步骤与实验结论.md
```

### 6. Word 报告排版与渲染检查

使用 `$school-lab-docx-report`。

这个阶段把前面生成的 Markdown、代码、结果图表和结论填入 `.docx` 模板。核心要求是保留模板结构，而不是重新设计文档。

已经生成的 `expanded/*.md`、`analysis/*.md` 和 `summary/*.md` 是内容来源，迁入 Word 时不能被概括成短摘要。DOCX 阶段只负责转换、排版和渲染检查；如果 Word 中某个章节明显短于源 Markdown，或 `数据处理分析` 少了结果文件、结果展示、结果数据表、结果分析段落，就必须回退重做。

必须保留：

- 封面、教师批阅区、备注、评分栏等固定模板内容。
- 原始题目文字、题号、题目图片和已有公式对象。
- 参考报告或模板中的局部排版风格。

必须处理：

- 行内公式和独立公式转换为可见 Word 公式，优先使用 OMML。
- 代码块转换为带语法高亮和左侧行号栏的 Word 原生文本表格。
- 图片和表格按内容自适应宽度，不能全部强行铺满页面；普通报告表格要设置整个表格对象居中，不是只让单元格文字居中。
- 图注使用宋体六号加粗居中。
- 渲染最终 DOCX 页面并检查公式、图片、表格、代码和分页问题。

最终 Word 报告不应残留裸露的 LaTeX，例如 `$$...$$`、`\frac{...}`、`\sqrt{...}` 或未转换的行内公式。

### 7. 教师提交材料整理

最终输出一个干净的提交文件夹：

```text
output/<实验名>_提交材料/
├── <实验名>_实验报告.docx
├── result/
└── code/
```

提交包规则：

- `result/` 只放报告中引用的最终结果图、表格和指标文件。
- `code/` 只放复现实验所需代码、Notebook、辅助模块、配置文件和必要小样例。
- 不提交 `expanded/`、`analysis/`、`summary/`、渲染检查图、临时 PDF、缓存、旧结果、虚拟环境或隐藏工具目录。

## Skill 使用方式

### 推荐方式：只调用总入口

大多数情况下，直接让 Codex 使用总入口即可：

```text
Use $school-lab-report-pipeline to complete Lab2 from experiment execution to final report and package the teacher submission folder.
```

中文也可以这样写：

```text
使用 $school-lab-report-pipeline 完成 Lab2，从运行实验、生成报告内容、排版 Word，到整理教师提交包。
```

总入口会自动决定何时调用组件 skill。用户不需要手动记住每个子 skill 的顺序。

### 单独使用组件 skill

如果只想完成某一个阶段，可以直接调用对应 skill。

| Skill | 适用场景 | 主要输出 |
|---|---|---|
| `$school-lab-report` | 从题目、代码和结果生成分题基础报告初稿 | 每题 Markdown 草稿 |
| `$school-lab-md-expander` | 检查并按需补写 Word 可插入的 `实验过程及内容` | 原稿或 `expanded/*.md` |
| `$school-lab-data-analysis` | 从真实结果图、表格、日志和指标生成结果分析 | `analysis/*.md` |
| `$school-lab-method-conclusion` | 生成 `方法、步骤` 和第一人称 `实验结论` | `summary/*.md` |
| `$school-lab-docx-report` | 将 Markdown、代码、图表填入 Word 模板并做渲染检查 | 最终 `.docx` 和提交包 |
| `$school-lab-report-pipeline` | 编排完整实验报告交付流程 | 全部中间产物、最终报告、提交包 |

### 常见调用示例

只写分题初稿：

```text
Use $school-lab-report to generate preliminary Markdown for each task in Lab1 based on the assignment, code, and results.
```

只检查/按需补写 `实验过程及内容`：

```text
Use $school-lab-md-expander to quality-check the preliminary Markdown for Word-ready 实验过程及内容, preserving original problem statements, assignment images, and correct formulas; expand only missing parts.
```

只整理结果分析：

```text
Use $school-lab-data-analysis to generate 数据处理分析 from the images, CSV files, logs, and metrics under results/.
```

只生成方法和结论：

```text
Use $school-lab-method-conclusion to create 方法、步骤 and first-person 实验结论 from the expanded process and analysis Markdown.
```

只生成最终 Word：

```text
Use $school-lab-docx-report to fill the provided DOCX template with the generated Markdown, code, figures, tables, and conclusions, then render-check the final report.
```

## 产物目录建议

完整流程推荐使用下面的工作目录：

```text
code/
results/
data/
expanded/
analysis/
summary/
output/
```

建议命名：

```text
expanded/<实验名>_<题号或任务名>_过程稿.md
analysis/<实验名>_数据处理分析.md
summary/<实验名>_方法步骤与实验结论.md
output/<实验名>_实验报告.docx
output/<实验名>_提交材料/
```

其中 `expanded/`、`analysis/`、`summary/` 是工作产物，方便追踪和返工；如果原始 Markdown 已经足够，`expanded/` 中可以不生成重写版，或只保存未改动副本。最终交给老师的提交包只应包含报告、`result/` 和 `code/`。

## 维护方式

修改本项目中的 skill 后，建议按下面顺序维护：

1. 在 `skills/` 下修改对应 skill。
2. 运行基础结构检查：

   ```powershell
   .\scripts\validate-project.ps1
   ```

3. 同步到 Codex skills 目录：

   ```powershell
   .\scripts\sync-to-codex.ps1
   ```

   该脚本会删除 `~/.codex/skills` 中已有的同名 `school-lab-*` skill 和旧 `.backup-*` 目录，再复制本项目中的最新版本，避免 Codex 搜索时出现重复 skill。

4. 重启 Codex 或开启新线程，让新的 skill 版本被加载。

如果你在 Codex 的安装目录里临时改了 skill，可以把当前安装版本拉回本项目：

```powershell
.\scripts\sync-from-codex.ps1
```

## 质量检查要点

最终交付前至少检查：

- 每道题都有可迁入 Word 的过程 Markdown；原稿合格时直接用原稿，内容不足时才使用补写版。
- 公式较多的算法或模型结构有推导链、变量解释和结合题目的例子，不只是核心公式列表。
- 原稿中正确的公式没有在“详细版”或 Word 迁入前被无故重写。
- `实验过程及内容` 不混入结果图片、结果表格和结果分析。
- `数据处理分析` 引用的图片、表格、日志和指标都来自真实文件，并且每道有结果证据的题目都有两到三段结果分析。
- 最终 DOCX 与 `expanded/`、`analysis/`、`summary/` 源 Markdown 对照后没有内容缩减，尤其不能把结果分析压缩成图注或一句话。
- `方法、步骤` 简洁，`实验结论` 使用第一人称完成式。
- DOCX 中公式已渲染为可见公式，不残留裸 LaTeX。
- 表格整体居中且按内容自适应，不能贴左，也不能只居中单元格文字。
- 代码块是 Word 原生文本并带语法高亮和行号，不是截图。
- 原模板中的题目图片、公式对象、批阅区、备注和固定文字没有丢失。
- 最终提交包只包含报告 `.docx`、`result/` 和 `code/`。
