# Test Master Quick Start Guide

This guide will help you get started with Test Master in 5 minutes.

## Prerequisites

- Python 3.8 or higher
- A web application to test (running and accessible)
- (Optional) Agent OS framework for state integration

## Installation

### Step 1: Install Dependencies

```bash
cd test_master
pip install -r requirements.txt
```

### Step 2: Install Playwright Browsers (for test execution)

```bash
playwright install
```

## Configuration

### Step 3: Configure Your Application

Edit `config.yaml` and set your application URL:

```yaml
execution_config:
  app_url: "http://localhost:3000"  # Change this to your app URL
```

### Step 4: Adjust Test Settings (Optional)

Customize persona generation and test types:

```yaml
persona_generation:
  total_personas: 25
  selected_personas: 5  # Number of personas to test
  
test_types:
  - unit_tests
  - integration_tests
  - system_tests
  # Add or remove test types as needed
```

## Running Tests

### Step 5: Run Complete Test Cycle

```bash
python test_master/test_master.py
```

This will:

1. Generate 25 diverse personas
2. Select 5 personas for testing
3. Create comprehensive test suites
4. Execute tests using Playwright
5. Generate persona and manager reports
6. Update Agent OS state (if enabled)

## Viewing Results

### Step 6: Check Reports

After execution completes, reports are generated in:

- **Persona Reports**: `test_master/reports/persona/`
  - Individual reports for each persona with detailed feedback
  
- **Manager Report**: `test_master/reports/manager/`
  - Consolidated report with executive summary and recommendations

### Step 7: Review Execution Logs

Execution logs are saved in `test_master/execution_logs/` with detailed information about each test run.

## Common Use Cases

### Run with Verbose Logging

```bash
python test_master/test_master.py --verbose
```

### Run Specific Personas Only

```bash
python test_master/test_master.py --mode personas --personas P-001 P-003 P-005
```

### Generate Reports Only

```bash
python test_master/test_master.py --mode reports
```

### Use Custom Configuration

```bash
python test_master/test_master.py --config path/to/my_config.yaml
```

## Understanding the Output

### Console Output

```
============================================================
Starting Full Test Master Cycle
============================================================

[Phase 1/7] Context Initialization
Loading Agent OS state...
Context initialization completed

[Phase 2/7] Persona Generation
Generating 25 diverse personas...
Generated 25 personas
Selecting 5 diverse personas...
Selected 5 personas:
  - P-001: Alex Thompson (Intermediate, Focused, Technical)
  - P-002: Maria Garcia (Novice, Distracted, Emotional)
  ...

[Phase 3/7] Test Suite Generation
Generating test suites for selected personas...
Generated 5 test suites

[Phase 4/7] Test Execution
Executing test suites...
Test execution completed

[Phase 5/7] Report Generation
Generating reports...
Report generation completed

[Phase 6/7] Agent OS State Update
Updating Agent OS state...
Agent OS state updated successfully

[Phase 7/7] Final Summary
Generating final summary...

============================================================
FINAL SUMMARY
============================================================
Execution Date: 2024-01-01 12:00:00 UTC
Duration: 345.67s
Total Personas: 5
Total Tests: 125
Passed: 110
Failed: 15
Pass Rate: 88.00%

Reports:
  Manager Report: test_master/reports/manager/comprehensive_test_report_20240101_120000.md
  Persona Report 1: test_master/reports/persona/report_P-001.md
  Persona Report 2: test_master/reports/persona/report_P-002.md
  ...
============================================================
```

### Report Structure

**Persona Report** (`report_P-001.md`):

```markdown
# Test Report: Alex Thompson (P-001)

## Persona Profile
| Attribute | Value |
|-----------|-------|
| **Name** | Alex Thompson |
| **Technology Experience** | Intermediate |
| **Testing Style** | Technical |
...

## First Impressions
As an intermediate user, I found the application generally intuitive...

## Test Execution Summary
| Metric | Value |
|--------|-------|
| **Total Tests Executed** | 25 |
| **Passed** | 22 |
| **Failed** | 3 |
...

## Issues Discovered
### Critical Issues (Must Fix)
1. XSS Prevention - Form Input
   - Severity: Critical
   - Description: XSS payload is not sanitized
...

## Suggestions for Improvement
### Critical Issues (Must Fix)
1. Implement input sanitization - Prevents XSS attacks
...
```

