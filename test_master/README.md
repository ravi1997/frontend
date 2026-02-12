# Test Master: Comprehensive Automated Testing Orchestration System

## Overview

Test Master is an advanced automated testing orchestration system that integrates with Agent OS workflows to provide comprehensive, persona-based testing for web applications. It generates diverse user personas, creates comprehensive test suites, executes tests using Playwright, and produces detailed reports from both persona and manager perspectives.

## Features

- **Multi-Dimensional Persona Generation**: Creates 25+ diverse personas with varying characteristics including technology experience, behavior patterns, testing styles, and accessibility needs
- **Comprehensive Test Coverage**: Supports 12 test types including unit, integration, system, regression, UI, impression, usability, exploratory, performance, security, accessibility, and expected failure cases
- **Playwright Integration**: Executes tests using Playwright for reliable cross-browser automation
- **Agent OS Integration**: Seamlessly integrates with Agent OS state management and quality gates
- **Detailed Reporting**: Generates persona-level reports with detailed feedback and manager-level consolidated reports with actionable insights
- **Continuity Support**: Creates snapshots for resuming interrupted test sessions
- **Quality Gate Validation**: Validates against Agent OS quality gates including logic correctness, static analysis, build integrity, code hygiene, and coverage

## Architecture

```
test_master/
├── config.yaml                 # Main configuration file
├── requirements.txt            # Python dependencies
├── README.md                  # This file
├── persona_generator.py        # Persona generation system
├── test_suite_generator.py     # Test suite generation
├── test_executor.py           # Test execution with Playwright
├── report_generator.py         # Report generation
├── agent_os_integration.py    # Agent OS state integration
├── test_master.py             # Main orchestrator
├── personas/                  # Generated persona files
├── test_suites/              # Generated test suites
├── execution_logs/            # Test execution logs
├── screenshots/               # Test failure screenshots
├── reports/                  # Generated reports
│   ├── persona/              # Persona-level reports
│   └── manager/              # Manager-level reports
├── artifacts/                 # Test artifacts
└── continuity/               # Continuity snapshots
```

## Installation

### Prerequisites

- Python 3.8 or higher
- Playwright (for test execution)
- Agent OS framework (optional, for state integration)

### Setup

1. Clone the repository or navigate to the project directory

2. Install Python dependencies:

```bash
cd test_master
pip install -r requirements.txt
```

1. Install Playwright browsers (if executing tests):

```bash
playwright install
```

## Configuration

The main configuration file is `config.yaml`. Key configuration sections:

### Execution Configuration

```yaml
execution_config:
  app_url: "http://localhost:3000"  # Application URL to test
  timeout: 30000                      # Default timeout in milliseconds
  headless: false                      # Run browser in headless mode
  screenshot_on_failure: true           # Capture screenshots on failures
```

### Persona Generation

```yaml
persona_generation:
  total_personas: 25                  # Total personas to generate
  selected_personas: 5                  # Number of personas to test
  ensure_diversity: true               # Ensure diverse selection
  include_accessibility: true           # Include accessibility users
  include_security_focused: true         # Include security-focused personas
  random_seed: null                    # Seed for reproducible results
```

### Test Types

```yaml
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
```

### Quality Gates

```yaml
quality_gates:
  logic_correctness: 100               # 100% pass rate required
  static_analysis: 0                   # 0 errors allowed
  build_integrity: "no_warnings"        # No build warnings
  code_hygiene: "no_new_todos"        # No new TODOs/FIXMEs
  coverage: 80                         # 80% coverage required
```

### Agent OS Integration

```yaml
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

## Usage

### Basic Usage

Run the complete test cycle:

```bash
python test_master/test_master.py
```

### Command-Line Options

```bash
# Run with custom configuration
python test_master/test_master.py --config path/to/config.yaml

# Run in verbose mode
python test_master/test_master.py --verbose

# Run specific personas only
python test_master/test_master.py --mode personas --personas P-001 P-003 P-005

