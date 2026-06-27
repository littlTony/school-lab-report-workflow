# Word 公式渲染实现规则

## 目标

最终 DOCX 中的公式必须是可视化公式，而不是原始 LaTeX 字符串。优先使用 Word 原生 Office Math Markup Language，也就是 OMML。
Word 公式有两种常用落点：行内公式和独立显示公式。行内公式必须嵌在普通段落的文字运行之间，独立公式才单独成段并居中。不能因为转换方便而把句中变量全部挪到下一行，也不能把独立分式压成普通文本。

Word 原生公式在 `word/document.xml` 中通常表现为：

```xml
<m:oMath>...</m:oMath>
```

或：

```xml
<m:oMathPara>...</m:oMathPara>
```

## 推荐方案：MathML 转 OMML

本机可使用 Microsoft Office 自带的转换文件：

```text
C:\Program Files\Microsoft Office\root\Office16\MML2OMML.XSL
```

流程：

1. Markdown 中保留 LaTeX 公式作为源。
2. 将 LaTeX 转换为 MathML。可使用已安装转换器、手写模板或针对常见公式的受控转换。
3. 使用 `MML2OMML.XSL` 将 MathML 转成 OMML。
4. 使用 `python-docx` 和 `lxml` 把 OMML 节点插入 Word 段落。
5. 保存 DOCX。
6. 解压 DOCX 检查 `m:oMath`，再渲染检查公式是否可见。

核心代码形态：

```python
from pathlib import Path
from docx import Document
from lxml import etree

mathml = '''<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mrow>
    <mi>x</mi><mo>=</mo>
    <mfrac>
      <mrow><mo>-</mo><mi>b</mi><mo>&#x00B1;</mo><msqrt><mrow><msup><mi>b</mi><mn>2</mn></msup><mo>-</mo><mn>4</mn><mi>a</mi><mi>c</mi></mrow></msqrt></mrow>
      <mrow><mn>2</mn><mi>a</mi></mrow>
    </mfrac>
  </mrow>
</math>'''

xsl_path = Path(r"C:\Program Files\Microsoft Office\root\Office16\MML2OMML.XSL")
transform = etree.XSLT(etree.parse(str(xsl_path)))
omml = transform(etree.fromstring(mathml.encode("utf-8"))).getroot()

doc = Document()
p = doc.add_paragraph()
p._p.append(omml)
doc.save("equation.docx")
```

注意：在 MathML 中优先使用实体编码，例如 `&#x00B1;` 表示正负号，避免脚本或终端编码导致符号变成问号。

## LaTeX 到 MathML 的处理策略

如果环境有 LaTeX/MathML 转换器，优先使用转换器。
如果缺少 LaTeX-to-MathML 转换器，可以安装轻量依赖（例如 Python 的 `latex2mathml`）或使用 Pandoc/其他可用转换器；安装后必须用结构检查和渲染检查验证输出。依赖缺失不是把公式降级成普通文字的理由。

如果没有转换器：

1. 对常见公式建立受控模板，例如分式、根号、上下标、求和、矩阵、三角函数。
2. 对复杂公式可手写 MathML。
3. 对无法可靠转换的公式，使用高清公式图片 fallback。

不要把原始 LaTeX 直接写入 DOCX 当作最终公式。

## 结构检查

保存 DOCX 后，可检查 XML 中是否存在 OMML：

```python
import zipfile

with zipfile.ZipFile("report.docx") as z:
    xml = z.read("word/document.xml").decode("utf-8")
    assert "m:oMath" in xml or "m:oMathPara" in xml
```

## 渲染检查

使用 `documents` skill 的渲染流程或 LibreOffice 转 PDF/PNG 检查：

1. 公式显示为分式、根号、上下标等排版结构。
2. 公式没有显示为 `\frac{...}`、`\sqrt{...}` 或 `$$...$$`。
3. 特殊符号没有变成问号。
4. 公式没有超出版心，也没有与正文重叠。

## Fallback：公式图片

仅当 OMML 无法可靠生成时使用公式图片。要求：

- 图片必须高清。
- 公式前后仍保留文字解释。
- 图片宽度不超过版心。
- 若有图注，不能把公式误编号为普通实验结果图。
- 渲染后必须检查清晰度和对齐。

## 行内公式与上下标变量

