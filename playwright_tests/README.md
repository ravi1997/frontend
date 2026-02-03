# Playwright Login Test Suite

Production-ready Playwright test suite for automated login workflow testing with comprehensive console and network monitoring.

## Features

- ✅ **Full Login Workflow**: Complete end-to-end login testing
- ✅ **Multiple Selector Strategies**: Robust element detection with fallback selectors
- ✅ **Console Monitoring**: Real-time capture and analysis of browser console messages
- ✅ **Network Monitoring**: Tracks all HTTP requests and responses, identifies failures
- ✅ **Explicit Waits**: Uses Playwright's wait mechanisms for reliable element detection
- ✅ **Comprehensive Logging**: Detailed test execution logs with timestamps
- ✅ **Error Reporting**: Clear identification of client-side errors and network failures
- ✅ **Screenshot Capture**: Automatic screenshots on test failures for debugging
- ✅ **Production-Ready**: Clean, maintainable code with proper error handling

## Prerequisites

- Python 3.8 or higher
- Access to the application at `http://localhost:8080`

## Installation

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Install Playwright Browsers

```bash
playwright install chromium
```

## Test Configuration

The test is pre-configured with the following settings:

- **Base URL**: `http://localhost:8080`
- **Username**: `admin1@example.com`
- **Password**: `Singh@1997`

To modify these settings, edit the `LoginTestSuite.__init__` method in [`login_test.py`](login_test.py:19).

## Running the Tests

### Run the Login Test

```bash
python login_test.py
```

### Run with pytest (Alternative)

```bash
pytest login_test.py -v
```

### Run with Headless Mode

To run tests in headless mode (no visible browser), modify the browser launch in [`login_test.py`](login_test.py:38):

```python
browser = await playwright.chromium.launch(
    headless=True,  # Change to True for headless mode
    slow_mo=100
)
```

## Test Output

### Console Output

The test provides real-time console output showing:

- Navigation steps
- Element detection and interaction
- Form filling and submission
- Login verification
- Console errors and warnings
- Network errors and failures

### Log File

A detailed log file is created at `test_results.log` containing:

- Timestamped test execution steps
- All console messages captured
- Network request/response details
- Error reports with full stack traces

### Screenshots

On test failure, a screenshot is saved as `login_attempt.png` in the test directory for debugging.

## Test Workflow

The test executes the following steps:

1. **Browser Setup**: Initializes Chromium browser with monitoring
2. **Navigation**: Navigates to the login page and waits for load
3. **Username Input**: Locates and fills the username/email field
4. **Password Input**: Locates and fills the password field
5. **Form Submission**: Clicks the login/submit button
6. **Verification**: Confirms successful login through multiple indicators
7. **Analysis**: Analyzes console and network logs for errors
8. **Reporting**: Generates comprehensive test summary

## Element Detection Strategy

The test uses multiple selector strategies to ensure reliable element detection:

### Username Field Selectors

- `input[type="email"]`
- `input[name="email"]`
- `input[placeholder*="email" i]`
- `input[id*="email" i]`
- `[data-testid="email"]`
- `input[aria-label*="email" i]`

### Password Field Selectors

- `input[type="password"]`
- `input[name="password"]`
- `input[placeholder*="password" i]`
- `input[id*="password" i]`
- `[data-testid="password"]`

### Submit Button Selectors

- `button[type="submit"]`
- `button:has-text("Login")`
- `button:has-text("Sign In")`
- `input[type="submit"]`
- `[data-testid="login-button"]`

## Monitoring Capabilities

### Console Monitoring

The test captures all browser console messages including:

- Errors
- Warnings
- Info messages
- Debug logs

All console errors and warnings are logged immediately for quick identification.

### Network Monitoring

The test monitors all network activity:

- **Failed Responses**: HTTP 4xx and 5xx responses
- **Failed Requests**: Requests that didn't complete
- **Response Times**: Captured for performance analysis

## Test Results

The test provides a comprehensive summary including:

- Console logs analysis (errors, warnings, info)
- Network logs analysis (failed requests, error responses)
- Overall test pass/fail status
- Timestamps for all events

Example output:

```
======================================================================
TEST EXECUTION SUMMARY
======================================================================

Console Logs:
  Total Messages: 15
  Errors: 0
  Warnings: 1

Network Logs:
  Total Errors: 0
  Failed Responses: 0
  Failed Requests: 0

======================================================================

Final Test Result: PASSED
```

## Troubleshooting

### Application Not Running

Ensure your application is running at `http://localhost:8080` before running the test.

```bash
# Check if application is running
curl http://localhost:8080
```

### Element Not Found

If the test cannot find elements, check:

1. The application has loaded completely
2. The selectors match your application's HTML structure
3. Elements are not hidden or in iframes

### Timeout Errors

Increase timeout values in the test if your application is slow:

- `wait_for_selector` timeout (default: 5000ms)
- `goto` timeout (default: 30000ms)
- `wait_for_load_state` timeout (default: 10000ms)

### Playwright Installation Issues

If Playwright browsers are not installed:

```bash
# Reinstall Playwright
pip uninstall playwright
pip install playwright

# Install browsers
playwright install chromium
```

## Extending the Test Suite

To add more tests:

1. Create new test methods in the `LoginTestSuite` class
2. Use the existing monitoring setup
3. Follow the same pattern for element detection and interaction

Example:

```python
async def test_logout(self, page: Page) -> bool:
    """Test logout functionality."""
    try:
        logout_button = await page.wait_for_selector('button:has-text("Logout")')
        await logout_button.click()
        await page.wait_for_url('**/login')
        return True
    except Exception as e:
        logger.error(f"Logout test failed: {str(e)}")
        return False
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Playwright Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - name: Install dependencies
        run: |
          pip install -r playwright_tests/requirements.txt
          playwright install chromium
      - name: Start application
        run: # Command to start your app
      - name: Run tests
        run: python playwright_tests/login_test.py
```

## License

This test suite is provided as-is for testing purposes.

## Support

For issues or questions:

1. Check the log file `test_results.log` for detailed error information
2. Review screenshots captured on test failures
3. Verify your application is running and accessible
4. Check Playwright documentation: <https://playwright.dev/python/>
