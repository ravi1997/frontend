"""
Playwright Test Configuration
=============================
Centralized configuration for all Playwright tests.

Modify these settings to customize test behavior.
"""

from typing import Dict, Any

# Base Configuration
BASE_URL = "http://localhost:8080"

# Test Credentials
USERNAME = "admin1@example.com"
PASSWORD = "Singh@1997"

# Browser Configuration
BROWSER_CONFIG = {
    "headless": False,  # Set to True for headless mode
    "slow_mo": 100,  # Slow down actions by this many milliseconds
    "viewport": {"width": 1280, "height": 720},
    "ignore_https_errors": True,
    "user_agent": None,  # Custom user agent string if needed
}

# Timeout Configuration (in milliseconds)
TIMEOUTS = {
    "default": 30000,  # Default timeout for actions
    "navigation": 30000,  # Page navigation timeout
    "element_wait": 5000,  # Element visibility wait timeout
    "load_state": 10000,  # Load state wait timeout
}

# Retry Configuration
RETRY_CONFIG = {
    "max_retries": 3,  # Maximum number of retries for failed actions
    "retry_delay": 1000,  # Delay between retries in milliseconds
}

# Screenshot Configuration
SCREENSHOT_CONFIG = {
    "on_failure": True,  # Take screenshot on test failure
    "on_success": False,  # Take screenshot on test success
    "full_page": False,  # Capture full page screenshot
    "path": "screenshots",  # Directory to save screenshots
}

# Logging Configuration
LOGGING_CONFIG = {
    "level": "INFO",  # Logging level: DEBUG, INFO, WARNING, ERROR, CRITICAL
    "log_file": "test_results.log",  # Log file path
    "console_output": True,  # Output logs to console
    "timestamp_format": "%Y-%m-%d %H:%M:%S",
}

# Monitoring Configuration
MONITORING_CONFIG = {
    "console": True,  # Monitor console messages
    "network": True,  # Monitor network requests/responses
    "log_console_errors": True,  # Log console errors immediately
    "log_console_warnings": True,  # Log console warnings immediately
    "log_network_errors": True,  # Log network errors immediately
}

# Element Selectors (Customize based on your application)
SELECTORS = {
    "username": [
        'input[type="email"]',
        'input[name="email"]',
        'input[placeholder*="email" i]',
        'input[placeholder*="username" i]',
        'input[id*="email" i]',
        'input[id*="username" i]',
        '[data-testid="email"]',
        '[data-testid="username"]',
        'input[aria-label*="email" i]',
        'input[aria-label*="username" i]',
    ],
    "password": [
        'input[type="password"]',
        'input[name="password"]',
        'input[placeholder*="password" i]',
        'input[id*="password" i]',
        '[data-testid="password"]',
        'input[aria-label*="password" i]',
    ],
    "submit": [
        'button[type="submit"]',
        'button:has-text("Login")',
        'button:has-text("Sign In")',
        'button:has-text("Sign in")',
        'button:has-text("Log In")',
        'button:has-text("Log in")',
        'input[type="submit"]',
        '[data-testid="login-button"]',
        '[data-testid="submit"]',
        'form button',
    ],
    "success_indicators": [
        # URL-based indicators
        lambda url: BASE_URL not in url or '/dashboard' in url or '/home' in url,
        # Text-based indicators
        'text=Welcome',
        'text=Dashboard',
        'text=Logout',
        'text=Sign out',
        # Element-based indicators
        '[data-testid="user-profile"]',
        '.user-menu',
        # Negative indicator (password field should not be present)
        'input[type="password"]',
    ],
}

# Test Assertions
ASSERTIONS = {
    "require_no_console_errors": False,  # Fail test if console errors found
    "require_no_network_errors": False,  # Fail test if network errors found
    "require_success_indicator": True,  # Fail if no success indicator found
    "allowed_console_errors": [],  # List of console error messages to ignore
    "allowed_network_errors": [],  # List of network error URLs to ignore
}

# CI/CD Configuration
CI_CONFIG = {
    "enabled": False,  # Enable CI mode (headless, no screenshots)
    "parallel_tests": False,  # Run tests in parallel
    "max_workers": 4,  # Maximum number of parallel workers
    "report_format": "json",  # Report format: json, html, junit
}

# Custom Test Data (for data-driven testing)
TEST_DATA = {
    "valid_credentials": [
        {"username": "admin1@example.com", "password": "Singh@1997"},
    ],
    "invalid_credentials": [
        {"username": "invalid@example.com", "password": "WrongPassword123"},
        {"username": "", "password": "Singh@1997"},
        {"username": "admin1@example.com", "password": ""},
    ],
}


def get_config() -> Dict[str, Any]:
    """
    Get complete configuration as a dictionary.
    
    Returns:
        Dict containing all configuration values.
    """
    return {
        "base_url": BASE_URL,
        "username": USERNAME,
        "password": PASSWORD,
        "browser_config": BROWSER_CONFIG,
        "timeouts": TIMEOUTS,
        "retry_config": RETRY_CONFIG,
        "screenshot_config": SCREENSHOT_CONFIG,
        "logging_config": LOGGING_CONFIG,
        "monitoring_config": MONITORING_CONFIG,
        "selectors": SELECTORS,
        "assertions": ASSERTIONS,
        "ci_config": CI_CONFIG,
        "test_data": TEST_DATA,
    }


def get_browser_launch_options() -> Dict[str, Any]:
    """
    Get browser launch options.
    
    Returns:
        Dict of browser launch options.
    """
    options = {
        "headless": BROWSER_CONFIG["headless"],
        "slow_mo": BROWSER_CONFIG["slow_mo"],
    }
    
    if BROWSER_CONFIG.get("user_agent"):
        options["user_agent"] = BROWSER_CONFIG["user_agent"]
    
    return options


def get_context_options() -> Dict[str, Any]:
    """
    Get browser context options.
    
    Returns:
        Dict of context options.
    """
    return {
        "viewport": BROWSER_CONFIG["viewport"],
        "ignore_https_errors": BROWSER_CONFIG["ignore_https_errors"],
    }
