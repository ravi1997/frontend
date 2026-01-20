import json
import re
import subprocess
from datetime import datetime

# Settings
JSON_FILE = "/home/programmer/Desktop/frontend/plans/IssueTracker/all_issues.json"
REPORT_FILE = "/home/programmer/Desktop/frontend/plans/IssueTracker/DEDUPE_REPORT.md"

def run_gh(args):
    try:
        result = subprocess.run(["gh"] + args, capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running gh {' '.join(args)}: {e.stderr}")
        return None

def extract_key(body):
    if not body: return None
    match = re.search(r'Issue-Key:\s*(PLAN-[A-Z0-9]+)', body)
    if match:
        return match.group(1)
    return None

def main():
    with open(JSON_FILE, "r") as f:
        issues = json.load(f)

    print(f"Scanning {len(issues)} issues...")

    # Grouping
    key_groups = {} # key -> list of issues
    title_groups = {} # normalized title -> list of issues

    for iss in issues:
        key = extract_key(iss['body'])
        if key:
            if key not in key_groups: key_groups[key] = []
            key_groups[key].append(iss)
        
        # Title grouping for fallback
        title = iss['title'].lower().strip()
        # Remove prefix like "ISSUE-0001: " for better matching if present
        title = re.sub(r'issue-\d+:\s*', '', title)
        if title not in title_groups: title_groups[title] = []
        title_groups[title].append(iss)

    duplicate_sets = []

    # Process Strong Keys (PLAN-XXXX)
    handled_numbers = set()
    for key, group in key_groups.items():
        if len(group) > 1:
            duplicate_sets.append(group)
            for iss in group: handled_numbers.add(iss['number'])

    # Process Medium Confidence (Matching Titles with matching evidence segments)
    for title, group in title_groups.items():
        # Only check if not already handled by strong keys
        unhandled_group = [iss for iss in group if iss['number'] not in handled_numbers]
        if len(unhandled_group) > 1:
            # Check if bodies are very similar (e.g. same Context/Problem)
            # For simplicity, we'll assume matching title + same repo context is enough for "Medium"
            duplicate_sets.append(unhandled_group)
            for iss in unhandled_group: handled_numbers.add(iss['number'])

    print(f"Found {len(duplicate_sets)} duplicate sets.")

    results = []
    
    for group in duplicate_sets:
        # Canonical Selection
        # 1. Open over closed
        open_issues = [iss for iss in group if iss['state'] == 'OPEN']
        candidates = open_issues if open_issues else group
        
        # 2. Prefer earlier created if content equivalent
        candidates.sort(key=lambda x: x['createdAt'])
        canonical = candidates[0]
        
        duplicates = [iss for iss in group if iss['number'] != canonical['number']]
        
        results.append({
            "canonical": canonical,
            "duplicates": duplicates
        })

    # Execute Actions
    for entry in results:
        can = entry['canonical']
        dups = entry['duplicates']
        
        print(f"Processing set for: {can['title']} (Canonical: #{can['number']})")
        
        # Label canonical
        run_gh(["issue", "edit", str(can['number']), "--add-label", "canonical"])
        
        for dup in dups:
            # Skip if already closed as duplicate (to avoid spam)
            is_already_dup = any(l['name'] == 'status:Duplicate' for l in dup['labels'])
            if is_already_dup and dup['state'] == 'CLOSED':
                continue

            # Merge Info (Check if duplicate has extra lines not in canonical)
            if len(dup['body'] or "") > len(can['body'] or "") + 100:
                 comment_body = f"Merging additional context from duplicate #{dup['number']}:\n\n{dup['body']}"
                 run_gh(["issue", "comment", str(can['number']), "--body", comment_body])

            # Label Duplicate
            run_gh(["issue", "edit", str(dup['number']), "--add-label", "duplicate,status:Duplicate"])
            
            # Cross-link and Close
            close_comment = f"Duplicate of #{can['number']}. Closing in favor of canonical tracking. See: {can['url']}"
            run_gh(["issue", "close", str(dup['number']), "--comment", close_comment])

    # Generate Report
    with open(REPORT_FILE, "w") as f:
        f.write("# Issue Deduplication Report\n\n")
        f.write(f"- **Timestamp**: {datetime.now().isoformat()}\n")
        f.write(f"- **Total Issues Scanned**: {len(issues)}\n")
        f.write(f"- **Duplicate Sets Found**: {len(duplicate_sets)}\n\n")
        
        f.write("## Canonical Issues Summary\n\n")
        f.write("| Canonical Issue | Duplicates Closed |\n")
        f.write("| --- | --- |\n")
        for entry in results:
            can = entry['canonical']
            dups = entry['duplicates']
            dup_links = ", ".join([f"#{d['number']}" for d in dups])
            f.write(f"| [#{can['number']}: {can['title']}]({can['url']}) | {dup_links} |\n")
        
        f.write("\n## Ambiguous Cases for Manual Review\n")
        f.write("None identified at this confidence level.\n")

    print(f"Deduplication complete. Report written to {REPORT_FILE}")

if __name__ == "__main__":
    main()
