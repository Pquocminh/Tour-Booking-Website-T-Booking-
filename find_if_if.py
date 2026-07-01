import os
import re

def analyze_java_files(root_dir):
    results = []
    
    # Regex to find 'if' statements. We want to capture the condition.
    if_pattern = re.compile(r'^(\s*)if\s*\((.*)\)\s*\{?')
    
    for subdir, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith('.java'):
                filepath = os.path.join(subdir, file)
                with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                    lines = f.readlines()
                
                prev_indent = None
                prev_condition = None
                prev_line_num = -1
                
                in_block_comment = False
                
                for i, line in enumerate(lines):
                    stripped = line.strip()
                    
                    if stripped.startswith('/*'):
                        in_block_comment = True
                    if '*/' in stripped:
                        in_block_comment = False
                        continue
                    if in_block_comment or stripped.startswith('//'):
                        continue
                    
                    match = if_pattern.match(line)
                    if match:
                        indent = match.group(1)
                        condition = match.group(2)
                        
                        # If we saw an 'if' before, and it's at the same indentation, check distance
                        if prev_indent == indent:
                            # Are they checking the same variable? Simple heuristic: check first word
                            prev_var = re.split(r'\b', prev_condition)[1] if len(re.split(r'\b', prev_condition)) > 1 else prev_condition
                            curr_var = re.split(r'\b', condition)[1] if len(re.split(r'\b', condition)) > 1 else condition
                            
                            # Just log consecutive ifs that are close to each other (e.g. separated by just a closing brace '}')
                            distance = i - prev_line_num
                            
                            # Let's check what's between them
                            between = "".join([l.strip() for l in lines[prev_line_num+1:i]])
                            if between == '}' or between == '' or between == '} else {':
                                pass # This is not if-if
                            
                            if between.endswith('}'): 
                                results.append(f"{file}:{i+1} -> Consecutive if found. \n  Prev: if ({prev_condition})\n  Curr: if ({condition})")
                                
                        prev_indent = indent
                        prev_condition = condition
                        prev_line_num = i
                    elif stripped != '' and stripped != '}':
                        if not stripped.startswith('}'):
                             # If we encounter regular statements, we might reset, but let's keep it simple
                             pass

    return results

if __name__ == '__main__':
    res = analyze_java_files('src/main/java')
    for r in res:
        print(r)
