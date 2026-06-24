import { test, expect } from '@playwright/test';

// Configure base URL via environment variable `FRONTEND_BASE_URL` or `BASE_URL`.
const BASE = process.env.FRONTEND_BASE_URL || process.env.BASE_URL || 'http://localhost:35551';

// Credentials to use for the smoke test. Replace or provide via env if needed.
const TEST_EMAIL = process.env.TEST_EMAIL || 'alice@hospital.org';
const TEST_PASSWORD = process.env.TEST_PASSWORD || 'SecureP@ss2026';

test.describe('Frontend login smoke', () => {
  test('should be able to sign in with email + password', async ({ page }) => {
    // Navigate to the login route. The app may use hash routing.
    await page.goto(`${BASE}/#/login`, { waitUntil: 'domcontentloaded' });

    // If the app already shows a dashboard / sign-out, proceed to click a project card.
    const bodyTextNow = (await page.locator('body').innerText()).toLowerCase();
    if (bodyTextNow.includes('sign out') || bodyTextNow.includes('dashboard') || !page.url().includes('#/login')) {
      console.log('Detected dashboard / already logged in — attempting to open first project.');
      await clickFirstProject(page);
      return;
    }

    // Helper to robustly fill inputs used by Flutter web (transparent inputs).
    async function fillInput(selector: string, value: string) {
      const locator = page.locator(selector).first();
      try {
        await locator.waitFor({ state: 'visible', timeout: 2000 });
        await locator.fill(value);
      } catch (e) {
        // fallback to focus + keyboard typing
        await locator.click({ timeout: 2000 }).catch(() => {});
        await page.keyboard.type(value);
      }
    }

    // Email input: Flutter uses inputs with class `flt-text-editing`.
    // Pick the non-password one first.
    const emailSelector = 'input.flt-text-editing:not([type="password"])';
    await fillInput(emailSelector, TEST_EMAIL);

    // Password input (explicit type=password exists in the app snapshot).
    const passwordSelector = 'input[type="password"]';
    await fillInput(passwordSelector, TEST_PASSWORD);

    // Try to enable "Remember me" if a checkbox exists.
    const checkbox = page.locator('input[type="checkbox"]');
    if (await checkbox.count() > 0) {
      try {
        await checkbox.check({ timeout: 1000 });
      } catch (e) {
        // fallback: click the first checkbox
        await checkbox.first().click().catch(() => {});
      }
    }

    // Click the Sign in button using accessible role or text.
    const signInBtn = page.getByRole('button', { name: /sign in/i }).first();
    if (await signInBtn.count() > 0) {
      await signInBtn.click();
    } else {
      // fallback: click a button that contains the label
      const btn = page.locator('button', { hasText: 'Sign in' }).first();
      await btn.click();
    }

    // Wait for either navigation away from the login route or for a known post-login indicator.
    const navigationPromise = page.waitForURL((url) => !url.toString().includes('#/login'), { timeout: 5000 }).catch(() => null);
    const dashboardPromise = page.locator('text=dashboard, text=sign out, text=welcome', { exact: false }).first().waitFor({ timeout: 5000 }).catch(() => null);

    const nav = await navigationPromise;
    const dash = await dashboardPromise;

    // If neither condition happened within the timeout, capture a screenshot and fail the test with helpful output.
    if (!nav && !dash) {
      await page.screenshot({ path: 'frontend/tests/login-failure.png', fullPage: true }).catch(() => {});
      const html = await page.content();
      console.error('Login test: still on login page. Page HTML snippet:\n', html.slice(0, 2000));
      throw new Error('Login did not succeed within timeout — check credentials, base URL, or app state. Screenshot saved to frontend/tests/login-failure.png');
    }

    // Basic assertion: ensure we are no longer on the login hash.
    expect(page.url()).not.toContain('#/login');
    // After successful login, try opening the first project card.
    await clickFirstProject(page);
  });
});

// Helper: click the first visible project card by finding an element that contains "project".
async function clickFirstProject(page) {
  const info = await page.evaluate(() => {
    const nodes = Array.from(document.querySelectorAll('*'));
    const candidate = nodes.find(el => {
      try {
        const t = (el.innerText || '').trim().toLowerCase();
        return t.includes('project') && el.offsetWidth > 60 && el.offsetHeight > 30;
      } catch (e) { return false; }
    });
    if (!candidate) return null;
    const r = candidate.getBoundingClientRect();
    return { x: r.left + r.width/2, y: r.top + r.height/2, text: (candidate.innerText||'').trim().slice(0,200) };
  });
  if (!info) {
    console.log('No project card found to click.');
    return null;
  }
  await page.mouse.click(info.x, info.y);
  await page.waitForTimeout(500);
  console.log('Clicked project card:', info.text.slice(0,120));
  return info;
}

/*
Run instructions:

- Install Playwright and browsers (if not already installed):

  npm init -y
  npm install -D @playwright/test
  npx playwright install

- Run the single test (adjust `FRONTEND_BASE_URL` if your frontend runs on a different URL):

  FRONTEND_BASE_URL=http://localhost:43919 npx playwright test frontend/tests/login.spec.ts --headed

Or set environment variables for credentials:

  FRONTEND_BASE_URL=http://localhost:43919 TEST_EMAIL=alice@hospital.org TEST_PASSWORD=SecureP@ss2026 npx playwright test frontend/tests/login.spec.ts

*/
