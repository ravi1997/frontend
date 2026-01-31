# Feature Kickoff: Offline Submission Sync Engine

## Name: Offline Submission Sync Engine

## Linked Task: M-15

## Description

Implement a robust offline sync mechanism that allows users to submit forms without an active internet connection. Submissions are stored locally in Hive and automatically synchronized with the backend when the connection is restored.

## Implementation Plan

1. **Connectivity Service**: Create a dedicated service using `connectivity_plus` to monitor network status.
2. **Submission Queue (Hive)**: Set up a Hive box `pending_submissions` to store JSON-serialized form responses that failed to upload.
3. **Sync Manager**:
    * Implement a background-aware sync loop that triggers on connectivity restoration.
    * Handle retry logic with exponential backoff for persistent failures (e.g., 500 errors vs. no network).
4. **Repository Update**: Modify `ResponseRepository` to fallback to local storage on network failure.
5. **UI Feedback**: Add a "Sync Status" indicator to the Dashboard or Response List to show pending uploads.

## Tests

* [ ] **Connectivity Listener**: Verify service correctly detects online/offline transitions.
* [ ] **Offline Storage**: Verify responses are successfully written to Hive when network is down.
* [ ] **Automatic Sync**: Verify stored submissions are sent to backend once online.
* [ ] **Data Integrity**: Ensure synced data matches original submission input.

## Checkpoints

* [ ] Connectivity service implemented.
* [ ] Hive submission queue configured.
* [ ] Sync logic integrated into repository.
* [ ] UI indicators added.
* [ ] Tests passing.
