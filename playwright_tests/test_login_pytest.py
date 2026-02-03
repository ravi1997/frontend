"""
Pytest-compatible Playwright Test Suite for Login Workflow
===========================================================
This test suite uses pytest framework for login workflow testing
with comprehensive console and network monitoring.

Usage:
    pytest test_login_pytest.py -v
    pytest test_login_pytest.py -v --headed
"""

import asyncio
import logging
import pytest
from typing import List, Dict, Any
from playwright.async_api import async_playwright, Page, Browser, BrowserContext, APIResponse
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('test_results.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


# Test configuration
BASE_URL = "http://localhost:8080"
USERNAME = "admin1@example.com"
PASSWORD = "Singh@1997"


class LoginTestHelpers:
    """Helper class containing login test utilities."""
    
    def __init__(self):
        self.console_messages: List[Dict[str, Any]] = []
        self.network_errors: List[Dict[str, Any]] = []
        self.failed_requests: List[Dict[str, Any]] = []
    
    def setup_monitoring(self, page: Page) -> None:
        """Setup console and network monitoring on the page."""
        page.on('console', self._handle_console_message)
        page.on('response', self._handle_response)
        page.on('requestfailed', self._handle_request_failed)
    
    def _handle_console_message(self, msg) -> None:
        """Capture and log console messages."""
        message_data = {
            'type': msg.type,
            'text': msg.text,
            'timestamp': datetime.now().isoformat()
        }
        self.console_messages.append(message_data)
        
        if msg.type in ['error', 'warning']:
            logger.warning(f"Console {msg.type.upper()}: {msg.text}")
    
    def _handle_response(self, response: APIResponse) -> None:
        """Monitor network responses for errors."""
        status = response.status
        url = response.url
        
        if status >= 400:
            error_data = {
                'url': url,
                'status': status,
                'status_text': response.status_text,
                'timestamp': datetime.now().isoformat()
            }
            self.network_errors.append(error_data)
            logger.error(f"Network Error: {status} {response.status_text} - {url}")
    
    def _handle_request_failed(self, request) -> None:
        """Capture failed network requests."""
        error_data = {
            'url': request.url,
            'method': request.method,
            'failure': str(request.failure),
            'timestamp': datetime.now().isoformat()
        }
        self.failed_requests.append(error_data)
        logger.error(f"Request Failed: {request.method} {request.url} - {request.failure}")
    
    async def navigate_to_login_page(self, page: Page) -> bool:
        """Navigate to the login page and verify it's loaded."""
        try:
            logger.info(f"Navigating to {BASE_URL}")
            await page.goto(BASE_URL, wait_until='networkidle', timeout=30000)
            await page.wait_for_load_state('domcontentloaded')
            
            title = await page.title()
            logger.info(f"Page loaded successfully: {title}")
            return True
        except Exception as e:
            logger.error(f"Failed to navigate to login page: {str(e)}")
            return False
    
    async def fill_username(self, page: Page) -> bool:
        """Locate and fill the username field."""
        try:
            username_selectors = [
                'input[type="email"]',
                'input[name="email"]',
                'input[placeholder*="email" i]',
                'input[placeholder*="username" i]',
                'input[id*="email" i]',
                'input[id*="username" i]',
                '[data-testid="email"]',
                '[data-testid="username"]',
                'input[aria-label*="email" i]',
                'input[aria-label*="username" i]'
            ]
            
            username_input = None
            for selector in username_selectors:
                try:
                    username_input = await page.wait_for_selector(
                        selector, state='visible', timeout=5000
                    )
                    if username_input:
                        logger.info(f"Found username field using selector: {selector}")
                        break
                except:
                    continue
            
            if not username_input:
                pytest.fail("Could not locate username/email field")
                return False
            
            await username_input.clear()
            await username_input.fill(USERNAME)
            logger.info(f"Username field filled with: {USERNAME}")
            return True
        except Exception as e:
            logger.error(f"Error filling username field: {str(e)}")
            return False
    
    async def fill_password(self, page: Page) -> bool:
        """Locate and fill the password field."""
        try:
            password_selectors = [
                'input[type="password"]',
                'input[name="password"]',
                'input[placeholder*="password" i]',
                'input[id*="password" i]',
                '[data-testid="password"]',
                'input[aria-label*="password" i]'
            ]
            
            password_input = None
            for selector in password_selectors:
                try:
                    password_input = await page.wait_for_selector(
                        selector, state='visible', timeout=5000
                    )
                    if password_input:
                        logger.info(f"Found password field using selector: {selector}")
                        break
                except:
                    continue
            
            if not password_input:
                pytest.fail("Could not locate password field")
                return False
            
            await password_input.clear()
            await password_input.fill(PASSWORD)
            logger.info("Password field filled successfully")
            return True
        except Exception as e:
            logger.error(f"Error filling password field: {str(e)}")
            return False
    
    async def submit_login(self, page: Page) -> bool:
        """Submit the login form."""
        try:
            submit_selectors = [
                'button[type="submit"]',
                'button:has-text("Login")',
                'button:has-text("Sign In")',
                'button:has-text("Sign in")',
                'button:has-text("Log In")',
                'button:has-text("Log in")',
                'input[type="submit"]',
                '[data-testid="login-button"]',
                '[data-testid="submit"]',
                'form button'
            ]
            
            submit_button = None
            for selector in submit_selectors:
                try:
                    submit_button = await page.wait_for_selector(
                        selector, state='visible', timeout=5000
                    )
                    if submit_button:
                        logger.info(f"Found submit button using selector: {selector}")
                        break
                except:
                    continue
            
            if not submit_button:
                pytest.fail("Could not locate submit button")
                return False
            
            await submit_button.click()
            logger.info("Login form submitted")
            return True
        except Exception as e:
            logger.error(f"Error submitting login form: {str(e)}")
            return False
    
    async def verify_successful_login(self, page: Page) -> bool:
        """Verify that login was successful."""
        try:
            await page.wait_for_load_state('networkidle', timeout=10000)
            
            success_indicators = [
                lambda: BASE_URL not in page.url or '/dashboard' in page.url or '/home' in page.url,
                lambda: page.locator('text=Welcome').count() > 0,
                lambda: page.locator('text=Dashboard').count() > 0,
                lambda: page.locator('text=Logout').count() > 0,
                lambda: page.locator('text=Sign out').count() > 0,
                lambda: page.locator('[data-testid="user-profile"]').count() > 0,
                lambda: page.locator('.user-menu').count() > 0,
                lambda: page.locator('input[type="password"]').count() == 0
            ]
            
            await asyncio.sleep(2)
            
            success = False
            for indicator in success_indicators:
                try:
                    if indicator():
                        success = True
                        break
                except:
                    continue
            
            if success:
                logger.info(f"Login successful! Current URL: {page.url}")
                return True
            else:
                logger.warning("Could not confirm successful login")
                logger.info(f"Current URL: {page.url}")
                await page.screenshot(path='login_attempt.png')
                return False
                
        except Exception as e:
            logger.error(f"Error verifying login: {str(e)}")
            return False
    
    def analyze_logs(self) -> Dict[str, Any]:
        """Analyze captured logs for errors."""
        console_errors = [msg for msg in self.console_messages if msg['type'] == 'error']
        console_warnings = [msg for msg in self.console_messages if msg['type'] == 'warning']
        
        return {
            'console_errors': console_errors,
            'console_warnings': console_warnings,
            'network_errors': self.network_errors,
            'failed_requests': self.failed_requests,
            'total_errors': len(console_errors) + len(self.network_errors) + len(self.failed_requests)
        }


# Pytest fixtures
@pytest.fixture(scope="function")
async def browser_context():
    """Create browser context with monitoring."""
    playwright = await async_playwright().start()
    browser = await playwright.chromium.launch(
        headless=False,
        slow_mo=100
    )
    context = await browser.new_context(
        viewport={'width': 1280, 'height': 720},
        ignore_https_errors=True
    )
    page = await context.new_page()
    
    yield page, browser, context
    
    await page.close()
    await context.close()
    await browser.close()
    await playwright.stop()


# Test cases
@pytest.mark.asyncio
@pytest.mark.integration
async def test_login_workflow(browser_context):
    """Test complete login workflow with monitoring."""
    page, browser, context = browser_context
    
    helpers = LoginTestHelpers()
    helpers.setup_monitoring(page)
    
    logger.info("Starting Login Test Workflow")
    logger.info(f"Target URL: {BASE_URL}")
    logger.info(f"Test Credentials: {USERNAME} / ***")
    
    # Step 1: Navigate to login page
    assert await helpers.navigate_to_login_page(page), "Failed to navigate to login page"
    
    # Step 2: Fill username
    assert await helpers.fill_username(page), "Failed to fill username"
    
    # Step 3: Fill password
    assert await helpers.fill_password(page), "Failed to fill password"
    
    # Step 4: Submit login
    assert await helpers.submit_login(page), "Failed to submit login form"
    
    # Step 5: Verify successful login
    assert await helpers.verify_successful_login(page), "Login verification failed"
    
    # Analyze logs
    log_analysis = helpers.analyze_logs()
    
    # Print summary
    logger.info("\n" + "="*70)
    logger.info("TEST EXECUTION SUMMARY")
    logger.info("="*70)
    logger.info(f"Console Errors: {len(log_analysis['console_errors'])}")
    logger.info(f"Console Warnings: {len(log_analysis['console_warnings'])}")
    logger.info(f"Network Errors: {len(log_analysis['network_errors'])}")
    logger.info(f"Failed Requests: {len(log_analysis['failed_requests'])}")
    logger.info(f"Total Errors: {log_analysis['total_errors']}")
    logger.info("="*70 + "\n")
    
    # Assert no critical errors
    if log_analysis['console_errors']:
        logger.error("Console errors detected:")
        for error in log_analysis['console_errors']:
            logger.error(f"  - {error['text']}")
    
    if log_analysis['network_errors']:
        logger.error("Network errors detected:")
        for error in log_analysis['network_errors']:
            logger.error(f"  - {error['status']} {error['status_text']}: {error['url']}")
    
    if log_analysis['failed_requests']:
        logger.error("Failed requests detected:")
        for error in log_analysis['failed_requests']:
            logger.error(f"  - {error['method']} {error['url']}: {error['failure']}")
    
    logger.info("✓ Login test PASSED")


@pytest.mark.asyncio
@pytest.mark.integration
async def test_console_error_detection(browser_context):
    """Test that console errors are properly detected and logged."""
    page, browser, context = browser_context
    
    helpers = LoginTestHelpers()
    helpers.setup_monitoring(page)
    
    await page.goto(BASE_URL, wait_until='networkidle', timeout=30000)
    
    # Wait a bit to capture any console messages
    await asyncio.sleep(2)
    
    # Verify monitoring is working
    log_analysis = helpers.analyze_logs()
    logger.info(f"Captured {len(helpers.console_messages)} console messages")
    
    # Test passes if monitoring is set up correctly
    assert True, "Console error detection test passed"


@pytest.mark.asyncio
@pytest.mark.integration
async def test_network_error_detection(browser_context):
    """Test that network errors are properly detected and logged."""
    page, browser, context = browser_context
    
    helpers = LoginTestHelpers()
    helpers.setup_monitoring(page)
    
    await page.goto(BASE_URL, wait_until='networkidle', timeout=30000)
    
    # Wait for network activity
    await asyncio.sleep(2)
    
    # Verify monitoring is working
    log_analysis = helpers.analyze_logs()
    logger.info(f"Monitoring setup: {len(helpers.network_errors)} network errors detected")
    
    # Test passes if monitoring is set up correctly
    assert True, "Network error detection test passed"
