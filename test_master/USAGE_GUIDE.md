# Test Master - Comprehensive Usage Guide

## Overview

Test Master is an advanced automated testing orchestration system that integrates with Agent OS workflows to provide comprehensive, persona-based testing for web applications. It generates diverse user personas, creates comprehensive test suites, executes tests using Playwright, and produces detailed reports from both persona and manager perspectives.

## Quick Start

### 1. Installation

```bash
# Navigate to test_master directory
cd test_master

# Install Python dependencies
pip install -r requirements.txt

# Install Playwright browsers (for actual test execution)
playwright install
```

### 2. Basic Usage

```bash
# Run complete test cycle with default configuration
python3 test_master.py

# Run with verbose logging
python3 test_master.py --verbose

# Run with custom configuration
python3 test_master.py --config path/to/custom_config.yaml
```

### 3. Demo Mode

```bash
# Run quick demo (minimal output)
python3 demo.py --mode quick

# Run full demo (showcases all components)
python3 demo.py --mode full
```

## Configuration

### Main Configuration File (`config.yaml`)

The main configuration file controls all aspects of Test Master behavior:

```yaml
# Application to test
execution_config:
  app_url: "http://localhost:3000"
  timeout: 30000
  headless: false
  screenshot_on_failure: true

# Persona generation settings
persona_generation:
  total_personas: 25
  selected_personas: 5
  ensure_diversity: true
  include_accessibility: true
  include_security_focused: true
  random_seed: null  # Set for reproducible results

# Test types to execute
test_types:
  - unit_tests
  - integration_tests
  - system_tests
  - regression_tests
  - ui_tests
  - impression_tests
  - usability_tests
  - exploratory_tests
  - performance_tests
  - security_tests
  - accessibility_tests
  - expected_failure_cases

# Quality gate thresholds
quality_gates:
  logic_correctness: 100
  static_analysis: 0
  build_integrity: "no_warnings"
  code_hygiene: "no_new_todos"
  coverage: 80

# Agent OS integration
agent_os_integration:
  enabled: true
  state_files:
    project_state: "agent/09_state/PROJECT_STATE.md"
    test_state: "agent/09_state/TEST_STATE.md"
    backlog_state: "agent/09_state/BACKLOG_STATE.md"
  gates:
    global_quality: "agent/05_gates/global/gate_global_quality.md"
    testing_rules: "agent/11_rules/testing_rules.md"
```

## Execution Modes

### Full Mode (Default)

Runs complete test cycle from persona generation to report generation:

```bash
python3 test_master.py
```

This executes all phases:

1. **Context Initialization** - Loads Agent OS state and project context
2. **Persona Generation** - Generates 25+ diverse personas
3. **Persona Selection** - Selects 5+ diverse personas for testing
4. **Test Suite Generation** - Creates comprehensive test suites for each persona
5. **Test Execution** - Executes tests using Playwright
6. **Report Generation** - Generates persona and manager reports
7. **Agent OS State Update** - Updates state files and validates quality gates
8. **Final Summary** - Displays execution summary

### Personas Mode

Run tests for specific personas only:

```bash
python3 test_master.py --mode personas --personas P-001 P-003 P-005
```

### Reports Mode

Generate reports only (assumes test execution already done):

```bash
python3 test_master.py --mode reports
```

## Persona System

### Persona Dimensions

Test Master generates personas with the following dimensions:

#### 1. Behavior Patterns

- **Focused**: Methodical, step-by-step execution
- **Distracted**: Prone to errors, skips steps
- **Multi-tasking**: Rapid navigation, multiple tabs
- **Exploratory**: Clicks everything, tries edge cases

#### 2. Technology Experience

- **Novice**: Struggles with UI patterns, needs guidance
- **Intermediate**: Comfortable with standard patterns
- **Expert**: Power user, keyboard shortcuts, advanced features
- **Accessibility User**: Screen reader, keyboard-only, magnification

#### 3. Testing Styles

- **Fast**: Quick execution, surface-level validation
- **Detailed**: Thorough examination, documentation-heavy
- **Emotional**: Impression-based feedback, subjective experience
- **Technical**: Bug detection, code-level analysis, API validation
- **Security-Focused**: Vulnerability hunting, input validation

#### 4. Interaction Styles

- **Form-Heavy**: Extensive form filling, validation testing
- **Navigation-Heavy**: Deep linking, routing, browser history
- **Visual**: Design critique, responsiveness, aesthetics
- **Textual**: Content validation, localization, accessibility
- **Mobile-First**: Touch interactions, gestures, responsive design

#### 5. Roles

- **Casual User**: Occasional use, simple tasks
- **Power User**: Daily use, advanced features
- **Administrator**: Configuration, management, permissions
- **Developer**: API testing, technical validation
- **QA Tester**: Systematic testing, edge cases

#### 6. Agent Profiles

