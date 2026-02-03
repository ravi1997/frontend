"""
Comprehensive Login Functionality Test Suite
=============================================
Tests: Successful login, invalid credentials, input validation,
UI responsiveness, session management, and security concerns.

Target: http://localhost:8080
Credentials: admin1@example.com / Singh@1997
"""

import asyncio
import logging
import time
from datetime import datetime
from playwright.async_api import async_playwright, Page, Browser, BrowserContext

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class LoginTestSuite:
    """Comprehensive login functionality testing."""
    
    def __init__(self):
        self.base_url = "http://localhost:8080"
        self.valid_username = "admin1@example.com"
        self.valid_password = "Singh@1997"
        self.test_results = []
        self.console_errors = []
        self.network_errors = []
        
    async def run_all_tests(self) -> dict:
        """Execute all login tests."""
        logger.info("=" * 80)
        logger.info("COMPREHENSIVE LOGIN FUNCTIONALITY TESTING")
        logger.info("=" * 80)
        logger.info(f"Target URL: {self.base_url}")
        logger.info(f"Test started: {datetime.now().isoformat()}")
        logger.info("")
        
        browser = None
        try:
            playwright = await async_playwright().start()
            browser = await playwright.chromium.launch(headless=True)
            
            # Test 1: Page Load and UI Analysis
            await self.test_page_load(browser)
            
            # Test 2: Successful Login
            await self.test_successful_login(browser)
            
            # Test 3: Invalid Credentials
            await self.test_invalid_credentials(browser)
            
            # Test 4: Empty Fields Validation
            await self.test_empty_fields(browser)
            
            # Test 5: SQL Injection Prevention
            await self.test_sql_injection(browser)
            
            # Test 6: XSS Prevention
            await self.test_xss_prevention(browser)
            
            # Test 7: UI Responsiveness
            await self.test_ui_responsiveness(browser)
            
            # Test 8: Session Management
            await self.test_session_management(browser)
            
            # Test 9: Network Security
            await self.test_network_security(browser)
            
            # Test 10: Password Field Security
            await self.test_password_field_security(browser)
            
            await browser.close()
            await playwright.stop()
            
        except Exception as e:
            logger.error(f"Test suite error: {e}")
            if browser:
                await browser.close()
        
        return self.generate_report()
    
    async def test_page_load(self, browser: Browser):
        """Test 1: Page load and UI element analysis."""
        logger.info("\n" + "-" * 60)
        logger.info("TEST 1: Page Load and UI Analysis")
        logger.info("-" * 60)
        
        context = await browser.new_context()
        page = await context.new_page()
        
        # Capture console errors
        page.on("console", lambda msg: self._capture_console(msg, "page_load"))
        page.on("response", lambda res: self._capture_network(res, "page_load"))
        
        test_result = {
            "test_name": "Page Load and UI Analysis",
            "passed": False,
            "details": {},
            "errors": []
        }
        
        try:
            start_time = time.time()
            response = await page.goto(self.base_url, wait_until="networkidle", timeout=30000)
            load_time = time.time() - start_time
            
            # Check response
            if response:
                test_result["details"]["status_code"] = response.status
                test_result["details"]["load_time_seconds"] = round(load_time, 2)
                logger.info(f"  Page loaded with status: {response.status}")
                logger.info(f"  Load time: {load_time:.2f} seconds")
            
            # Analyze page title
            title = await page.title()
            test_result["details"]["title"] = title
            logger.info(f"  Page title: {title}")
            
            # Check for login form elements
            form_elements = await self._analyze_login_form(page)
            test_result["details"]["form_elements"] = form_elements
            
            # Check for security headers
            security_headers = await self._check_security_headers(response)
            test_result["details"]["security_headers"] = security_headers
            
            test_result["passed"] = response and response.status == 200
            test_result["details"]["console_errors"] = self.console_errors.copy()
            test_result["details"]["network_errors"] = self.network_errors.copy()
            
        except Exception as e:
            test_result["errors"].append(str(e))
            logger.error(f"  Error: {e}")
        
        self.test_results.append(test_result)
        logger.info(f"  Result: {'PASSED' if test_result['passed'] else 'FAILED'}")
        
        await context.close()
        self.console_errors = []
        self.network_errors = []
    
    async def test_successful_login(self, browser: Browser):
        """Test 2: Successful login with valid credentials."""
        logger.info("\n" + "-" * 60)
        logger.info("TEST 2: Successful Login")
        logger.info("-" * 60)
        
        context = await browser.new_context()
        page = await context.new_page()
        
        page.on("console", lambda msg: self._capture_console(msg, "successful_login"))
        page.on("response", lambda res: self._capture_network(res, "successful_login"))
        
        test_result = {
            "test_name": "Successful Login",
            "passed": False,
            "details": {},
            "errors": []
        }
        
        try:
            await page.goto(self.base_url, wait_until="networkidle")
            
            # Fill login form
            await self._fill_login_form(page, self.valid_username, self.valid_password)
            
            # Submit and wait for response
            start_time = time.time()
            await page.click('button[type="submit"]')
            
            # Wait for navigation or response
            try:
                await page.wait_for_load_state("networkidle", timeout=10000)
                login_time = time.time() - start_time
                test_result["details"]["login_time_seconds"] = round(login_time, 2)
                logger.info(f"  Login response time: {login_time:.2f} seconds")
            except:
                await asyncio.sleep(2)
            
            # Check current URL
            current_url = page.url
            test_result["details"]["post_login_url"] = current_url
            logger.info(f"  Post-login URL: {current_url}")
            
            # Check for success indicators
            success_indicators = await self._check_success_indicators(page)
            test_result["details"]["success_indicators"] = success_indicators
            logger.info(f"  Success indicators found: {success_indicators}")
            
            # Check for authentication tokens/cookies
            cookies = await context.cookies()
            auth_cookies = [c for c in cookies if any(x in c['name'].lower() for x in ['token', 'auth', 'session', 'jwt', 'sid'])]
            test_result["details"]["auth_cookies"] = len(auth_cookies) > 0
            test_result["details"]["cookie_count"] = len(cookies)
            logger.info(f"  Auth cookies present: {len(auth_cookies) > 0}")
            logger.info(f"  Total cookies: {len(cookies)}")
            
            # Check if redirected to dashboard/home
            redirected = current_url != self.base_url and 'login' not in current_url.lower()
            test_result["details"]["redirected_after_login"] = redirected
            logger.info(f"  Redirected after login: {redirected}")
            
            test_result["passed"] = success_indicators or redirected
            
        except Exception as e:
            test_result["errors"].append(str(e))
            logger.error(f"  Error: {e}")
            # Take screenshot on failure
            await page.screenshot(path="login_test_failed.png")
            logger.info("  Screenshot saved: login_test_failed.png")
        
        self.test_results.append(test_result)
        logger.info(f"  Result: {'PASSED' if test_result['passed'] else 'FAILED'}")
        
        await context.close()
        self.console_errors = []
        self.network_errors = []
    
    async def test_invalid_credentials(self, browser: Browser):
        """Test 3: Login with invalid credentials."""
        logger.info("\n" + "-" * 60)
        logger.info("TEST 3: Invalid Credentials Handling")
        logger.info("-" * 60)
        
        test_cases = [
            {"username": "wrong@example.com", "password": self.valid_password, "description": "Wrong username"},
            {"username": self.valid_username, "password": "WrongPassword123", "description": "Wrong password"},
            {"username": "wrong@example.com", "password": "WrongPassword123", "description": "Both wrong"},
            {"username": "admin1@example.com", "password": "singh@1997", "description": "Case-sensitive password"},
        ]
        
        test_result = {
            "test_name": "Invalid Credentials Handling",
            "passed": False,
            "details": {"test_cases": []},
            "errors": []
        }
        
        all_cases_handled = True
        
        for test_case in test_cases:
            context = await browser.new_context()
            page = await context.new_page()
            
            case_result = {
                "description": test_case["description"],
                "error_shown": False,
                "error_message": None,
                "proper_rejection": False,
                "details": {}
            }
            
            try:
                await page.goto(self.base_url, wait_until="networkidle")
                await self._fill_login_form(page, test_case["username"], test_case["password"])
                
                # Click submit
                await page.click('button[type="submit"]')
                await asyncio.sleep(2)
                
                # Check for error message
                error_selectors = [
                    '[class*="error"]',
                    '[class*="alert"]',
                    '[class*="danger"]',
                    '[class*="invalid"]',
                    'text=Invalid',
                    'text=incorrect',
                    'text=failed',
                    'text=Error',
                    'form .error',
                    '.message.error'
                ]
                
                error_found = False
                for selector in error_selectors:
                    elements = await page.locator(selector).all()
                    if elements:
                        error_found = True
                        error_text = await elements[0].text_content()
                        case_result["error_message"] = error_text.strip()[:100]
                        logger.info(f"  {test_case['description']}: Error shown - '{case_result['error_message']}'")
                        break
                
                case_result["error_shown"] = error_found
                
                # Check if still on login page (proper rejection)
                still_on_login = 'login' in page.url.lower() or page.url == self.base_url
                case_result["proper_rejection"] = still_on_login and error_found
                
                if not error_found:
                    all_cases_handled = False
                    logger.info(f"  {test_case['description']}: No error message shown")
                
                # Check for console errors
                case_result["console_errors"] = len(self.console_errors) > 0
                
            except Exception as e:
                case_result["error"] = str(e)
                all_cases_handled = False
            
            test_result["details"]["test_cases"].append(case_result)
            await context.close()
        
        test_result["details"]["all_errors_handled"] = all_cases_handled
        test_result["passed"] = all_cases_handled
        self.test_results.append(test_result)
        
        logger.info(f"  All invalid credentials properly rejected: {all_cases_handled}")
        logger.info(f"  Result: {'PASSED' if test_result['passed'] else 'FAILED'}")
        
        self.console_errors = []
        self.network_errors = []
    
    async def test_empty_fields(self, browser: Browser):
        """Test 4: Empty field validation."""
        logger.info("\n" + "-" * 60)
        logger.info("TEST 4: Empty Field Validation")
        logger.info("-" * 60)
        
        test_cases = [
            {"username": "", "password": self.valid_password, "description": "Empty username"},
            {"username": self.valid_username, "password": "", "description": "Empty password"},
            {"username": "", "password": "", "description": "Both empty"},
        ]
        
        test_result = {
            "test_name": "Empty Field Validation",
            "passed": False,
            "details": {"test_cases": []},
            "errors": []
        }
        
        all_validated = True
        
        for test_case in test_cases:
            context = await browser.new_context()
            page = await context.new_page()
            
            case_result = {
                "description": test_case["description"],
                "validation_triggered": False,
                "form_blocked": False,
                "details": {}
            }
            
            try:
                await page.goto(self.base_url, wait_until="networkidle")
                await self._fill_login_form(page, test_case["username"], test_case["password"])
                
                # Check for HTML5 validation
                username_input = page.locator('input[type="email"], input[name="email"], input[name="username"]').first
                password_input = page.locator('input[type="password"]').first
                
                # Check if required attribute is present
                username_required = await username_input.get_attribute("required")
                password_required = await password_input.get_attribute("required")
                
                case_result["username_required"] = username_required is not None
                case_result["password_required"] = password_required is not None
                
                # Try to submit
                await page.click('button[type="submit"]')
                await asyncio.sleep(1)
                
                # Check if browser validation was triggered
                # (browser will block submission if HTML5 validation fails)
                # Check for validation bubble or error state
                validation_selectors = [
                    ':invalid',
                    '[class*="invalid"]',
                    '[class*="error"]',
                    '[class*="required"]'
                ]
                
                for selector in validation_selectors:
                    elements = await page.locator(selector).all()
                    if elements:
                        case_result["validation_triggered"] = True
                        break
                
                logger.info(f"  {test_case['description']}:")
                logger.info(f"    - Username required: {case_result['username_required']}")
                logger.info(f"    - Password required: {case_result['password_required']}")
                logger.info(f"    - Validation triggered: {case_result['validation_triggered']}")
                
                if not case_result["validation_triggered"] and not case_result["username_required"] and not case_result["password_required"]:
                    all_validated = False
                
            except Exception as e:
                case_result["error"] = str(e)
                all_validated = False
            
            test_result["details"]["test_cases"].append(case_result)
            await context.close()
        
        test_result["details"]["all_validated"] = all_validated
        test_result["passed"] = all_validated
        self.test_results.append(test_result)
        
        logger.info(f"  All empty fields properly validated: {all_validated}")
        logger.info(f"  Result: {'PASSED' if test_result['passed'] else 'FAILED'}")
        
        self.console_errors = []
        self.network_errors = []
    
    async def test_sql_injection(self, browser: Browser):
        """Test 5: SQL injection prevention."""
        logger.info("\n" + "-" * 60)
        logger.info("TEST 5: SQL Injection Prevention")
        logger.info("-" * 60)
        
        sql_injection_payloads = [
            "' OR '1'='1",
            "' OR 1=1--",
            "admin'--",
            "' UNION SELECT--",
            "'; DROP TABLE--",
            "1 OR 1=1",
            "' OR ''='",
        ]
        
        test_result = {
            "test_name": "SQL Injection Prevention",
            "passed": False,
            "details": {"test_cases": []},
            "errors": []
        }
        
        all_safe = True
        
        for payload in sql_injection_payloads:
            context = await browser.new_context()
            page = await context.new_page()
            
            case_result = {
                "payload": payload,
                "error_exposed": False,
                "database_error": False,
                "details": {}
            }
            
            try:
                await page.goto(self.base_url, wait_until="networkidle")
                
                # Try SQL injection in username field
                await self._fill_login_form(page, payload, self.valid_password)
                await page.click('button[type="submit"]')
                await asyncio.sleep(2)
                
                # Check for database errors in response
                page_content = await page.content()
                db_errors = ["sql", "syntax", "mysql", "postgres", "oracle", "sqlite", "database error", "you have an error in your sql"]
                
                for error in db_errors:
                    if error.lower() in page_content.lower():
                        case_result["error_exposed"] = True
                        case_result["database_error"] = True
                        break
                
                # Check for generic error vs no error
                if not case_result["error_exposed"]:
                    logger.info(f"  Payload '{payload[:20]}...': Safe (no database error exposed)")
                else:
                    all_safe = False
                    logger.warning(f"  Payload '{payload[:20]}...': DANGEROUS - Database error exposed!")
                
                # Check console for errors
                case_result["console_errors"] = len(self.console_errors) > 0
                
            except Exception as e:
                case_result["error"] = str(e)
            
            test_result["details"]["test_cases"].append(case_result)
            await context.close()
        
        test_result["details"]["all_safe"] = all_safe
        test_result["passed"] = all_safe
        self.test_results.append(test_result)
        
        logger.info(f"  All SQL injection payloads blocked: {all_safe}")
        logger.info(f"  Result: {'PASSED' if test_result['passed'] else 'FAILED - SQL INJECTION VULNERABLE'}")
        
        self.console_errors = []
        self.network_errors = []
    
    async def test_xss_prevention(self, browser: Browser):
        """Test 6: XSS prevention."""
        logger.info("\n" + "-" * 60)
        logger.info("TEST 6: XSS Prevention")
        logger.info("-" * 60)
        
        xss_payloads = [
            "<script>alert('XSS')</script>",
            "<img src=x onerror=alert('XSS')>",
            "<svg onload=alert('XSS')>",
            "javascript:alert('XSS')",
            "<body onload=alert('XSS')>",
            "<iframe src='javascript:alert(\"XSS\")'>",
        ]
        
        test_result = {
            "test_name": "XSS Prevention",
            "passed": False,
            "details": {"test_cases": []},
            "errors": []
        }
        
        all_safe = True
        
        for payload in xss_payloads:
            context = await browser.new_context()
            page = await context.new_page()
            
            case_result = {
                "payload": payload[:30] + "...",
                "script_executed": False,
                "payload_reflected": False,
                "details": {}
            }
            
            try:
                await page.goto(self.base_url, wait_until="networkidle")
                
                # Try XSS in username field
                await self._fill_login_form(page, payload, self.valid_password)
                await page.click('button[type="submit"]')
                await asyncio.sleep(2)
                
                # Check if script was executed (check for alerts in console)
                # Note: This is a basic check - in real tests, you'd use page.on("dialog")
                
                # Check if payload is reflected in page
                page_content = await page.content()
                
                # Check if script tags are sanitized
                if "<script>" in payload and payload in page_content:
                    case_result["payload_reflected"] = True
                    all_safe = False
                    logger.warning(f"  XSS Payload reflected: {case_result['payload']}")
                elif "<script>" in payload:
                    # Script might be stripped
                    logger.info(f"  XSS Payload sanitized: {case_result['payload']}")
                
                # Check console for executed scripts
                case_result["console_errors"] = len(self.console_errors) > 0
                
            except Exception as e:
                case_result["error"] = str(e)
            
            test_result["details"]["test_cases"].append(case_result)
            await context.close()
        
        test_result["details"]["all_safe"] = all_safe
        test_result["passed"] = all_safe
        self.test_results.append(test_result)
        
        logger.info(f"  All XSS payloads blocked: {all_safe}")
        logger.info(f"  Result: {'PASSED' if test_result['passed'] else 'FAILED - XSS VULNERABLE'}")
        
        self.console_errors = []
        self.network_errors = []
    
    async def test_ui_responsiveness(self, browser: Browser):
        """Test 7: UI responsiveness testing."""
        logger.info("\n" + "-" * 60)
        logger.info("TEST 7: UI Responsiveness")
        logger.info("-" * 60)
        
        test_result = {
            "test_name": "UI Responsiveness",
            "passed": False,
            "details": {},
            "errors": []
        }
        
        context = await browser.new_context(viewport={"width": 1280, "height": 720})
        page = await context.new_page()
        
        try:
            await page.goto(self.base_url, wait_until="networkidle")
            
            # Test different viewport sizes
            viewports = [
                {"width": 1920, "height": 1080, "name": "Desktop Full HD"},
                {"width": 1366, "height": 768, "name": "Laptop"},
                {"width": 768, "height": 1024, "name": "Tablet Portrait"},
                {"width": 414, "height": 896, "name": "Mobile"},
                {"width": 375, "height": 667, "name": "Mobile Small"},
            ]
            
            viewport_results = []
            
            for vp in viewports:
                await context.close()
                context = await browser.new_context(viewport=vp)
                page = await context.new_page()
                
                await page.goto(self.base_url, wait_until="networkidle")
                
                # Check if form elements are visible
                form_visible = await page.locator("form").is_visible()
                username_visible = await page.locator('input[type="email"], input[name="email"]').first.is_visible()
                password_visible = await page.locator('input[type="password"]').first.is_visible()
                button_visible = await page.locator('button[type="submit"]').first.is_visible()
                
                viewport_results.append({
                    "viewport": vp["name"],
                    "form_visible": form_visible,
                    "username_visible": username_visible,
                    "password_visible": password_visible,
                    "button_visible": button_visible,
                    "all_elements_visible": form_visible and username_visible and password_visible and button_visible
                })
                
                logger.info(f"  {vp['name']} ({vp['width']}x{vp['height']}): "
                           f"Form={form_visible}, User={username_visible}, "
                           f"Pass={password_visible}, Button={button_visible}")
            
            test_result["details"]["viewport_tests"] = viewport_results
            
            # Check all viewports work
            all_responsive = all(vr["all_elements_visible"] for vr in viewport_results)
            test_result["details"]["all_viewports_responsive"] = all_responsive
            test_result["passed"] = all_responsive
            
            logger.info(f"  All viewports responsive: {all_responsive}")
            
        except Exception as e:
            test_result["errors"].append(str(e))
            logger.error(f"  Error: {e}")
        
        self.test_results.append(test_result)
        logger.info(f"  Result: {'PASSED' if test_result['passed'] else 'FAILED'}")
        
        await context.close()
        self.console_errors = []
        self.network_errors = []
    
    async def test_session_management(self, browser: Browser):
        """Test 8: Session management testing."""
        logger.info("\n" + "-" * 60)
        logger.info("TEST 8: Session Management")
        logger.info("-" * 60)
        
        test_result = {
            "test_name": "Session Management",
            "passed": False,
            "details": {},
            "errors": []
        }
        
        context = await browser.new_context()
        page = await context.new_page()
        
        try:
            # Step 1: Login
            await page.goto(self.base_url, wait_until="networkidle")
            await self._fill_login_form(page, self.valid_username, self.valid_password)
            await page.click('button[type="submit"]')
            await asyncio.sleep(2)
            
            # Get cookies after login
            cookies_after_login = await context.cookies()
            test_result["details"]["cookies_after_login"] = len(cookies_after_login)
            
            # Check for session cookies
            session_cookies = [c for c in cookies_after_login if c.get('httpOnly', False)]
            test_result["details"]["http_only_cookies"] = len(session_cookies)
            
            # Check for secure cookies (would require HTTPS to test properly)
            secure_cookies = [c for c in cookies_after_login if c.get('secure', False)]
            test_result["details"]["secure_cookies"] = len(secure_cookies)
            
            # Check cookie names for session tokens
            cookie_names = [c['name'] for c in cookies_after_login]
            test_result["details"]["cookie_names"] = cookie_names
            
            # Check same-site attribute
            same_site_cookies = [c for c in cookies_after_login if c.get('sameSite') in ['lax', 'strict']]
            test_result["details"]["same_site_cookies"] = len(same_site_cookies)
            
            logger.info(f"  Total cookies after login: {len(cookies_after_login)}")
            logger.info(f"  HTTP-only cookies: {len(session_cookies)}")
            logger.info(f"  Secure cookies: {len(secure_cookies)}")
            logger.info(f"  Same-site cookies: {len(same_site_cookies)}")
            logger.info(f"  Cookie names: {', '.join(cookie_names[:5])}")
            
            # Check session persistence
            page2 = await context.new_page()
            await page2.goto(self.base_url, wait_until="networkidle")
            
            # If we're still logged in on the second page, session is persistent
            still_logged_in = 'login' not in page2.url.lower()
            test_result["details"]["session_persistent"] = still_logged_in
            logger.info(f"  Session persistent across pages: {still_logged_in}")
            
            # Session management is secure if HTTP-only cookies are set
            test_result["passed"] = len(session_cookies) > 0
            
        except Exception as e:
            test_result["errors"].append(str(e))
            logger.error(f"  Error: {e}")
        
        self.test_results.append(test_result)
        logger.info(f"  Result: {'PASSED' if test_result['passed'] else 'NEEDS REVIEW'}")
        
        await context.close()
        self.console_errors = []
        self.network_errors = []
    
    async def test_network_security(self, browser: Browser):
        """Test 9: Network security testing."""
        logger.info("\n" + "-" * 60)
        logger.info("TEST 9: Network Security")
        logger.info("-" * 60)
        
        test_result = {
            "test_name": "Network Security",
            "passed": False,
            "details": {},
            "errors": []
        }
        
        context = await browser.new_context()
        page = await context.new_page()
        
        network_requests = []
        page.on("response", lambda res: network_requests.append(res))
        
        try:
            await page.goto(self.base_url, wait_until="networkidle")
            
            # Perform login
            await self._fill_login_form(page, self.valid_username, self.valid_password)
            await page.click('button[type="submit"]')
            await asyncio.sleep(3)
            
            # Analyze network requests
            login_requests = [r for r in network_requests if 'login' in r.url.lower() or 'auth' in r.url.lower()]
            
            test_result["details"]["total_requests"] = len(network_requests)
            test_result["details"]["login_requests"] = len(login_requests)
            
            login_api_info = []
            for req in login_requests:
                try:
                    login_api_info.append({
                        "url": req.url,
                        "method": req.request.method,
                        "status": req.status,
                        "content_type": req.headers.get("content-type", "unknown")
                    })
                except:
                    pass
            
            test_result["details"]["login_api_details"] = login_api_info
            
            # Check for HTTPS in production (would be ideal)
            # For now, check if credentials are sent securely
            credentials_sent_securely = all(
                'password' not in r.url.lower() or r.url.startswith('https://') 
                for r in login_requests
            )
            test_result["details"]["credentials_sent_securely"] = credentials_sent_securely
            
            # Check for sensitive data in URLs
            sensitive_in_url = any(
                'password' in r.url.lower() or 'token' in r.url.lower() or 'secret' in r.url.lower()
                for r in login_requests
            )
            test_result["details"]["sensitive_data_in_url"] = sensitive_in_url
            
            logger.info(f"  Total network requests: {len(network_requests)}")
            logger.info(f"  Login-related requests: {len(login_requests)}")
            logger.info(f"  Credentials sent securely: {credentials_sent_securely}")
            logger.info(f"  Sensitive data in URL: {sensitive_in_url}")
            
            # Check for proper HTTP status codes
            all_success = all(r.status < 400 for r in login_requests)
            test_result["details"]["all_requests_successful"] = all_success
            
            test_result["passed"] = credentials_sent_securely and not sensitive_in_url
            
        except Exception as e:
            test_result["errors"].append(str(e))
            logger.error(f"  Error: {e}")
        
        self.test_results.append(test_result)
        logger.info(f"  Result: {'PASSED' if test_result['passed'] else 'FAILED'}")
        
        await context.close()
        self.console_errors = []
        self.network_errors = []
    
    async def test_password_field_security(self, browser: Browser):
        """Test 10: Password field security testing."""
        logger.info("\n" + "-" * 60)
        logger.info("TEST 10: Password Field Security")
        logger.info("-" * 60)
        
        test_result = {
            "test_name": "Password Field Security",
            "passed": False,
            "details": {},
            "errors": []
        }
        
        context = await browser.new_context()
        page = await context.new_page()
        
        try:
            await page.goto(self.base_url, wait_until="networkidle")
            
            # Check password field attributes
            password_input = page.locator('input[type="password"]').first
            
            attributes = {}
            attr_checks = [
                "type", "name", "id", "required", "autocomplete", 
                "maxlength", "minlength", "pattern", "readonly", "disabled"
            ]
            
            for attr in attr_checks:
                value = await password_input.get_attribute(attr)
                if value is not None:
                    attributes[attr] = value
            
            test_result["details"]["password_field_attributes"] = attributes
            
            logger.info("  Password field attributes:")
            for attr, value in attributes.items():
                logger.info(f"    - {attr}: {value}")
            
            # Check security issues
            issues = []
            
            # Check if autocomplete is off for password
            if attributes.get("autocomplete") != "off":
                issues.append("autocomplete should be 'off' for password field")
            
            # Check if type is password
            if attributes.get("type") != "password":
                issues.append("password field should have type='password'")
            
            # Check for maxlength
            if "maxlength" not in attributes:
                issues.append("no maxlength specified for password field")
            
            test_result["details"]["security_issues"] = issues
            test_result["passed"] = len(issues) == 0
            
            logger.info(f"  Security issues found: {len(issues)}")
            for issue in issues:
                logger.warning(f"    - {issue}")
            
        except Exception as e:
            test_result["errors"].append(str(e))
            logger.error(f"  Error: {e}")
        
        self.test_results.append(test_result)
        logger.info(f"  Result: {'PASSED' if test_result['passed'] else 'NEEDS REVIEW'}")
        
        await context.close()
        self.console_errors = []
        self.network_errors = []
    
    async def _fill_login_form(self, page: Page, username: str, password: str):
        """Fill login form with given credentials."""
        # Try to find username/email field
        username_selectors = [
            'input[type="email"]',
            'input[name="email"]',
            'input[placeholder*="email" i]',
            'input[id*="email" i]',
            'input[aria-label*="email" i]',
        ]
        
        for selector in username_selectors:
            try:
                input_field = page.locator(selector).first
                if await input_field.is_visible():
                    await input_field.fill(username)
                    break
            except:
                continue
        
        # Try to find password field
        password_selectors = [
            'input[type="password"]',
            'input[name="password"]',
            'input[placeholder*="password" i]',
        ]
        
        for selector in password_selectors:
            try:
                input_field = page.locator(selector).first
                if await input_field.is_visible():
                    await input_field.fill(password)
                    break
            except:
                continue
    
    async def _analyze_login_form(self, page: Page) -> dict:
        """Analyze login form structure."""
        analysis = {}
        
        # Check for form element
        form = page.locator("form")
        analysis["form_exists"] = await form.count() > 0
        
        # Check for CSRF token
        csrf_selectors = [
            'input[name*="csrf"]',
            'input[name*="token"]',
            'input[type="hidden"]'
        ]
        
        csrf_fields = []
        for selector in csrf_selectors:
            fields = await page.locator(selector).all()
            csrf_fields.extend([await f.get_attribute("name") for f in fields])
        
        analysis["csrf_fields"] = csrf_fields
        analysis["has_csrf_protection"] = len(csrf_fields) > 0
        
        # Check for additional form fields
        analysis["input_count"] = await page.locator("form input").count()
        analysis["button_count"] = await page.locator("form button").count()
        
        return analysis
    
    async def _check_security_headers(self, response) -> dict:
        """Check security headers in response."""
        headers = {}
        security_headers = [
            "content-security-policy",
            "strict-transport-security",
            "x-content-type-options",
            "x-frame-options",
            "x-xss-protection"
        ]
        
        if response:
            for header in security_headers:
                value = response.headers.get(header)
                if value:
                    headers[header] = value
        
        return headers
    
    async def _check_success_indicators(self, page: Page) -> list:
        """Check for login success indicators."""
        indicators = []
        
        success_selectors = [
            ("Dashboard", 'text=Dashboard'),
            ("Welcome", 'text=Welcome'),
            ("User menu", '[class*="user"]'),
            ("Logout", 'text=Logout'),
            ("Sign out", 'text=Sign out'),
            ("Profile", 'text=Profile'),
            ("User name", '[class*="user-name"]'),
        ]
        
        for name, selector in success_selectors:
            try:
                count = await page.locator(selector).count()
                if count > 0:
                    indicators.append(name)
            except:
                pass
        
        return indicators
    
    def _capture_console(self, msg, test_name: str):
        """Capture console messages."""
        if msg.type in ["error", "warning"]:
            self.console_errors.append({
                "test": test_name,
                "type": msg.type,
                "text": msg.text[:200]
            })
    
    def _capture_network(self, response, test_name: str):
        """Capture network responses."""
        if response.status >= 400:
            self.network_errors.append({
                "test": test_name,
                "url": response.url[:100],
                "status": response.status
            })
    
    def generate_report(self) -> dict:
        """Generate comprehensive test report."""
        passed = sum(1 for r in self.test_results if r["passed"])
        failed = sum(1 for r in self.test_results if not r["passed"])
        
        report = {
            "test_summary": {
                "total_tests": len(self.test_results),
                "passed": passed,
                "failed": failed,
                "pass_rate": f"{(passed/len(self.test_results)*100):.1f}%" if self.test_results else "N/A"
            },
            "test_results": self.test_results,
            "critical_issues": [],
            "warnings": [],
            "recommendations": []
        }
        
        # Identify critical issues
        for result in self.test_results:
            if not result["passed"] and "injection" in result["test_name"].lower():
                report["critical_issues"].append(f"Security issue: {result['test_name']}")
            if result["errors"]:
                report["warnings"].append(f"{result['test_name']}: {', '.join(result['errors'][:2])}")
        
        # Generate recommendations
        if report["critical_issues"]:
            report["recommendations"].append("URGENT: Address SQL injection and XSS vulnerabilities")
        
        return report


