import os
import hashlib
import json
import subprocess
import re
import datetime

ISSUES_DIR = "/home/programmer/Desktop/frontend/plans/IssueTracker/issues"
SYNC_REPORT_PATH = "/home/programmer/Desktop/frontend/plans/IssueTracker/SYNC_REPORT.md"
ISSUE_INDEX_PATH = "/home/programmer/Desktop/frontend/plans/IssueTracker/ISSUE_INDEX.md"
REPO = "ravi1997/frontend"

def get_key(title, source):
    data = (title.strip().lower() + source.strip().lower()).encode('utf-8')
    return "PLAN-" + hashlib.sha256(data).hexdigest()[:8].upper()

def run_command(command):
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        if "already exists" in e.stderr:
            return None
        print(f"DEBUG: Command failed: {' '.join(command)}")
        print(f"DEBUG: Error: {e.stderr}")
        return None

def main():
    print("Starting Optimized Issue Sync...")
    issues_data = []
    sync_stats = {"created": 0, "updated": 0, "closed": 0, "failed": 0, "skipped": 0}
    
    if not os.path.exists(ISSUES_DIR):
        print(f"Error: {ISSUES_DIR} does not exist.")
        return

    # 1. Fetch ALL existing issues once
    print("Fetching existing issues from GitHub...")
    all_issues_json = run_command(["gh", "issue", "list", "--state", "all", "--limit", "300", "--json", "number,title,body,state"])
    existing_map = {}
    if all_issues_json:
        all_issues = json.loads(all_issues_json)
        for iss in all_issues:
            # Extract Key from body
            key_match = re.search(r'Issue-Key: (PLAN-[A-Z0-9]+)', iss['body'])
            if key_match:
                existing_map[key_match.group(1)] = iss

    # 2. Sync Logic
    files = sorted([f for f in os.listdir(ISSUES_DIR) if f.endswith(".md")])
    for filename in files:
        path = os.path.join(ISSUES_DIR, filename)
        with open(path, 'r') as f:
            content = f.read()
            
        # Parse title
        title_match = re.search(r'^# (.+)$', content, re.MULTILINE)
        title = title_match.group(1).strip() if title_match else filename
        
        # Parse source
        source_match = re.search(r'plans/[^\s`]+', content)
        source = source_match.group(0).strip("`").strip(":") if source_match else "unknown"
        
        # Calculate Key
        key = get_key(title, source)
        
        # Parse Metadata (Labels, Priority, Status, Milestone)
        labels = []
        priority = "P2"
        status = "Backlog"
        milestone = ""
        
        # Extract metadata from the text (lenient regex)
        meta_match = re.search(r'labels[:\* ]+ (.+)$', content, re.MULTILINE | re.IGNORECASE)
        if meta_match:
            parts = meta_match.group(1).split(",")
            for p in parts:
                p = p.strip().replace("*", "")
                if p.lower().startswith("type:"): labels.append(p)
                elif "priority:" in p.lower(): priority = p.split(":")[1].strip().upper()
                elif "status:" in p.lower(): status = p.split(":")[1].strip()
                elif "component:" in p.lower(): labels.append(p)

        milestone_match = re.search(r'milestone[:\* ]+ ([^\n]+)', content, re.IGNORECASE)
        if milestone_match:
            milestone = milestone_match.group(1).strip().replace("*", "").strip("`")

        gh_labels = labels + [f"status:{status}", f"priority:{priority}"]
        label_str = ",".join([l for l in gh_labels if l])
        
        body_header = f"**Status:** {status}\n**Priority:** {priority}\n**Issue-Key:** {key}\n\n"
        body_content = re.sub(r'^# .+', '', content, count=1).strip()
        body_content = re.sub(r'\*\*Status:\*\* .+', '', body_content)
        body_content = re.sub(r'\*\*Priority:\*\* .+', '', body_content)
        body_content = re.sub(r'Issue-Key: .+', '', body_content)
        full_body = body_header + body_content.strip()
        
        existing = existing_map.get(key)
        issue_number = None

        if existing:
            issue_number = str(existing['number'])
            # Check if update needed
            if existing['title'] == title and existing['body'].strip() == full_body.strip():
                print(f"Issue #{issue_number} is up to date. Skipping.")
                sync_stats["skipped"] += 1
            else:
                print(f"Updating issue #{issue_number}...")
                edit_cmd = ["gh", "issue", "edit", issue_number, "--title", title, "--body", full_body, "--add-label", label_str]
                if milestone: edit_cmd += ["--milestone", milestone]
                run_command(edit_cmd)
                sync_stats["updated"] += 1
            
            # Close/Reopen
            if status in ["Done", "Won't Fix"] and existing['state'] == 'OPEN':
                run_command(["gh", "issue", "close", issue_number])
                sync_stats["closed"] += 1
            elif status not in ["Done", "Won't Fix"] and existing['state'] == 'CLOSED':
                run_command(["gh", "issue", "reopen", issue_number])
        else:
            print(f"Creating new issue for {title}...")
            create_cmd = ["gh", "issue", "create", "--title", title, "--body", full_body, "--label", label_str]
            if milestone: create_cmd += ["--milestone", milestone]
            
            issue_url = run_command(create_cmd)
            if issue_url and "github.com" in issue_url:
                issue_number = issue_url.split("/")[-1]
                sync_stats["created"] += 1
            else:
                print(f"Failed to create issue: {title}")
                sync_stats["failed"] += 1
                
        issues_data.append({
            "key": key,
            "number": issue_number or "None",
            "title": title,
            "status": status,
            "priority": priority,
            "milestone": milestone,
            "source": source
        })

    # 3. Write Index
    print("Writing index...")
    with open(ISSUE_INDEX_PATH, 'w') as f:
        f.write("# Issue Tracker Index\n\n")
        f.write("| Key | # | Title | Status | Priority | Milestone | Source |\n")
        f.write("| --- | --- | --- | --- | --- | --- | --- |\n")
        for i in issues_data:
            f.write(f"| {i['key']} | {i['number']} | {i['title']} | {i['status']} | {i['priority']} | {i['milestone']} | {i['source']} |\n")

    # 4. Write Sync Report
    print("Writing sync report...")
    with open(SYNC_REPORT_PATH, 'w') as f:
        now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        f.write("# Sync Report\n\n")
        f.write(f"- **Timestamp**: {now}\n")
        f.write(f"- **Repo**: {REPO}\n")
        f.write(f"- **Discovered**: {len(issues_data)}\n")
        f.write(f"- **Created**: {sync_stats['created']}\n")
        f.write(f"- **Updated**: {sync_stats['updated']}\n")
        f.write(f"- **Skipped**: {sync_stats['skipped']}\n")
        f.write(f"- **Closed**: {sync_stats['closed']}\n")
        f.write(f"- **Failed**: {sync_stats['failed']}\n")
    
    print("Sync complete.")

if __name__ == "__main__":
    main()