- **Skeptical**: Assumes code is broken until proven otherwise
- **Vandal**: Tries to break system with malicious/large inputs
- **Reporter**: Provides clear steps to reproduce every bug
- **Balanced**: Provides balanced feedback across all areas

### Persona Selection Algorithm

Test Master uses a sophisticated selection algorithm to ensure diversity:

1. **Guaranteed Representation**:
   - At least 1 accessibility user
   - At least 1 security-focused persona
   - At least 1 skeptical persona

2. **Diversity Scoring**:
   - Scores candidates based on unused dimensions
   - Prioritizes covering different technology experience levels
   - Ensures variety in behaviors, testing styles, and roles

3. **Final Selection**:
   - Selects top-scoring candidates
   - Ensures no duplicate dimension combinations

## Test Types

Test Master supports 12 different test types:

### 1. Unit Tests

Component-level validation, widget testing, state management verification

### 2. Integration Tests

Component interaction validation, API integration testing, state flow verification

### 3. System Tests

End-to-end user flows, complete feature workflows, multi-step scenarios

### 4. Regression Tests

Validate existing functionality, prevent feature breakage

### 5. UI Tests

Visual regression testing, responsive design validation, component rendering

### 6. Impression Tests

First impression analysis, UX evaluation, user experience scoring

### 7. Usability Tests

Task completion rates, navigation efficiency, error handling validation

### 8. Exploratory Tests

Edge case discovery, unexpected behavior hunting, boundary testing

### 9. Performance Tests

Load testing, response time measurement, memory usage monitoring

### 10. Security Tests

Input validation, XSS prevention, CSRF protection, authentication/authorization

### 11. Accessibility Tests

Screen reader compatibility, keyboard navigation, color contrast validation, ARIA attributes

### 12. Expected Failure Cases

Error handling validation, edge case failure scenarios, network failure simulation

## Report Structure

### Persona-Level Reports

Each persona generates a comprehensive report including:

1. **Persona Profile** - Detailed characteristics and preferences
2. **First Impressions** - Initial app perception from persona's perspective
3. **Test Execution Summary** - Pass/fail statistics and execution time
4. **Detailed Test Results** - Step-by-step test results with screenshots
5. **Issues Discovered** - Bug reports with severity and reproduction steps
6. **Detailed Feedback** - UX, accessibility, performance, security, navigation, content
7. **Suggestions for Improvement** - Prioritized recommendations
8. **Screenshots & Evidence** - Visual evidence of test execution
9. **Conclusion** - Overall assessment from persona's perspective

### Manager-Level Report

Consolidated report including:

1. **Executive Summary** - High-level overview and key findings
2. **Test Coverage Analysis** - Breakdown by test type and feature
3. **Critical Issues** - Must-fix issues before release
4. **Quality Gate Assessment** - Agent OS gate compliance status
5. **Persona Insights** - Common themes and persona-specific findings
6. **Recommendations** - Immediate, short-term, and long-term actions
7. **Release Readiness** - Assessment and recommended actions
8. **Appendices** - Detailed test results, bug reports, screenshots

## Agent OS Integration

### State Management

Test Master integrates with Agent OS state files:

- **PROJECT_STATE.md** - Overall project status and metrics
- **TEST_STATE.md** - Test execution statistics and known issues
- **BACKLOG_STATE.md** - Pending features and tasks

### Quality Gates

Test Master validates against Agent OS quality gates:

| Gate | Requirement | Status |
|-------|-------------|--------|
| Logic Correctness | 100% Pass Rate | PASS/FAIL |
| Static Analysis | 0 Errors | PASS/FAIL |
| Build Integrity | No Warnings | PASS/FAIL |
| Code Hygiene | No New TODOs | PASS/FAIL |
| Coverage | >= 80% | PASS/FAIL |

### Continuity Snapshots

Test Master creates continuity snapshots for resume capability:

- Tracks execution progress
- Saves state for budget management
- Enables resuming interrupted sessions

## Output Structure

```
test_master/
├── personas/                  # Generated persona YAML files
│   ├── persona_P-001.yaml
│   ├── persona_P-002.yaml
│   └── ...
├── test_suites/               # Generated test suite YAML files
│   ├── suite_SUITE-P-001.yaml
│   ├── suite_SUITE-P-002.yaml
│   └── ...
├── execution_logs/             # Test execution logs (JSON)
│   ├── execution_P-001_20240101_120000.json
│   ├── execution_P-002_20240101_120500.json
│   └── ...
├── screenshots/                # Test failure screenshots
│   ├── P-001/
│   │   ├── T-P-001-UNIT-001_20240101_120000.png
│   │   └── ...
│   └── ...
├── reports/                   # Generated reports
│   ├── persona/              # Persona-level reports
│   │   ├── report_P-001.md
│   │   ├── report_P-002.md
│   │   └── ...
│   └── manager/              # Manager-level reports
│       └── comprehensive_test_report_20240101_120000.md
├── artifacts/                 # Test artifacts
│   ├── coverage_report.html
│   ├── performance_metrics.json
│   └── bug_reports.json
└── continuity/               # Continuity snapshots
    └── progress_snapshot_20240101_120000.md
```

