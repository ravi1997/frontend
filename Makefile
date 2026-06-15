# Makefile — Form Builder Frontend (Flutter)

.PHONY: help get clean codegen build-runner watch analyze format test run-web build-web build-apk

# ANSI colors
CYAN  := \033[36m
GREEN := \033[32m
YELLOW:= \033[33m
RESET := \033[0m

# ─────────────────────────────────────────────
help: ## Show this help
	@echo "$(CYAN)Form Builder Frontend (Flutter)$(RESET)"
	@echo "======================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort \
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-18s$(RESET) %s\n", $$1, $$2}'

# ─────────────────────────────────────────────
# Dependencies & Build Runner
# ─────────────────────────────────────────────
get: ## Fetch dart dependencies
	@echo "$(CYAN)Fetching packages...$(RESET)"
	@flutter pub get
	@echo "$(GREEN)✅ Packages fetched.$(RESET)"

clean: ## Clean flutter build cache
	@echo "$(CYAN)Cleaning build cache...$(RESET)"
	@flutter clean
	@echo "$(GREEN)✅ Cleaned.$(RESET)"

codegen: build-runner ## Run Riverpod and JSON code generators
build-runner: ## Run one-time code generation build
	@echo "$(CYAN)Running build_runner build...$(RESET)"
	@dart run build_runner build --delete-conflicting-outputs
	@echo "$(GREEN)✅ Code generation complete.$(RESET)"

watch: ## Run continuous code generation watch
	@echo "$(CYAN)Running build_runner watch...$(RESET)"
	@dart run build_runner watch --delete-conflicting-outputs

# ─────────────────────────────────────────────
# Code Quality & Formatting
# ─────────────────────────────────────────────
analyze: ## Run dart static analyzer
	@echo "$(CYAN)Running static analysis...$(RESET)"
	@dart analyze lib/
	@echo "$(GREEN)✅ Analysis complete.$(RESET)"

format: ## Run dart formatter
	@echo "$(CYAN)Formatting code...$(RESET)"
	@dart format .
	@echo "$(GREEN)✅ Formatting complete.$(RESET)"

test: ## Run unit and widget tests
	@echo "$(CYAN)Running test suite...$(RESET)"
	@flutter test
	@echo "$(GREEN)✅ Tests complete.$(RESET)"

# ─────────────────────────────────────────────
# Run & Build targets
# ─────────────────────────────────────────────
run-web: ## Run application in Chrome
	@flutter run -d chrome

build-web: ## Build production web app
	@echo "$(CYAN)Building web release...$(RESET)"
	@flutter build web --release
	@echo "$(GREEN)✅ Web build complete.$(RESET)"

build-apk: ## Build production Android APK
	@echo "$(CYAN)Building APK...$(RESET)"
	@flutter build apk --release
	@echo "$(GREEN)✅ APK build complete.$(RESET)"