**Manager Report** (`comprehensive_test_report_20240101_120000.md`):

```markdown
# Comprehensive Test Report: Flutter Form Management System

## Executive Summary
The comprehensive test execution was completed across 5 diverse personas...

## Test Coverage Analysis
| Test Type | Total | Passed | Failed | Pass Rate |
|-----------|-------|--------|--------|-----------|
| Unit Tests | 15 | 14 | 1 | 93.3% |
| Integration Tests | 10 | 9 | 1 | 90.0% |
...

## Critical Issues (Must Fix Before Release)
1. XSS Prevention - Form Input
   - Severity: Critical
   - Impact: Security vulnerability
...

## Release Readiness
- **Ready for Release**: NO
- **Blocking Issues**: 3
- **Recommended Actions**: Address all critical issues
```

## Troubleshooting

### Issue: "ModuleNotFoundError: No module named 'yaml'"

**Solution**: Install dependencies

```bash
pip install -r requirements.txt
```

### Issue: "Playwright not installed"

**Solution**: Install Playwright browsers

```bash
playwright install
```

### Issue: Tests failing with "Connection refused"

**Solution**:

1. Ensure your application is running
2. Check the `app_url` in `config.yaml`
3. Verify the URL is accessible from your browser

### Issue: "Configuration file not found"

**Solution**:

1. Ensure `config.yaml` exists in `test_master/` directory
2. Or specify custom config: `python test_master/test_master.py --config path/to/config.yaml`

### Issue: Agent OS state files not found

**Solution**:

- Agent OS integration will be disabled automatically
- Test Master will continue to work without Agent OS integration
- To enable integration, ensure Agent OS state files exist at specified paths

## Next Steps

1. **Review Reports**: Examine persona and manager reports to understand test results
2. **Address Issues**: Fix critical and high-priority issues identified
3. **Re-run Tests**: Execute tests again after fixes to verify improvements
4. **Monitor Progress**: Track quality improvements over multiple test runs

## Advanced Configuration

### Custom Test Scenarios

Add custom test scenarios to `plans/` directory in YAML format:

```yaml
test_id: T-CUSTOM-001
test_type: custom_tests
title: My Custom Test
priority: High
description: Test my custom feature
preconditions:
  - User is logged in
test_steps:
  - step: 1
    action: Navigate to /my-feature
    expected: Page loads successfully
  - step: 2
    action: Click on button
    expected: Action completes
expected_result: Feature works as expected
```

### Custom Personas

Create custom personas in `test_master/personas/` directory:

```yaml
persona_id: P-CUSTOM-001
name: Custom User
age_group: "25-34"
technology_experience: "Intermediate"
behavior: "Focused"
testing_style: "Technical"
interaction_style: "Form-Heavy"
role: "Power User"
agent_profile: "Skeptical"
special_focus: "Performance"
language: "English"
accessibility_needs: []
viewport:
  width: 1920
  height: 1080
browser_preferences:
  - "chromium"
typing_speed: "Fast"
error_prone: false
multi_tasking: false
```

## Getting Help

- **Documentation**: See `README.md` for comprehensive documentation
- **Examples**: Check `test_master/examples/` for example configurations and scripts
- **Issues**: Report issues through your project's issue tracking system

## Tips for Success

1. **Start Small**: Begin with fewer personas and test types, then scale up
2. **Review Logs**: Check execution logs for detailed information about test runs
3. **Iterate**: Run tests, fix issues, and re-run to track improvements
4. **Customize**: Adjust configuration to match your specific needs
5. **Integrate**: Enable Agent OS integration for state management and quality gates

---

**Happy Testing!** 🚀

For more information, see the full [README.md](README.md) documentation.
