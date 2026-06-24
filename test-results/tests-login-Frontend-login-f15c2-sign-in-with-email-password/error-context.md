# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: tests/login.spec.ts >> Frontend login smoke >> should be able to sign in with email + password
- Location: tests/login.spec.ts:11:7

# Error details

```
Error: Login did not succeed within timeout — check credentials, base URL, or app state. Screenshot saved to frontend/tests/login-failure.png
```

# Page snapshot

```yaml
- generic [ref=e4] [cursor=pointer]:
  - generic:
    - generic:
      - generic:
        - generic:
          - group:
            - generic [ref=e5]:
              - generic: MahaSamgrah Setu
            - generic [ref=e6]:
              - generic: The most intelligent way to manage your forms.
            - generic [ref=e7]:
              - generic: Streamline data collection, automate workflows, and gain real-time insights — all from one platform.
            - generic [ref=e8]:
              - generic: Enterprise Ready
            - generic [ref=e9]:
              - generic: SOC 2 Compliant
            - generic [ref=e10]:
              - generic: 99.9% Uptime
            - generic [ref=e11]:
              - generic: 2.4M+
            - generic [ref=e12]:
              - generic: 180K
            - generic [ref=e13]:
              - generic: 3,800+
            - generic [ref=e14]:
              - generic: Forms Created
            - generic [ref=e15]:
              - generic: Responses Daily
            - generic [ref=e16]:
              - generic: Organizations
            - generic:
              - generic [ref=e17]:
                - generic: Welcome back
              - generic [ref=e18]:
                - generic: Sign in to continue to your workspace.
              - button "Email / Username Email / Username" [ref=e19]
              - button "Phone (OTP) Phone (OTP)" [ref=e20]
              - generic [ref=e21]:
                - generic: Email address
              - generic [ref=e22]:
                - textbox "name@company.com" [invalid] [ref=e23]
                - generic [ref=e24]:
                  - generic: Email is required
              - generic [ref=e25]:
                - generic: Password
              - generic [ref=e26]:
                - textbox [ref=e27]: SecureP@ss2026
                - button "Show password" [ref=e28]
              - button "Remember me checkbox Remember me" [ref=e29]
              - button "Forgot password?" [ref=e30]
              - button "Sign in Sign in" [active] [ref=e31]
              - generic [ref=e32]:
                - generic: OR CONTINUE WITH
              - button "Sign in with Login with AIIMS SSO Login with AIIMS SSO" [ref=e33]
              - generic [ref=e34]:
                - generic: Don't have an account?
              - button "Create account Create account" [ref=e35]
```

# Test source