async def main():
    """Main entry point."""
    suite = LoginTestSuite()
    report = await suite.run_all_tests()
    
    # Print final report
    print("\n" + "=" * 80)
    print("FINAL TEST REPORT")
    print("=" * 80)
    
    summary = report["test_summary"]
    print(f"\nTotal Tests: {summary['total_tests']}")
    print(f"Passed: {summary['passed']}")
    print(f"Failed: {summary['failed']}")
    print(f"Pass Rate: {summary['pass_rate']}")
    
    if report["critical_issues"]:
        print("\n🚨 CRITICAL ISSUES:")
        for issue in report["critical_issues"]:
            print(f"  - {issue}")
    
    if report["warnings"]:
        print("\n⚠️ WARNINGS:")
        for warning in report["warnings"]:
            print(f"  - {warning}")
    
    if report["recommendations"]:
        print("\n📋 RECOMMENDATIONS:")
        for rec in report["recommendations"]:
            print(f"  - {rec}")
    
    print("\n" + "=" * 80)
    print("DETAILED RESULTS")
    print("=" * 80)
    
    for result in report["test_results"]:
        status = "✅ PASSED" if result["passed"] else "❌ FAILED"
        print(f"\n{status}: {result['test_name']}")
        if result["details"]:
            for key, value in list(result["details"].items())[:5]:
                print(f"  - {key}: {value}")
        if result["errors"]:
            print(f"  Errors: {result['errors']}")
    
    print("\n" + "=" * 80)
    
    return report


if __name__ == "__main__":
    asyncio.run(main())
