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
app_name: "form-management-frontend"
project_type: "nodejs"
PRIMARY_STACK: "nextjs"
env: "dev"                # dev|staging|production

# STRUCTURE
repo_root: "."
source_dir: "src"         # src/
build_dir: ".next"        # .next/
test_dir: "tests"         # tests/

# BUILD
build_system: "npm"       # npm
build_cmd: "npm run build"
clean_cmd: "rm -rf .next"

# PACKAGE MANAGER
package_manager: "npm"    # npm
install_cmd: "npm install"

# RUNTIME
runtime: "node"           # node
entrypoint: "src/app"
run_cmd: "npm run dev"

# WEB (if applicable)
framework: "next"         # Next.js framework
server_type: "node"       # node
listen_host: "0.0.0.0"
app_port: 3000
health_path: "/api/health"

# DATABASE (if applicable)
db_kind: "none"           # Frontend doesn't manage DB directly
migration_tool: "none"    # none

# DOCKER (if applicable)
uses_docker: false
compose_file: ""
compose_backend_service: ""

# DEPLOYMENT (if applicable)
deployment_type: "vercel" # vercel (default for Next.js)
systemd_unit: ""

# TESTING
test_cmd: "npm run test:unit"
lint_cmd: "npm run lint"

# SECURITY
has_phi_pii: true         # Default true for safety (form data may contain sensitive info)
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