```ts
  1   | import { test, expect } from '@playwright/test';
  2   | 
  3   | // Configure base URL via environment variable `FRONTEND_BASE_URL` or `BASE_URL`.
  4   | const BASE = process.env.FRONTEND_BASE_URL || process.env.BASE_URL || 'http://localhost:35551';
  5   | 
  6   | // Credentials to use for the smoke test. Replace or provide via env if needed.
  7   | const TEST_EMAIL = process.env.TEST_EMAIL || 'alice@hospital.org';
  8   | const TEST_PASSWORD = process.env.TEST_PASSWORD || 'SecureP@ss2026';
  9   | 
  10  | test.describe('Frontend login smoke', () => {
  11  |   test('should be able to sign in with email + password', async ({ page }) => {
  12  |     // Navigate to the login route. The app may use hash routing.
  13  |     await page.goto(`${BASE}/#/login`, { waitUntil: 'domcontentloaded' });
  14  | 
  15  |     // If the app already shows a dashboard / sign-out, proceed to click a project card.
  16  |     const bodyTextNow = (await page.locator('body').innerText()).toLowerCase();
  17  |     if (bodyTextNow.includes('sign out') || bodyTextNow.includes('dashboard') || !page.url().includes('#/login')) {
  18  |       console.log('Detected dashboard / already logged in — attempting to open first project.');
  19  |       await clickFirstProject(page);
  20  |       return;
  21  |     }
  22  | 
  23  |     // Helper to robustly fill inputs used by Flutter web (transparent inputs).
  24  |     async function fillInput(selector: string, value: string) {
  25  |       const locator = page.locator(selector).first();
  26  |       try {
  27  |         await locator.waitFor({ state: 'visible', timeout: 2000 });
  28  |         await locator.fill(value);
  29  |       } catch (e) {
  30  |         // fallback to focus + keyboard typing
  31  |         await locator.click({ timeout: 2000 }).catch(() => {});
  32  |         await page.keyboard.type(value);
  33  |       }
  34  |     }
  35  | 
  36  |     // Email input: Flutter uses inputs with class `flt-text-editing`.
  37  |     // Pick the non-password one first.
  38  |     const emailSelector = 'input.flt-text-editing:not([type="password"])';
  39  |     await fillInput(emailSelector, TEST_EMAIL);
  40  | 
  41  |     // Password input (explicit type=password exists in the app snapshot).
  42  |     const passwordSelector = 'input[type="password"]';
  43  |     await fillInput(passwordSelector, TEST_PASSWORD);
  44  | 
  45  |     // Try to enable "Remember me" if a checkbox exists.
  46  |     const checkbox = page.locator('input[type="checkbox"]');
  47  |     if (await checkbox.count() > 0) {
  48  |       try {
  49  |         await checkbox.check({ timeout: 1000 });
  50  |       } catch (e) {
  51  |         // fallback: click the first checkbox
  52  |         await checkbox.first().click().catch(() => {});
  53  |       }
  54  |     }
  55  | 
  56  |     // Click the Sign in button using accessible role or text.
  57  |     const signInBtn = page.getByRole('button', { name: /sign in/i }).first();
  58  |     if (await signInBtn.count() > 0) {
  59  |       await signInBtn.click();
  60  |     } else {
  61  |       // fallback: click a button that contains the label
  62  |       const btn = page.locator('button', { hasText: 'Sign in' }).first();
  63  |       await btn.click();
  64  |     }
  65  | 
  66  |     // Wait for either navigation away from the login route or for a known post-login indicator.
  67  |     const navigationPromise = page.waitForURL((url) => !url.toString().includes('#/login'), { timeout: 5000 }).catch(() => null);
  68  |     const dashboardPromise = page.locator('text=dashboard, text=sign out, text=welcome', { exact: false }).first().waitFor({ timeout: 5000 }).catch(() => null);
  69  | 
  70  |     const nav = await navigationPromise;
  71  |     const dash = await dashboardPromise;
  72  | 
  73  |     // If neither condition happened within the timeout, capture a screenshot and fail the test with helpful output.
  74  |     if (!nav && !dash) {
  75  |       await page.screenshot({ path: 'frontend/tests/login-failure.png', fullPage: true }).catch(() => {});
  76  |       const html = await page.content();
  77  |       console.error('Login test: still on login page. Page HTML snippet:\n', html.slice(0, 2000));
> 78  |       throw new Error('Login did not succeed within timeout — check credentials, base URL, or app state. Screenshot saved to frontend/tests/login-failure.png');
      |             ^ Error: Login did not succeed within timeout — check credentials, base URL, or app state. Screenshot saved to frontend/tests/login-failure.png
  79  |     }
  80  | 
  81  |     // Basic assertion: ensure we are no longer on the login hash.
  82  |     expect(page.url()).not.toContain('#/login');
  83  |     // After successful login, try opening the first project card.
  84  |     await clickFirstProject(page);
  85  |   });
  86  | });
  87  | 
  88  | // Helper: click the first visible project card by finding an element that contains "project".
  89  | async function clickFirstProject(page) {
  90  |   const info = await page.evaluate(() => {
  91  |     const nodes = Array.from(document.querySelectorAll('*'));
  92  |     const candidate = nodes.find(el => {
  93  |       try {
  94  |         const t = (el.innerText || '').trim().toLowerCase();
  95  |         return t.includes('project') && el.offsetWidth > 60 && el.offsetHeight > 30;
  96  |       } catch (e) { return false; }
  97  |     });
  98  |     if (!candidate) return null;
  99  |     const r = candidate.getBoundingClientRect();
  100 |     return { x: r.left + r.width/2, y: r.top + r.height/2, text: (candidate.innerText||'').trim().slice(0,200) };
  101 |   });
  102 |   if (!info) {
  103 |     console.log('No project card found to click.');
  104 |     return null;
  105 |   }
  106 |   await page.mouse.click(info.x, info.y);
  107 |   await page.waitForTimeout(500);
  108 |   console.log('Clicked project card:', info.text.slice(0,120));
  109 |   return info;
  110 | }
  111 | 
  112 | /*
  113 | Run instructions:
  114 | 
  115 | - Install Playwright and browsers (if not already installed):
  116 | 
  117 |   npm init -y
  118 |   npm install -D @playwright/test
  119 |   npx playwright install
  120 | 
  121 | - Run the single test (adjust `FRONTEND_BASE_URL` if your frontend runs on a different URL):
  122 | 
  123 |   FRONTEND_BASE_URL=http://localhost:43919 npx playwright test frontend/tests/login.spec.ts --headed
  124 | 
  125 | Or set environment variables for credentials:
  126 | 
  127 |   FRONTEND_BASE_URL=http://localhost:43919 TEST_EMAIL=alice@hospital.org TEST_PASSWORD=SecureP@ss2026 npx playwright test frontend/tests/login.spec.ts
  128 | 
  129 | */
  130 | 
```