#!/usr/bin/env python3
"""
Convert markdown paper to LaTeX with chart placeholders.
"""
import re
from pathlib import Path

md_file = Path("/home/ec2-user/github/research/papers/accuracy-of-prediction-markets/accuracy-of-prediction-markets.md")
tex_file = Path("/home/ec2-user/github/research/papers/accuracy-of-prediction-markets/accuracy-of-prediction-markets-comprehensive.tex")

# Read markdown
with open(md_file) as f:
    content = f.read()

# LaTeX preamble
tex_content = r"""\documentclass[a4paper,11pt]{article}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath,amssymb,amsthm}
\usepackage{graphicx,booktabs,array}
\usepackage{fancyhdr,lastpage}
\usepackage[utf8]{inputenc}
\usepackage{hyperref}
\hypersetup{colorlinks, urlcolor=blue, linkcolor=black}
\usepackage[sort&compress,numbers,square]{natbib}
\bibliographystyle{plainnat}
\usepackage{pgfplots,tikz}
\usetikzlibrary{arrows.meta,positioning,shapes.geometric,fit,backgrounds,calc}
\pgfplotsset{compat=1.17}

\theoremstyle{plain}
\newtheorem{hypothesis}[section]{Hypothesis}
\newtheorem{theorem}[section]{Theorem}
\theoremstyle{definition}
\newtheorem{definition}[section]{Definition}

\title{\textbf{Are Prediction Markets Accurate? Resolving Information Aggregation Through a Lifecycle Lens}}
\author{Jonathan Becker\thanks{jonathan@jbecker.dev}}
\date{\today}

\pagestyle{fancy}
\fancyhf{}
\rhead{Prediction Market Calibration}
\lfoot{Becker}
\rfoot{Page \thepage\ of \pageref{LastPage}}

\begin{document}

\maketitle

"""

# Convert markdown structure
lines = content.split('\n')
in_abstract = False
abstract_started = False
skip_next_chart_fence = False

for i, line in enumerate(lines):
    # Skip empty lines at start
    if not tex_content.strip().endswith('}'):
        if line.strip() == '':
            continue
    
    # Extract abstract
    if 'Executive Summary' in line or '## Executive Summary' in line:
        in_abstract = True
        abstract_started = True
        tex_content += r"\begin{abstract}" + "\n"
        continue
    
    if abstract_started and line.startswith('#'):
        if not ('Executive' in line or '## Executive' in line):
            in_abstract = False
            tex_content += r"\noindent\textbf{Keywords:} Prediction markets, calibration, information aggregation, market liquidity, Ottaviani-Sørensen model" + "\n"
            tex_content += r"\end{abstract}" + "\n\n"
            abstract_started = False
    
    if in_abstract:
        if line.strip() == '---':
            continue
        tex_content += line + "\n"
        continue
    
    # Skip --- dividers
    if line.strip() == '---' or line.strip() == '```':
        skip_next_chart_fence = True
        continue
    
    # Handle charts
    if '@include fig/' in line:
        json_file = line.split('@include ')[-1].strip()
        json_name = json_file.split('/')[-1].replace('.json', '')
        tex_content += f"\n% CHART: {json_file}\n"
        tex_content += f"% [TikZ figure for {json_name} will be inserted here]\n"
        tex_content += f"\\begin{{figure}}[h]\n\\centering\n"
        tex_content += f"\\input{{tikz/{json_name}.tikz}}\n"
        tex_content += f"\\caption{{{json_name}}}\n"
        tex_content += f"\\label{{fig:{json_name}}}\n"
        tex_content += f"\\end{{figure}}\n\n"
        skip_next_chart_fence = False
        continue
    
    # Convert markdown headings to LaTeX
    if line.startswith('# '):
        title = line[2:].strip()
        tex_content += f"\n\\section{{{title}}}\n\\label{{sec:{title.lower().replace(' ', '')}}}\n\n"
    elif line.startswith('## '):
        title = line[3:].strip()
        tex_content += f"\n\\subsection{{{title}}}\n\n"
    elif line.startswith('### '):
        title = line[4:].strip()
        tex_content += f"\n\\subsubsection{{{title}}}\n\n"
    elif line.startswith('#### '):
        title = line[5:].strip()
        tex_content += f"\n\\paragraph{{{title}}}\n\n"
    # Bold headers
    elif line.startswith('**') and '**' in line[2:]:
        tex_content += line.replace('**', '\\textbf{').replace('**', '}') + "\n"
    # Bullet points
    elif line.startswith('- '):
        if not tex_content.rstrip().endswith(r"\begin{itemize}"):
            tex_content += "\\begin{itemize}\n"
        tex_content += f"\\item {line[2:].strip()}\n"
    # Numbered lists
    elif line.startswith('1. ') or re.match(r'^\d+\. ', line):
        if not tex_content.rstrip().endswith(r"\begin{enumerate}"):
            tex_content += "\\begin{enumerate}\n"
        match = re.match(r'^(\d+)\. (.+)', line)
        if match:
            tex_content += f"\\item {match.group(2)}\n"
    else:
        tex_content += line + "\n"

# Add references section
tex_content += r"""
\newpage
\begin{thebibliography}{99}

\bibitem[Ottaviani and Sørensen(2007)]{Ottaviani2007}
Ottaviani, M., and P.~N. Sørensen (2007).
\newblock Aggregation of information and beliefs: A theory of divisive pivotal votes.
\newblock \textit{Journal of Economic Theory}, 134(1), 310--338.

\bibitem[Ottaviani and Sørensen(2010a)]{Ottaviani2010a}
Ottaviani, M., and P.~N. Sørensen (2010a).
\newblock Forecasting aggregation.
\newblock \textit{International Journal of Forecasting}, 26(2), 228--236.

\bibitem[Page and Clemen(2013)]{Page2013}
Page, L., and R.~T. Clemen (2013).
\newblock Do prediction markets produce well-calibrated probability forecasts?
\newblock \textit{Economic Journal}, 123(568), 491--513.

\bibitem[Wolfers and Zitzewitz(2004)]{Wolfers2004}
Wolfers, J., and E.~Zitzewitz (2004).
\newblock Prediction markets.
\newblock \textit{Journal of Economic Perspectives}, 18(2), 107--126.

\end{thebibliography}

\end{document}
"""

# Write output
with open(tex_file, 'w') as f:
    f.write(tex_content)

print(f"Created: {tex_file}")
print(f"Lines: {len(tex_content.split(chr(10)))}")
