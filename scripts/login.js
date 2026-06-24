const { chromium } = require('playwright');

async function run() {
  const BASE = process.env.FRONTEND_BASE_URL || process.env.BASE_URL || 'http://localhost:43919';
  const EMAIL = process.env.TEST_EMAIL || 'alice@hospital.org';
  const PASSWORD = process.env.TEST_PASSWORD || 'SecureP@ss2026';
  const headless = process.env.HEADLESS !== 'false';

  const browser = await chromium.launch({ headless });
  const context = await browser.newContext();
  const page = await context.newPage();

  try {
    await page.goto(`${BASE}/#/login`, { waitUntil: 'domcontentloaded', timeout: 10000 });

    const body = (await page.textContent('body')) || '';
    const lower = body.toLowerCase();
    if (lower.includes('sign out') || lower.includes('dashboard') || !page.url().includes('#/login')) {
      console.log('Detected dashboard or already logged in — attempting to open first project.');
      await clickFirstProject(page);
      await browser.close();
      return;
    }

    // Robust email fill for Flutter web transparent inputs
    const emailSelector = 'input.flt-text-editing:not([type="password"])';
    if (await page.$(emailSelector)) {
      try {
        await page.fill(emailSelector, EMAIL);
      } catch (e) {
        await page.click(emailSelector).catch(() => {});
        await page.keyboard.type(EMAIL);
      }
    } else {
      const alt = await page.$('input[type="email"], input[placeholder*="email" i]');
      if (alt) await alt.fill(EMAIL);
      else {
        // try to focus first text input and type
        const anyText = await page.$('input[type="text"], input:not([type])');
        if (anyText) { await anyText.fill(EMAIL).catch(async ()=>{ await anyText.click(); await page.keyboard.type(EMAIL); }); }
        else { await page.keyboard.type(EMAIL); }
      }
    }

    // Password
    const passSel = 'input[type="password"]';
    if (await page.$(passSel)) {
      try {
        await page.fill(passSel, PASSWORD);
      } catch (e) {
        await page.click(passSel).catch(() => {});
        await page.keyboard.type(PASSWORD);
      }
    } else {
      await page.keyboard.type(PASSWORD);
    }

    // Remember me checkbox if present
    const checkbox = await page.$('input[type="checkbox"]');
    if (checkbox) {
      try { await checkbox.check(); } catch (e) { await checkbox.click().catch(()=>{}); }
    }

    // Click sign in
    try {
      const signIn = page.getByRole ? page.getByRole('button', { name: /sign in/i }).first() : null;
      if (signIn) {
        await signIn.click();
      } else {
        const btn = await page.$('button:has-text("Sign in"), button:has-text("Sign in")');
        if (btn) await btn.click();
        else await page.keyboard.press('Enter');
      }
    } catch (e) {
      // fallback: try to click any button containing Sign in text
      const btn = await page.$('//button[contains(translate(., "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "sign in")]');
      if (btn) await btn.click();
    }

    // Wait for either navigation or dashboard indicator
    const navigation = page.waitForURL(url => !url.toString().includes('#/login'), { timeout: 7000 }).catch(() => null);
    const dashboardIndicator = page.locator('text=dashboard, text=sign out, text=welcome').first().waitFor({ timeout: 7000 }).catch(() => null);

    const [nav, dash] = await Promise.all([navigation, dashboardIndicator]);

    if (!nav && !dash) {
      await page.screenshot({ path: 'frontend/scripts/login-failure.png', fullPage: true }).catch(() => {});
      console.error('Login likely failed. Screenshot saved to frontend/scripts/login-failure.png');
      process.exitCode = 2;
    } else {
      console.log('Login succeeded (navigation or dashboard detected).');
      // open the first project card on dashboard
      await clickFirstProject(page);
    }

  } catch (err) {
    console.error('Error running login script:', err);
    await page.screenshot({ path: 'frontend/scripts/login-error.png', fullPage: true }).catch(() => {});
    process.exitCode = 3;
  } finally {
    await browser.close();
  }
}

if (require.main === module) run();

// Helper to click the first visible project card on the dashboard.
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
Run example:

1) Install Playwright and browsers (if not already):
   npm init -y
   npm install -D playwright
   npx playwright install

2) Run the script (adjust base URL and credentials with env vars):
   FRONTEND_BASE_URL=http://localhost:43919 TEST_EMAIL=alice@hospital.org TEST_PASSWORD=SecureP@ss2026 node frontend/scripts/login.js

Set HEADLESS=false to run headed.
*/
