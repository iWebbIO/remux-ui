$py = Get-Content graphify-out\.graphify_python
& $py -m graphify export html

& $py -c "
import json
from pathlib import Path
from datetime import datetime, timezone
from graphify.detect import save_manifest

detect = json.loads(Path('graphify-out/.graphify_detect.json').read_text(encoding='utf-8-sig'))
save_manifest(detect.get('all_files') or detect['files'], root='.')

extract = json.loads(Path('graphify-out/.graphify_extract.json').read_text(encoding='utf-8'))
input_tok = extract.get('input_tokens', 0)
output_tok = extract.get('output_tokens', 0)

cost_path = Path('graphify-out/cost.json')
if cost_path.exists():
    cost = json.loads(cost_path.read_text(encoding='utf-8'))
else:
    cost = {'runs': [], 'total_input_tokens': 0, 'total_output_tokens': 0}

cost['runs'].append({
    'date': datetime.now(timezone.utc).isoformat(),
    'input_tokens': input_tok,
    'output_tokens': output_tok,
    'files': detect.get('total_files', 0),
})
cost['total_input_tokens'] += input_tok
cost['total_output_tokens'] += output_tok
cost_path.write_text(json.dumps(cost, indent=2, ensure_ascii=False), encoding='utf-8')

print(f'This run: {input_tok:,} input tokens, {output_tok:,} output tokens')
print(f'All time: {cost[\"total_input_tokens\"]:,} input, {cost[\"total_output_tokens\"]:,} output ({len(cost[\"runs\"])} runs)')
"

Remove-Item graphify-out\.graphify_detect.json -ErrorAction SilentlyContinue
Remove-Item graphify-out\.graphify_extract.json -ErrorAction SilentlyContinue
Remove-Item graphify-out\.graphify_ast.json -ErrorAction SilentlyContinue
Remove-Item graphify-out\.graphify_semantic.json -ErrorAction SilentlyContinue
Remove-Item graphify-out\.graphify_analysis.json -ErrorAction SilentlyContinue
Remove-Item graphify-out\.graphify_chunk_*.json -ErrorAction SilentlyContinue
Remove-Item graphify-out\.needs_update -ErrorAction SilentlyContinue
Remove-Item graphify-out\ast_extract.py -ErrorAction SilentlyContinue
Remove-Item graphify-out\build_graph.py -ErrorAction SilentlyContinue
Remove-Item graphify-out\cache_check.py -ErrorAction SilentlyContinue
Remove-Item graphify-out\label_communities.py -ErrorAction SilentlyContinue
Remove-Item graphify-out\make_chunks.py -ErrorAction SilentlyContinue
Remove-Item graphify-out\make_prompts.py -ErrorAction SilentlyContinue
Remove-Item graphify-out\merge.py -ErrorAction SilentlyContinue
Remove-Item graphify-out\summary.py -ErrorAction SilentlyContinue
Remove-Item graphify-out\prompt_*.txt -ErrorAction SilentlyContinue
