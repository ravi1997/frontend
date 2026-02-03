"""
Playwright Test Suite for Login Workflow
=========================================
This test suite performs end-to-end testing of the login functionality
including console and network monitoring for error detection.

Test Environment:
- Base URL: http://localhost:8080
- Test Credentials: admin1@example.com / Singh@1997
"""

import asyncio
import logging
from typing import List, Dict, Any
from playwright.async_api import async_playwright, Page, Browser, BrowserContext, APIResponse
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('playwright_tests/test_results.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class LoginTestSuite:
    """Comprehensive test suite for login workflow with monitoring capabilities."""
    
    def __init__(self, base_url: str = "http://localhost:8080"):
        self.base_url = base_url
        self.username = "admin1@example.com"
        self.password = "Singh@1997"
        self.console_messages: List[Dict[str, Any]] = []
        self.network_errors: List[Dict[str, Any]] = []
        self.failed_requests: List[Dict[str, Any]] = []
        
    async def setup_browser(self) -> tuple[Browser, BrowserContext, Page]:
        """Initialize browser with monitoring capabilities."""
        playwright = await async_playwright().start()
        
        # Launch browser with console monitoring
        browser = await playwright.chromium.launch(
            headless=False,
            slow_mo=100  # Slow down actions for better visibility
        )
        
        # Create context with network monitoring
        context = await browser.new_context(
            viewport={'width': 1280, 'height': 720},
            ignore_https_errors=True
        )
        
        # Create page
        page = await context.new_page()
        
        # Setup console monitoring
        page.on('console', self._handle_console_message)
        page.on('response', self._handle_response)
        page.on('requestfailed', self._handle_request_failed)
        
        return browser, context, page
    
    def _handle_console_message(self, msg) -> None:
        """Capture and log console messages."""
        message_data = {
            'type': msg.type,
            'text': msg.text,
            'timestamp': datetime.now().isoformat()
        }
        self.console_messages.append(message_data)
        
        # Log errors and warnings immediately
        if msg.type in ['error', 'warning']:
            logger.warning(f"Console {msg.type.upper()}: {msg.text}")
        else:
            logger.debug(f"Console {msg.type}: {msg.text}")
    
    def _handle_response(self, response: APIResponse) -> None:
        """Monitor network responses for errors."""
        status = response.status
        url = response.url
        
        # Log failed responses (4xx and 5xx)
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
            logger.info(f"Navigating to {self.base_url}")
            await page.goto(self.base_url, wait_until='networkidle', timeout=30000)
            
            # Wait for page to be fully loaded
            await page.wait_for_load_state('domcontentloaded')
            
            # Verify page loaded successfully
            title = await page.title()
            logger.info(f"Page loaded successfully: {title}")
            
            return True
        except Exception as e:
            logger.error(f"Failed to navigate to login page: {str(e)}")
            return False
    
    async def find_and_fill_username(self, page: Page) -> bool:
        """Locate and fill the username field."""
        try:
            # Try multiple selector strategies for username field
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
                        selector, 
                        state='visible', 
                        timeout=5000
                    )
                    if username_input:
                        logger.info(f"Found username field using selector: {selector}")
                        break
                except:
                    continue
            
            if not username_input:
                logger.error("Could not locate username/email field")
                return False
            
            # Clear and fill username
            await username_input.clear()
            await username_input.fill(self.username)
            logger.info(f"Username field filled with: {self.username}")
            
            return True
        except Exception as e:
            logger.error(f"Error filling username field: {str(e)}")
            return False
    
    async def find_and_fill_password(self, page: Page) -> bool:
        """Locate and fill the password field."""
        try:
            # Try multiple selector strategies for password field
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
                        selector, 
                        state='visible', 
                        timeout=5000
                    )
                    if password_input:
                        logger.info(f"Found password field using selector: {selector}")
                        break
                except:
                    continue
            
            if not password_input:
                logger.error("Could not locate password field")
                return False
            
            # Clear and fill password
            await password_input.clear()
            await password_input.fill(self.password)
            logger.info("Password field filled successfully")
            
            return True
        except Exception as e:
            logger.error(f"Error filling password field: {str(e)}")
            return False
    
    async def submit_login(self, page: Page) -> bool:
        """Submit the login form."""
        try:
            # Try multiple selector strategies for submit button
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
                        selector, 
                        state='visible', 
                        timeout=5000
                    )
                    if submit_button:
                        logger.info(f"Found submit button using selector: {selector}")
                        break
                except:
                    continue
            
            if not submit_button:
                logger.error("Could not locate submit button")
                return False
            
            # Click submit button
            await submit_button.click()
            logger.info("Login form submitted")
            
            return True
        except Exception as e:
            logger.error(f"Error submitting login form: {str(e)}")
            return False
    
    async def verify_successful_login(self, page: Page) -> bool:
        """Verify that login was successful."""
        try:
            # Wait for navigation after login
            await page.wait_for_load_state('networkidle', timeout=10000)
            
            # Check for success indicators
            success_indicators = [
                # Check URL changes
                lambda: self.base_url not in page.url or '/dashboard' in page.url or '/home' in page.url,
                # Check for welcome message
                lambda: page.locator('text=Welcome').count() > 0,
                lambda: page.locator('text=Dashboard').count() > 0,
                lambda: page.locator('text=Logout').count() > 0,
                lambda: page.locator('text=Sign out').count() > 0,
                # Check for user profile elements
                lambda: page.locator('[data-testid="user-profile"]').count() > 0,
                lambda: page.locator('.user-menu').count() > 0,
                # Check for absence of login form
                lambda: page.locator('input[type="password"]').count() == 0
            ]
            
            # Wait a bit for page to settle
            await asyncio.sleep(2)
            
            # Check success indicators
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
                # Take screenshot for debugging
                await page.screenshot(path='playwright_tests/login_attempt.png')
                return False
                
        except Exception as e:
            logger.error(f"Error verifying login: {str(e)}")
            return False
    
    def analyze_console_logs(self) -> Dict[str, Any]:
        """Analyze captured console logs for errors."""
        analysis = {
            'total_messages': len(self.console_messages),
            'errors': [],
            'warnings': [],
            'info': [],
            'other': []
        }
        
        for msg in self.console_messages:
            if msg['type'] == 'error':
                analysis['errors'].append(msg)
            elif msg['type'] == 'warning':
                analysis['warnings'].append(msg)
            elif msg['type'] == 'info':
                analysis['info'].append(msg)
            else:
                analysis['other'].append(msg)
        
        return analysis
    
    def analyze_network_logs(self) -> Dict[str, Any]:
        """Analyze captured network logs for errors."""
        return {
            'network_errors': self.network_errors,
            'failed_requests': self.failed_requests,
            'total_errors': len(self.network_errors) + len(self.failed_requests)
        }
    
    def print_test_summary(self) -> None:
        """Print comprehensive test summary."""
        console_analysis = self.analyze_console_logs()
        network_analysis = self.analyze_network_logs()
        
        logger.info("\n" + "="*70)
        logger.info("TEST EXECUTION SUMMARY")
        logger.info("="*70)
        
        # Console logs summary
        logger.info(f"\nConsole Logs:")
        logger.info(f"  Total Messages: {console_analysis['total_messages']}")
        logger.info(f"  Errors: {len(console_analysis['errors'])}")
        logger.info(f"  Warnings: {len(console_analysis['warnings'])}")
        
        if console_analysis['errors']:
            logger.error("\n  Console Errors Found:")
            for error in console_analysis['errors']:
                logger.error(f"    - {error['text']}")
        
        if console_analysis['warnings']:
            logger.warning("\n  Console Warnings Found:")
            for warning in console_analysis['warnings']:
                logger.warning(f"    - {warning['text']}")
        
        # Network logs summary
        logger.info(f"\nNetwork Logs:")
        logger.info(f"  Total Errors: {network_analysis['total_errors']}")
        logger.info(f"  Failed Responses: {len(network_analysis['network_errors'])}")
        logger.info(f"  Failed Requests: {len(network_analysis['failed_requests'])}")
        
        if network_analysis['network_errors']:
            logger.error("\n  Network Response Errors:")
            for error in network_analysis['network_errors']:
                logger.error(f"    - {error['status']} {error['status_text']}: {error['url']}")
        
        if network_analysis['failed_requests']:
            logger.error("\n  Failed Requests:")
            for error in network_analysis['failed_requests']:
                logger.error(f"    - {error['method']} {error['url']}: {error['failure']}")
        
        logger.info("\n" + "="*70)
    
    async def run_login_test(self) -> bool:
        """Execute the complete login test workflow."""
        logger.info("Starting Login Test Workflow")
        logger.info(f"Target URL: {self.base_url}")
        logger.info(f"Test Credentials: {self.username} / ***")
        
        browser = None
        context = None
        page = None
        test_passed = False
        
        try:
            # Setup browser
            browser, context, page = await self.setup_browser()
            
            # Step 1: Navigate to login page
            if not await self.navigate_to_login_page(page):
                logger.error("Test failed: Could not navigate to login page")
                return False
            
            # Step 2: Fill username
            if not await self.find_and_fill_username(page):
                logger.error("Test failed: Could not fill username")
                return False
            
            # Step 3: Fill password
            if not await self.find_and_fill_password(page):
                logger.error("Test failed: Could not fill password")
                return False
            
            # Step 4: Submit login
            if not await self.submit_login(page):
                logger.error("Test failed: Could not submit login form")
                return False
            
            # Step 5: Verify successful login
            if await self.verify_successful_login(page):
                test_passed = True
                logger.info("✓ Login test PASSED")
            else:
                logger.error("✗ Login test FAILED: Could not verify successful login")
            
        except Exception as e:
            logger.error(f"Test execution failed with exception: {str(e)}", exc_info=True)
            test_passed = False
        
        finally:
            # Print test summary
            self.print_test_summary()
            
            # Cleanup
            if page:
                await page.close()
            if context:
                await context.close()
            if browser:
                await browser.close()
        
        return test_passed


async def main():
    """Main entry point for the test suite."""
    logger.info("Initializing Playwright Login Test Suite")
    logger.info(f"Test started at: {datetime.now().isoformat()}")
    
    # Create test suite instance
    test_suite = LoginTestSuite(base_url="http://localhost:8080")
    
    # Run the test
    result = await test_suite.run_login_test()
    
    # Final result
    logger.info(f"\nFinal Test Result: {'PASSED' if result else 'FAILED'}")
    logger.info(f"Test completed at: {datetime.now().isoformat()}")
    
    return 0 if result else 1


if __name__ == "__main__":
    exit_code = asyncio.run(main())
    exit(exit_code)