公式不只包括单独成行的 `$$...$$`。在实验报告中，下列内容也必须按 Word 公式处理：

- 句子中的 `$...$` 或 `\(...\)`。
- 单个带上下标的数学变量，例如 `x_i`、`p_k`、`Q_{11}`、`H^{-1}`、`\mu_1`、`\sigma^2`。
- 带坐标或函数形式的变量，例如 `I(x,y)`、`f(x;\theta)`、`P(u,v)`，当它们处于数学解释语境中时按行内公式处理。
- 矩阵元素、误差项、概率项、频域项、采样项等短公式，例如 `a_{ij}`、`e^{-j2\pi kn/N}`、`X[k]`。
机器视觉报告中常见的行内公式示例包括 `G_x`、`G_y`、`R_{ci}`、`\mu_{R_i}`、`F(p)`、`D(F(p),\mu_{R_i})`、`I(x,y)`、`HSV`/`RGB` 颜色向量中的带下标分量等。若这些数学符号以普通 Word 文本写入，Word 可能把它们当英文拼写错误加红色波浪线；这类视觉结果应视为失败，必须改成行内 OMML。

行内公式的插入方式：

1. 将普通文字切成公式前文字、公式、公式后文字。
2. 公式前后仍使用普通 `w:r` 文本运行。
3. 公式本身转换为 `<m:oMath>`，并追加到同一个 `<w:p>` 中。
4. 不要把行内公式单独拆成居中段落，除非原 Markdown 使用独立公式块。
5. 渲染后检查行内公式是否仍在原句中，并确认不会出现普通文本式下标、红色拼写波浪线或用空格模拟的上下标。

示意结构：

```xml
<w:p>
  <w:r><w:t>设原图像点为 </w:t></w:r>
  <m:oMath>...</m:oMath>
  <w:r><w:t>，变换后的点为 </w:t></w:r>
  <m:oMath>...</m:oMath>
  <w:r><w:t>。</w:t></w:r>
</w:p>
```

## 独立公式

独立公式来自 `$$...$$`、`\[...\]` 或 Markdown 中单独占一行的公式。独立公式应插入为参考模板一致的公式段落，通常为居中段落，必要时使用 `<m:oMathPara>`。

独立公式和行内公式不能混用错误：

- 不要把句中变量单独提到下一行。
- 不要把复杂独立公式压成普通文本。
- 不要用空格模拟上下标、分式或矩阵。

## 禁止伪 OMML

下面做法不合格：

```python
omath = OxmlElement("m:oMath")
math_run = OxmlElement("m:r")
math_text = OxmlElement("m:t")
math_text.text = "(a)/(b)"
math_run.append(math_text)
omath.append(math_run)
```

这只是把普通字符串放进数学容器，并不会得到真正的分式、根号、上下标或矩阵结构。合格做法是先生成 MathML，再用 `MML2OMML.XSL` 转换为结构化 OMML；对于少量常见公式，也可以手写结构化 MathML/OMML 模板。

## 识别与例外

公式识别应跳过以下内容：

- fenced code block 内的全部内容。
- 文件名、路径、URL、Markdown 链接。
- 程序变量名、函数名、类名、CSV 列名，除非报告文字明确把它作为数学变量解释。

公式识别应覆盖以下 Markdown 形式：

- `$...$`
- `\(...\)`
- `$$...$$`
- `\[...\]`
- 数学上下文中的 `变量_下标`、`变量^{上标}`、`变量_{下标}`。

## 交付前公式 QA

保存 DOCX 后执行结构检查：

```python
import zipfile

with zipfile.ZipFile("report.docx") as z:
    xml = z.read("word/document.xml").decode("utf-8", errors="ignore")
    assert "<m:oMath" in xml or "<m:oMathPara" in xml
    forbidden = ["$$", "\\\\(", "\\\\)", "\\\\frac", "\\\\sqrt", "\\\\sum", "_{", "^{"]
    leaked = [token for token in forbidden if token in xml]
    assert not leaked, leaked
```

如果报告中有代码块，原始源码检查要避开代码块对应的段落，避免把 Python/Matlab/C++ 代码里的下划线误报为公式残留。视觉 QA 仍然必须通过：分式显示为上下结构，根号覆盖被开方项，上下标位置正确，行内公式不破坏句子行距。
