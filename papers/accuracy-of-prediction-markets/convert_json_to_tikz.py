#!/usr/bin/env python3
"""
Convert JSON chart specs to TikZ/pgfplots LaTeX code.
Used for integrating data visualizations natively into LaTeX paper.
"""

import json
import os
from pathlib import Path

def json_to_pgfplots_bar(json_path, title_override=None):
    """Convert JSON bar chart to pgfplots LaTeX."""
    with open(json_path) as f:
        data = json.load(f)
    
    title = title_override or data.get('title', 'Chart')
    x_label = data.get('xaxis', {}).get('title', 'X Axis')
    y_label = data.get('yaxis', {}).get('title', 'Y Axis')
    
    # Extract data from vega spec
    data_str = ""
    if 'data' in data and isinstance(data['data'], list):
        for point in data['data']:
            x = point.get('x', 0)
            y = point.get('y', 0)
            data_str += f"  ({x}, {y})\n"
    
    template = f"""\\begin{{tikzfigure}}[0.8\\textwidth]
  \\begin{{axis}}[
    title={{{title}}},
    xlabel={{{x_label}}},
    ylabel={{{y_label}}},
    width=\\textwidth*0.8,
    height=0.5\\textwidth,
    xtick=data,
    bar width=0.8cm,
    ybar,
    axis on top
  ]
    \\addplot[fill=darkblue!70, draw=black] coordinates {{
{data_str}    }};
  \\end{{axis}}
\\end{{tikzfigure}}
"""
    return template

def json_to_pgfplots_scatter(json_path, title_override=None):
    """Convert JSON scatter plot to pgfplots LaTeX."""
    with open(json_path) as f:
        data = json.load(f)
    
    title = title_override or data.get('title', 'Chart')
    x_label = data.get('xaxis', {}).get('title', 'X Axis')
    y_label = data.get('yaxis', {}).get('title', 'Y Axis')
    
    data_str = ""
    if 'data' in data and isinstance(data['data'], list):
        for point in data['data']:
            x = point.get('x', 0)
            y = point.get('y', 0)
            data_str += f"  ({x}, {y})\n"
    
    template = f"""\\begin{{tikzfigure}}[0.8\\textwidth]
  \\begin{{axis}}[
    title={{{title}}},
    xlabel={{{x_label}}},
    ylabel={{{y_label}}},
    width=\\textwidth*0.8,
    height=0.5\\textwidth,
  ]
    \\addplot[
      only marks,
      mark=o,
      mark size=2pt,
      color=darkblue
    ] coordinates {{
{data_str}    }};
  \\end{{axis}}
\\end{{tikzfigure}}
"""
    return template

# List all JSON files in figures/
fig_dir = Path("figures")
for json_file in sorted(fig_dir.glob("*.json")):
    print(f"Processing {json_file.name}...")
    # Determine chart type from filename
    if "calibration" in json_file.name or "brier" in json_file.name:
        latex_code = json_to_pgfplots_bar(json_file)
    else:
        latex_code = json_to_pgfplots_scatter(json_file)
    
    print(latex_code)
    print("\n" + "="*60 + "\n")
