#!/usr/bin/env python3
"""
Generate TikZ figures from JSON chart specs for LaTeX integration.
"""
import json
from pathlib import Path

fig_dir = Path("/home/ec2-user/github/research/papers/accuracy-of-prediction-markets/fig")
tikz_dir = Path("/home/ec2-user/github/research/papers/accuracy-of-prediction-markets/tikz")
tikz_dir.mkdir(exist_ok=True)

def json_to_tikz(json_path):
    """Convert JSON chart spec to TikZ code."""
    with open(json_path) as f:
        data = json.load(f)
    
    chart_type = data.get("type", "line")
    title = data.get("title", "Chart")
    xlabel = data.get("xLabel", "X")
    ylabel = data.get("yLabel", "Y")
    rows = data.get("data", [])
    
    if not rows:
        return""
    
    # Start TikZ environment
    tikz = r"\begin{tikzpicture}" + "\n"
    tikz += r"  \begin{axis}[" + "\n"
    tikz += f"    title={{{title}}},\n"
    tikz += f"    xlabel={{{xlabel}}},\n"
    tikz += f"    ylabel={{{ylabel}}},\n"
    
    if chart_type == "bar":
        tikz += "    ybar,\n"
        tikz += "    bar width=0.7cm,\n"
        tikz += f"    width=0.85\\textwidth,\n"
        tikz += f"    height=0.5\\textwidth,\n"
        tikz += "    legend pos=outer north east,\n"
        
        # Determine x-axis labels
        x_key = data.get("xKey", "category")
        x_labels = [str(row.get(x_key, "")) for row in rows]
        tikz += f"    xtick={{{','.join(str(i+1) for i in range(len(rows)))}}},\n"
        tikz += f"    xticklabels={{{','.join(x_labels)}}},\n"
        tikz += "    x tick label style={rotate=45,anchor=east,font=\\tiny},\n"
        
        # Get y-values
        all_keys = list(rows[0].keys())
        skip_keys = {x_key, "Markets", "markets"}
        y_keys = data.get("yKeys", [k for k in all_keys if k not in skip_keys][0:1])
        
        for y_key in y_keys:
            coords = [(i+1, float(row.get(y_key, 0))) for i, row in enumerate(rows)]
            tikz += f"    ]\n    \\addplot[fill=blue!60] coordinates {{\n"
            for x, y in coords:
                tikz += f"      ({x}, {y})\n"
            tikz += "    };\n"
            tikz += f"    \\addlegend{{{y_key}}}\n"
    
    elif chart_type == "line" or chart_type == "scatter":
        tikz += f"    width=0.85\\textwidth,\n"
        tikz += f"    height=0.5\\textwidth,\n"
        tikz += "    grid=major,\n"
        tikz += "    legend pos=upper left,\n"
        
        if chart_type == "scatter":
            tikz += "    scatter,\n"
        
        tikz += "    ]\n"
        
        # Extract coordinates
        x_key = data.get("xKey", list(rows[0].keys())[0])
        y_keys = data.get("yKeys", [list(rows[0].keys())[1]])
        
        for y_key in y_keys:
            coords = [(float(row.get(x_key, 0)), float(row.get(y_key, 0))) for row in rows]
            tikz += f"    \\addplot[color=blue, mark=o, line width=1.5pt] coordinates {{\n"
            for x, y in coords:
                tikz += f"      ({x}, {y})\n"
            tikz += "    };\n"
            tikz += f"    \\addlegend{{{y_key}}}\n"
    
    tikz += r"    \end{axis}" + "\n"
    tikz += r"  \end{tikzpicture}"
    
    return tikz

# Generate TikZ for each JSON file
json_files = sorted(fig_dir.glob("*.json"))
for json_file in json_files:
    tikz_code = json_to_tikz(json_file)
    if tikz_code:
        output_file = tikz_dir / f"{json_file.stem}.tikz"
        with open(output_file, 'w') as f:
            f.write(tikz_code)
        print(f"✓ {json_file.stem}")
    else:
        print(f"✗ {json_file.stem} (empty)")

print(f"\nGenerated {len(list(tikz_dir.glob('*.tikz')))} TikZ files")