# Generate reports only (assumes test execution already done)
python test_master/test_master.py --mode reports
```

### Execution Modes

1. **Full Mode** (default): Runs complete test cycle from persona generation to report generation
2. **Personas Mode**: Runs tests for specific personas only
3. **Reports Mode**: Generates reports only (assumes test execution already done)

## Workflow

### Phase 1: Context Initialization

- Loads Agent OS state files
- Reads integration progress and dependencies
- Identifies test scenarios from plans folder
- Establishes test baseline

### Phase 2: Persona Generation

- Generates 25+ diverse personas
- Ensures representation of all dimension combinations
- Includes accessibility users and security-focused personas
- Saves personas to YAML files

### Phase 3: Test Suite Generation

- Creates comprehensive test suites for each persona
- Supports 12 different test types
- Generates test cases with detailed steps and acceptance criteria
- Saves test suites to YAML files

### Phase 4: Test Execution

- Executes tests using Playwright
- Captures screenshots on failures
- Records console logs and network requests
- Tracks execution time per test

### Phase 5: Report Generation

- Generates persona-level reports with detailed feedback
- Creates manager-level consolidated report
- Includes bug reports and recommendations
- Provides release readiness assessment

### Phase 6: Agent OS State Update

- Updates test state with execution results
- Updates project state with quality metrics
- Validates against quality gates
- Generates continuity snapshots

### Phase 7: Final Summary

- Provides overall execution summary
- Displays pass rates and issue counts
- Lists generated reports
- Offers release readiness assessment

## Persona Dimensions

### Behavior Patterns

- **Focused**: Methodical, step-by-step execution
- **Distracted**: Prone to errors, skips steps
- **Multi-tasking**: Rapid navigation, multiple tabs
- **Exploratory**: Clicks everything, tries edge cases

### Technology Experience

- **Novice**: Struggles with UI patterns, needs guidance
- **Intermediate**: Comfortable with standard patterns
- **Expert**: Power user, keyboard shortcuts, advanced features
- **Accessibility User**: Screen reader, keyboard-only, magnification

### Testing Styles

- **Fast**: Quick execution, surface-level validation
- **Detailed**: Thorough examination, documentation-heavy
- **Emotional**: Impression-based feedback, subjective experience
- **Technical**: Bug detection, code-level analysis, API validation
- **Security-Focused**: Vulnerability hunting, input validation

### Interaction Styles

- **Form-Heavy**: Extensive form filling, validation testing
- **Navigation-Heavy**: Deep linking, routing, browser history
- **Visual**: Design critique, responsiveness, aesthetics
- **Textual**: Content validation, localization, accessibility
- **Mobile-First**: Touch interactions, gestures, responsive design

### Roles

- **Casual User**: Occasional use, simple tasks
- **Power User**: Daily use, advanced features
- **Administrator**: Configuration, management, permissions
- **Developer**: API testing, technical validation
- **QA Tester**: Systematic testing, edge cases

### Agent Profiles

- **Skeptical**: Assumes code is broken until proven otherwise
- **Vandal**: Tries to break system with malicious/large inputs
- **Reporter**: Provides clear steps to reproduce every bug
- **Balanced**: Provides balanced feedback across all areas

## Test Types

### Unit Tests

Component-level validation, widget testing, state management verification

### Integration Tests

Component interaction validation, API integration testing, state flow verification

### System Tests

End-to-end user flows, complete feature workflows, multi-step scenarios

### Regression Tests

Validate existing functionality, prevent feature breakage

### UI Tests

Visual regression testing, responsive design validation, component rendering

### Impression Tests

First impression analysis, UX evaluation, user experience scoring

### Usability Tests

Task completion rates, navigation efficiency, error handling validation

### Exploratory Tests

Edge case discovery, unexpected behavior hunting, boundary testing

### Performance Tests

Load testing, response time measurement, memory usage monitoring

### Security Tests

Input validation, XSS prevention, CSRF protection, authentication/authorization

### Accessibility Tests

Screen reader compatibility, keyboard navigation, color contrast validation, ARIA attributes

### Expected Failure Cases

Error handling validation, edge case failure scenarios, network failure simulation

## Reports

### Persona-Level Reports

Each persona generates a comprehensive report including:

- **Persona Profile**: Detailed characteristics and preferences
- **First Impressions**: Initial app perception from persona's perspective
- **Test Execution Summary**: Pass/fail statistics and execution time
- **Detailed Test Results**: Step-by-step test results with screenshots
- **Issues Discovered**: Bug reports with severity and reproduction steps
- **Detailed Feedback**: UX, accessibility, performance, security, navigation, content
- **Suggestions for Improvement**: Prioritized recommendations
- **Screenshots & Evidence**: Visual evidence of test execution
- **Conclusion**: Overall assessment from persona's perspective

### Manager-Level Report

Consolidated report including:

- **Executive Summary**: High-level overview and key findings
- **Test Coverage Analysis**: Breakdown by test type and feature
- **Critical Issues**: Must-fix issues before release
- **Quality Gate Assessment**: Agent OS gate compliance status
- **Persona Insights**: Common themes and persona-specific findings
- **Recommendations**: Immediate, short-term, and long-term actions
- **Release Readiness**: Assessment and recommended actions
- **Appendices**: Detailed test results, bug reports, screenshots

## Agent OS Integration

Test Master integrates seamlessly with Agent OS:

### State Management

- Reads and updates `PROJECT_STATE.md`
- Reads and updates `TEST_STATE.md`
- Reads `BACKLOG_STATE.md` for context

### Quality Gates

- Validates logic correctness (100% pass rate)
- Checks static analysis (0 errors)
- Verifies build integrity (no warnings)
- Ensures code hygiene (no new TODOs)
- Validates coverage (>= 80%)

### Continuity

- Creates snapshots for resume capability
- Tracks execution progress
- Saves state for budget management

## Output Structure

```
test_master/
├── personas/
│   ├── persona_P-001.yaml
│   ├── persona_P-002.yaml
│   └── ...
├── test_suites/
│   ├── suite_SUITE-P-001.yaml
│   ├── suite_SUITE-P-002.yaml
│   └── ...
├── execution_logs/
│   ├── execution_P-001_20240101_120000.json
│   ├── execution_P-002_20240101_120500.json
│   └── ...
├── screenshots/
│   ├── P-001/
│   │   ├── T-P-001-UNIT-001_20240101_120000.png
│   │   └── ...
│   └── ...
├── reports/
│   ├── persona/
│   │   ├── report_P-001.md
│   │   ├── report_P-002.md
│   │   └── ...
│   └── manager/
│       └── comprehensive_test_report_20240101_120000.md
├── artifacts/
│   ├── coverage_report.html
│   ├── performance_metrics.json
│   └── bug_reports.json
└── continuity/
    └── progress_snapshot_20240101_120000.md
