import json
import os

def get_priority_score(labels):
    label_names = [l['name'] for l in labels]
    if 'priority:P0' in label_names: return 0
    if 'priority:P1' in label_names: return 1
    if 'priority:P2' in label_names: return 2
    if 'priority:P3' in label_names: return 3
    return 4  # Default lowest priority

def get_status_score(labels):
    label_names = [l['name'] for l in labels]
    if 'status:Backlog' in label_names or 'status:Planned' in label_names: return 0
    if 'status:Blocked' in label_names: return 2
    return 1 # Default middle

def is_eligible(labels):
    label_names = [l['name'] for l in labels]
    exclude = ['status:Done', 'status:Duplicate', "Won't Fix", 'Deferred']
    for e in exclude:
        if e in label_names:
            return False
    return True

try:
    with open('plans/IssueFixLoop/OPEN_ISSUES_SNAPSHOT.json', 'r') as f:
        issues = json.load(f)

    eligible_issues = [i for i in issues if is_eligible(i['labels'])]

    # Sort: Priority ASC (0 is highest), then Status ASC (0 is best), then CreatedAt ASC (older first)
    eligible_issues.sort(key=lambda x: (
        get_priority_score(x['labels']),
        get_status_score(x['labels']),
        x['createdAt']
    ))

    with open('plans/IssueFixLoop/QUEUE.md', 'w') as f:
        f.write("# Issue Queue\n\n")
        if not eligible_issues:
            f.write("No eligible issues found.\n")
        else:
            for issue in eligible_issues:
                labels = ", ".join([l['name'] for l in issue['labels']])
                f.write(f"- [ ] #{issue['number']}: {issue['title']} (Labels: {labels})\n")

    print(f"Generated queue with {len(eligible_issues)} issues.")

except Exception as e:
    print(f"Error processing issues: {e}")