## Examples

### Example 1: Basic Test Execution

```bash
# Run complete test cycle
cd test_master
python3 test_master.py
```

### Example 2: Custom Configuration

```bash
# Create custom config
cat > my_config.yaml << EOF
execution_config:
  app_url: "https://myapp.example.com"
  headless: true

persona_generation:
  total_personas: 30
  selected_personas: 10

quality_gates:
  coverage: 90
EOF

# Run with custom config
python3 test_master.py --config my_config.yaml
```

### Example 3: Test Specific Personas

```bash
# Run tests for specific personas
python3 test_master.py --mode personas --personas P-001 P-005 P-010
```

### Example 4: Generate Reports Only

```bash
# Assuming test execution already done
python3 test_master.py --mode reports
```

## Troubleshooting

### Common Issues

1. **Playwright not installed**

```bash
playwright install
```

1. **Python dependencies missing**

```bash
pip install -r test_master/requirements.txt
```

1. **Configuration file not found**

```bash
# Ensure config.yaml exists in test_master directory
ls test_master/config.yaml

# Or specify custom config
python3 test_master.py --config path/to/config.yaml
```

1. **Agent OS state files not found**

```bash
# Agent OS integration will be disabled automatically
# Check paths in config.yaml under agent_os_integration.state_files
# This is normal if Agent OS is not configured
```

1. **Tests failing consistently**

```bash
# Check application URL is correct in config
cat test_master/config.yaml | grep app_url

# Verify application is running and accessible
curl http://localhost:3000

# Review execution logs for detailed error messages
cat test_master/execution_logs/test_master.log
```

## Best Practices

1. **Configuration**
   - Customize `config.yaml` for your specific application
   - Set appropriate quality gate thresholds
   - Configure correct application URL

2. **Persona Selection**
   - Use default selection for comprehensive coverage
   - Specify personas for targeted testing
   - Ensure diversity for different user types

3. **Test Execution**
   - Run in non-headless mode for debugging
   - Enable verbose logging for troubleshooting
   - Review execution logs after each run

4. **Report Review**
   - Start with manager-level report for overview
   - Review persona reports for detailed findings
   - Prioritize critical and high-priority issues

5. **Continuous Improvement**
   - Update test suites based on findings
   - Adjust persona characteristics as needed
   - Refine quality gate thresholds

## Advanced Usage

### Custom Persona Generation

```python
from persona_generator import PersonaGenerator

# Create generator with seed for reproducibility
generator = PersonaGenerator(seed=42)

# Generate custom number of personas
personas = generator.generate_personas(50)

# Select specific number of diverse personas
selected = generator.select_diverse_personas(10)

# Save to custom location
generator.save_personas("custom_personas_dir")
```

### Custom Test Suite Generation

```python
from test_suite_generator import TestSuiteGenerator
import yaml

# Load configuration
with open('config.yaml', 'r') as f:
    config = yaml.safe_load(f)

# Create generator
generator = TestSuiteGenerator(config)

# Generate test suite for specific persona
test_suite = generator.generate_test_suite(persona)

# Save to custom location
generator.save_test_suite(test_suite, "custom_suites_dir")
```

### Custom Report Generation

```python
from report_generator import ReportGenerator
import logging

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger('ReportGenerator')

# Create report generator
report_gen = ReportGenerator(config, logger)

# Generate persona report
report_path = report_gen.generate_persona_report(persona, test_suite, summary)

# Generate manager report
manager_report_path = report_gen.generate_manager_report(personas, summaries, config)
```

## Integration with CI/CD

### GitHub Actions Example

```yaml
name: Test Master

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.8'
      - name: Install dependencies
        run: |
          cd test_master
          pip install -r requirements.txt
          playwright install
      - name: Run Test Master
        run: |
          cd test_master
          python3 test_master.py --mode full
      - name: Upload reports
        uses: actions/upload-artifact@v2
        with:
          name: test-reports
          path: test_master/reports/
```

## Support

For issues, questions, or contributions:

1. Review documentation: `test_master/README.md`
2. Check configuration: `test_master/config.yaml`
3. Review execution logs: `test_master/execution_logs/test_master.log`
4. Refer to Agent OS documentation: `agent/`

## Version History

- **v2.0** - Enhanced with Agent OS integration, comprehensive persona generation, multi-dimensional testing, and robust reporting framework
- **v1.0** - Initial test master prompt with basic persona generation and testing

---

**Test Master System**: v2.0  
**Agent OS Integration**: Enabled  
**Last Updated**: 2024