```

## Examples

### Example 1: Basic Test Execution

```bash
# Run complete test cycle with default configuration
python test_master/test_master.py
```

### Example 2: Custom Configuration

```bash
# Run with custom configuration file
python test_master/test_master.py --config my_config.yaml
```

### Example 3: Specific Personas

```bash
# Run tests for specific personas only
python test_master/test_master.py --mode personas --personas P-001 P-003 P-005
```

### Example 4: Verbose Logging

```bash
# Run with verbose logging for debugging
python test_master/test_master.py --verbose
```

### Example 5: Reports Only

```bash
# Generate reports only (assumes test execution already done)
python test_master/test_master.py --mode reports
```

## Troubleshooting

### Common Issues

1. **Playwright not installed**

   ```bash
   playwright install
   ```

2. **Python dependencies missing**

   ```bash
   pip install -r requirements.txt
   ```

3. **Configuration file not found**
   - Ensure `config.yaml` exists in the test_master directory
   - Or specify custom config with `--config` option

4. **Agent OS state files not found**
   - Agent OS integration will be disabled automatically
   - Check paths in `agent_os_integration.state_files` section

5. **Tests failing consistently**
   - Check application URL is correct in config
   - Verify application is running and accessible
   - Review execution logs for detailed error messages

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Follow the existing code style (use Black for formatting)
2. Add tests for new features
3. Update documentation as needed
4. Ensure all tests pass before submitting

## License

This project is part of the Agent OS framework and follows its licensing terms.

## Support

For issues, questions, or contributions, please refer to the Agent OS documentation or contact the development team.

## Version History

- **v2.0** - Enhanced with Agent OS integration, comprehensive persona generation, multi-dimensional testing, and robust reporting framework
- **v1.0** - Initial test master prompt with basic persona generation and testing

## Acknowledgments

Test Master is built upon the Agent OS framework and integrates with Playwright for reliable test automation.

---

**Test Master System**: v2.0  
**Agent OS Integration**: Enabled  
**Last Updated**: 2024
