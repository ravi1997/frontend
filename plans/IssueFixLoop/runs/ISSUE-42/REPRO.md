# Reproduction Plan: ISSUE-42

## Current State Analysis

Running a container from the current Dockerfile defaults to root.

### Reproduction Steps

1. Build current image: `docker build -t test-issue-42-repro .`
2. Run check: `docker run --rm test-issue-42-repro id`

### Expected Output (Before Fix)

`uid=0(root) gid=0(root) ...`

### Target Output (After Fix)

`uid=1000(node) gid=1000(node) ...`
