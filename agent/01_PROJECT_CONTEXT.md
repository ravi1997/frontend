# Project Context (Fill Once)

**Purpose:** Configure project-specific settings for AI agent.
**When to use:** Once per project, during initial setup.
**Outputs:** Configured AUTO_CONTEXT for agent use.

---

## 🚀 AUTO-SETUP (Recommended)

**"Setup AI folder for this project"**
The agent will:

1. Detect Language & Framework (Python, Node, Java, Go, etc.)
2. Find Build System (Maven, Gradle, CMake, NPM, etc.)
3. Identify Docker/Ports/Entrypoints.
4. Fill this file automatically.

---

## 📋 AUTO_CONTEXT (Universal Schema)

Copy/paste and edit. **Leave unknowns blank** - agent will infer.

```yaml

# ============================================

# 1. CORE IDENTITY

# ============================================

app_name: "form-management-frontend"              # REQUIRED (e.g., "my-fintech-app")
project_type: "nodejs"            # REQUIRED (python|nodejs|java|cpp|go|rust|flutter|static)
env: "dev"                # REQUIRED (dev|staging|production)

# ============================================

# 2. STRUCTURE & BUILD

# ============================================

repo_root: "."            # usually "."
source_dir: "src"         # src/|app/|lib/|backend/
build_system: "npm"       # cmake|gradle|maven|npm|poetry|cargo|go
package_manager: "npm"    # pip|npm|yarn|mvn|gradlew|go mod

# ============================================

# 3. RUNTIME & ENTRYPOINT

# ============================================

entrypoint: "npm run dev"            # main.py|index.js|App.java|main.go
run_cmd: "npm run dev"               # "python app.py" | "npm start" | "./gradlew bootRun"
test_cmd: "npm run test:unit"              # "pytest" | "npm test" | "go test ./..."
app_port: 3000            # Internal port the app listens on

# ============================================

# 4. INFRASTRUCTURE (Docker/Deploy)

# ============================================

uses_docker: false        # true/false
compose_file: ""          # docker-compose.yml
compose_service_name: ""  # The main app service name in compose
deployment_type: ""       # docker|systemd|k8s|serverless

# ============================================

# 5. SECURITY

# ============================================

has_phi_pii: true         # Default true for safety (Redact logs)

```

See [`contracts/UNIVERSAL_PROJECT_SCHEMA.md`](contracts/UNIVERSAL_PROJECT_SCHEMA.md) for full details.

---

## ✅ Validation Checklist

Agent MUST verify:

- [ ] `app_name`, `project_type`, `env` are filled.
- [ ] `test_cmd` is valid for the stack.
- [ ] If `uses_docker: true`, `compose_file` is located.
