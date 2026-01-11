# Project Context (Fill Once)

**Purpose:** Configure project-specific settings for AI agent
**When to use:** Once per project, during initial setup
**Prerequisites:** AI folder copied to project
**Outputs:** Configured AUTO_CONTEXT for agent use

---

## CRITICAL: Use Auto-Setup First

**Recommended:** Let the agent auto-detect everything:

```
User: "Setup AI folder for this project"
```

Agent will:
1. Detect project type (Python/C++/Java/etc.)
2. Find build system (CMake/Maven/npm/etc.)
3. Identify framework (Flask/Spring/React/etc.)
4. Fill ALL fields automatically
5. Report confidence level

**Manual setup only if auto-detection fails.**

---

## AUTO_CONTEXT (Universal Schema)

Copy/paste and edit. **Leave unknowns blank** - agent will infer.

```yaml
# CORE (Required)
app_name: ""              # REQUIRED
project_type: ""          # python|nodejs|java|cpp|go|rust|flutter|static
PRIMARY_STACK: ""         # OPTIONAL: Manual override for stack detection (e.g. "python", "java")
env: "dev"                # REQUIRED - dev|staging|production

# STRUCTURE
repo_root: "."
source_dir: ""            # src/|app/|lib/
build_dir: ""             # dist/|build/|target/
test_dir: ""              # tests/|test/

# BUILD
build_system: ""          # cmake|makefile|maven|npm|pip|uv|cargo
build_cmd: ""
clean_cmd: ""

# PACKAGE MANAGER
package_manager: ""       # pip|uv|npm|maven|cargo|pub
install_cmd: ""

# RUNTIME
runtime: ""               # python|node|java|gcc|go|dart
entrypoint: ""
run_cmd: ""

# WEB (if applicable)
framework: ""             # flask|express|spring|react
server_type: ""           # gunicorn|node|tomcat
listen_host: "0.0.0.0"
app_port: 8000
health_path: "/healthz"

# DATABASE (if applicable)
db_kind: ""               # postgres|mysql|sqlite|mongo|none
migration_tool: ""        # alembic|flyway|sequelize|none

# DOCKER (if applicable)
uses_docker: false
compose_file: ""
compose_backend_service: ""

# DEPLOYMENT (if applicable)
deployment_type: ""       # docker|systemd|k8s|serverless
systemd_unit: ""

# TESTING
test_cmd: ""              # pytest|npm test|mvn test
lint_cmd: ""              # ruff check .|npm run lint

# SECURITY
has_phi_pii: true         # Default true for safety
```

See [`contracts/UNIVERSAL_PROJECT_SCHEMA.md`](contracts/UNIVERSAL_PROJECT_SCHEMA.md) for complete schema.

---

## Validation Checklist

Agent MUST verify:
- [ ] `app_name` is filled (REQUIRED)
- [ ] `project_type` is set (REQUIRED)
- [ ] `env` is correct (dev/staging/production)
- [ ] All blank fields processed by autofill
- [ ] Confidence level calculated
- [ ] If uncertain about env → defaulted to production

---

## See Also

- [`skills/project_auto_setup.md`](skills/project_auto_setup.md) - Auto-detection
- [`autofill/PATH_AND_SERVICE_INFERENCE.md`](autofill/PATH_AND_SERVICE_INFERENCE.md) - Inference rules
- [`examples/example_project_context.md`](examples/example_project_context.md) - Examples