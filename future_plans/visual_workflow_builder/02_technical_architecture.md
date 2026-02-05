# 02. Technical Architecture - Visual Workflow Builder

## System Architecture Overview

The Workflow Builder follows a decoupled architecture where the frontend serves as an interactive Graph Editor and the backend functions as a Distributed State Machine.

```
┌─────────────────────────────────────────────────────────────┐
│                   Frontend (Flutter Web)                    │
│  ┌──────────────────┐  ┌────────────────┐  ┌──────────────┐ │
│  │ Flow Designer    │  │ State Store    │  │ Graph Valid. │ │
│  │ (Canvas/Zoom/Pan)│  │ (Riverpod)     │  │ Engine       │ │
│  └──────────────────┘  └────────────────┘  └──────────────┘ │
└─────────────────────────────┬───────────────────────────────┘
                              │ JSON Graph Definition
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   Backend Workflow API (Flask)              │
│  ┌──────────────────┐  ┌────────────────┐  ┌──────────────┐ │
│  │ Workflow Parser  │  │ Versioning     │  │ Webhook      │ │
│  │ & Optimizer      │  │ Manager        │  │ Handlers     │ │
│  └──────────────────┘  └────────────────┘  └──────────────┘ │
└─────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 Distributed Execution Engine                │
│  ┌──────────────────┐  ┌────────────────┐  ┌──────────────┐ │
│  │ Task Queue       │  │ State Machine  │  │ Worker Pool  │ │
│  │ (Redis/RabbitMQ) │  │ (Durable Func) │  │ (Parallel)   │ │
│  └──────────────────┘  └────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Architectural Components

### 1. The Designer (Frontend)

- **Graph Canvas**: Implemented using a custom-rendered canvas or a specialized package like `interactive_viewer` to support infinitely scalable layouts, zooming, and panning.
- **Node Meta-model**: Each node is a serialized JSON object containing:
  - `type`: Trigger, Action, or Logic.
  - `properties`: Node-specific configuration (e.g., SMTP settings, Webhook URL).
  - `ports`: Dynamic input/output anchor points.
- **Orthographic Routing**: Connection lines utilize Manhattan routing algorithms to avoid overlapping nodes and provide professional aesthetics.

### 2. The Execution Engine (Backend)

- **Event-Driven Execution**: Workflows are triggered by external events (e.g., `form.submitted`) or scheduled cron jobs.
- **Durable Execution**: Long-running workflows (e.g., "Wait for 3 days") utilize persistent state storage. If a worker fails, the execution resumes from the last completed node.
- **Topological Sorting & Parallelism**: The backend parses the Graph into an Adjacency List, identifies independent branches, and executes them in parallel where possible.

### 3. Expression Engine

- **Logic Parsing**: Uses a secure sandboxed expression evaluator (e.g., `simpleeval` in Python) to prevent code injection while allowing complex boolean logic (e.g., `{{age}} > 18 and {{country}} == 'US'`).

## Component Specifications (Frontend)

### New Flutter Packages

```yaml
dependencies:
  # Graph Visualization
  graphview: ^1.2.0        # Force-directed or tree layouts
  vector_math: ^2.1.4      # For canvas transformations
  
  # State & Persistence
  riverpod: ^2.4.0
  json_serializable: ^6.7.1
```

### Domain Services (Abstracted)

```dart
/// Manages the local graph state during design time
abstract class IWorkflowDesignerController {
  void addNode(WorkflowNode node);
  void connectNodes(String sourceId, String targetId);
  bool validateGraph(); // Cycle detection, orphaned node checks
  String serialize();    // Export to JSON for backend
}

/// Interface with the execution API
abstract class IWorkflowRepository {
  Future<void> publishWorkflow(String jsonGraph);
  Stream<WorkflowExecutionStatus> monitorExecution(String id);
}
```

## Deployment & Scaling

1. **Concurrency**: Use a task queue (e.g., Celery or RQ) to handle thousands of concurrent workflow executions without blocking the main API.
2. **Isolation**: Workflow actions that execute user-provided code or expressions must run in a restricted sandbox or isolated container.
3. **Auditability**: Every node execution transition must be logged to a `workflow_logs` table for debugging and compliance.
