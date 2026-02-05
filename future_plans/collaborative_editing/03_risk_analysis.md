# 03. Risk Analysis - Collaborative Editing

## Risk Register

| ID | Risk Category | Risk Description | Probability | Impact | Risk Score | Mitigation Strategy | Owner |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| R-CO-001 | Technical | State Divergence (Desync) | Medium | High | 12 | Implement strict CRDT (Yjs) with periodic state hashing/checksums. | Backend Team |
| R-CO-002 | Performance | Broadcast Storms | Medium | High | 12 | Implement adaptive debouncing and binary delta encoding (Protobuf). | DevOps Team |
| R-CO-003 | Security | Unauthorized State Injections | Low | Critical | 10 | Cryptographically signed operations and server-side state validation. | Security Team |
| R-CO-004 | Infrastructure | WebSocket Zombie Connections | High | Medium | 9 | Implement ping/pong hearts and aggressive session timeouts. | DevOps Team |

## Detailed Risk Analysis

### R-CO-001: State Divergence (Desync)

**Risk Description:**
Differences in network latency or edge cases in the CRDT algorithm may lead to different users seeing different versions of the same form.

**Mitigation Strategies:**

- **CRDT Selection**: Utilize Yjs for document-based structures (Form Schema) and LWW (Last-Write-Wins) registers for metadata.
- **State Checksums**: Periodically broadcast a Merkle root of the document state; if a client diverges, trigger a full state re-sync from the server authoritative copy.
- **Local Persistence**: Save the Yjs update log to IndexedDB (Hive) to ensure continuity during temporary disconnects.

### R-CO-002: Broadcast Storms

**Risk Description:**
High collaborator counts (e.g., 50+ users) can generate excessive WebSocket traffic, overwhelming the browser's main thread and the server's egress.

**Mitigation Strategies:**

- **Adaptive Debouncing**: Increase the broadcast interval (from 50ms to 200ms) as the number of concurrent editors increases.
- **Delta Compression**: Only broadcast binary deltas (using Yjs's optimized encoding) rather than full state objects.
- **Presence Throttling**: Sync cursor positions at a lower frequency (e.g., 5Hz) than structural changes (real-time).

### R-CO-003: Unauthorized State Injections

**Risk Description:**
A malicious actor could inject fabricated collaborative events into the WebSocket stream to corrupt form logic or escalate privileges.

**Mitigation Strategies:**

- **JWT-based Handshake**: Require a short-lived, form-specific JWT for the initial WebSocket upgrade.
- **Server-side Validation**: The backend must run a headless state machine that validates every incoming operation against the form's schema and user's RBAC settings.

### R-CO-004: WebSocket Zombie Connections

**Risk Description:**
Mobile devices switching networks or inactive tabs can leave "ghost" connections, consuming server memory and showing inaccurate presence data.

**Mitigation Strategies:**

- **Heartbeat Protocol**: Enforce a 30s ping/pong interval; terminate connections that miss two consecutive heartbeats.
- **Auto-Reconnection**: Implement exponential backoff in the Flutter client with a jittered jitter to prevent a "thundering herd" effect on server recovery.

## Contingency Plans

### Severe Desync Event

1. Force all connected clients to reload the latest saved state from MongoDB.
2. Momentarily switch to a "Read-Only" mode for the affected form.
3. Inspect the `collaboration_logs` to identify the conflicting operation type.

## Risk Monitoring

| KRI | Metric | Threshold | Action |
| :--- | :--- | :--- | :--- |
| Consistency | Hash mismatch frequency | > 0.5% | Inspect CRDT edge cases |
| Performance | Message latency (rtt) | > 300ms | Scale WebSocket replicas |
| Infrastructure | Max concurrent connections | > 80% capacity | Provision additional nodes |
| Usage | CPU usage (JS thread) | > 60% | Increase debouncing |
