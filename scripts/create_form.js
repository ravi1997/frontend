const { chromium } = require('playwright');

/**
 * Script: create_form.js
 * - Clicks the Flutter-rendered `New form` button (uses flt-semantics when available)
 * - Waits for the create-form dialog
 * - Fills the form title and submits
 *
 * Usage:
 * FRONTEND_BASE_URL=http://localhost:43919 FORM_TITLE="My Form" HEADLESS=false node frontend/scripts/create_form.js
 */

async function run() {
  const BASE = process.env.FRONTEND_BASE_URL || process.env.BASE_URL || 'http://localhost:43919';
  const FORM_TITLE = process.env.FORM_TITLE || 'E2E Test Form';
  const headless = process.env.HEADLESS !== 'false';

  const browser = await chromium.launch({ headless });
  const context = await browser.newContext();
  const page = await context.newPage();

  try {
    await page.goto(`${BASE}`, { waitUntil: 'domcontentloaded', timeout: 15000 });

    // Ensure the page is ready a short moment
    await page.waitForTimeout(500);

    // Try clicking flt-semantics node with text 'new form'
    const clicked = await page.evaluate(() => {
      const nodes = Array.from(document.querySelectorAll('flt-semantics'));
      const target = nodes.find(n => (n.innerText || '').trim().toLowerCase().includes('new form'));
      if (!target) return null;
      const r = target.getBoundingClientRect();
      const cx = r.left + r.width / 2;
      const cy = r.top + r.height / 2;
      // Dispatch pointer events to trigger Flutter tap handlers
      target.dispatchEvent(new PointerEvent('pointerdown', { bubbles: true, clientX: cx, clientY: cy }));
      target.dispatchEvent(new PointerEvent('pointerup', { bubbles: true, clientX: cx, clientY: cy }));
      target.dispatchEvent(new MouseEvent('click', { bubbles: true, clientX: cx, clientY: cy }));
      return { cx, cy };
    });

    if (!clicked) {
      // fallback: try to click by approximate coordinates in the top-right area
      const fallbackX = process.env.NEW_FORM_X ? parseInt(process.env.NEW_FORM_X, 10) : null;
      const fallbackY = process.env.NEW_FORM_Y ? parseInt(process.env.NEW_FORM_Y, 10) : null;
      if (fallbackX && fallbackY) {
        await page.mouse.click(fallbackX, fallbackY);
      } else {
        // conservative top-right attempt
        const w = await page.evaluate(() => window.innerWidth || document.documentElement.clientWidth);
        await page.mouse.click(Math.round(w - 260), 48);
      }
    } else {
      // move mouse to clicked area (Playwright mouse click will follow up if needed)
      await page.mouse.click(Math.round(clicked.cx), Math.round(clicked.cy));
    }

    // Wait for a dialog or input to appear
    await page.waitForTimeout(600);

    // Detect dialog or form title prompt text
    const dialogDetected = await page.evaluate(() => {
      const dialog = document.querySelector('[role="dialog"], .modal, .Modal, .drawer, .Drawer');
      if (dialog) return true;
      const body = (document.body.innerText || '').toLowerCase();
      return body.includes('form title') || body.includes('create form') || body.includes('form name') || body.includes('create a form');
    });

    if (!dialogDetected) {
      console.warn('No dialog or create-form prompt detected after clicking New form. Taking a screenshot.');
      await page.screenshot({ path: 'frontend/scripts/create-form-no-dialog.png', fullPage: true }).catch(() => {});
      throw new Error('Create form dialog not detected');
    }

    // Try to find the Flutter transparent text input used for editing
    const textInputSelector = 'input.flt-text-editing:not([type="password"])';
    if (await page.$(textInputSelector)) {
      await page.fill(textInputSelector, FORM_TITLE);
    } else {
      // try common HTML inputs
      const htmlInput = await page.$('input[type="text"], input[placeholder*="title" i], textarea');
      if (htmlInput) {
        await htmlInput.fill(FORM_TITLE);
      } else {
        // fallback: focus body and type (assumes Flutter focused hidden input)
        await page.keyboard.type(FORM_TITLE);
      }
    }

    // Wait briefly for typing to register
    await page.waitForTimeout(200);

    // Click a button labelled Create / Save / Add form
    const clickedCreate = await page.evaluate(() => {
      // try flt-semantics buttons first
      const nodes = Array.from(document.querySelectorAll('flt-semantics'));
      const btn = nodes.find(n => {
        const t = (n.innerText || '').trim().toLowerCase();
        return t === 'create' || t === 'save' || t.includes('create form') || t.includes('add form') || t === 'create form';
      });
      if (btn) {
        const r = btn.getBoundingClientRect();
        const cx = r.left + r.width / 2;
        const cy = r.top + r.height / 2;
        btn.dispatchEvent(new PointerEvent('pointerdown', { bubbles: true, clientX: cx, clientY: cy }));
        btn.dispatchEvent(new PointerEvent('pointerup', { bubbles: true, clientX: cx, clientY: cy }));
        btn.dispatchEvent(new MouseEvent('click', { bubbles: true, clientX: cx, clientY: cy }));
        return true;
      }
      // fallback: HTML button by text
      const allBtns = Array.from(document.querySelectorAll('button, a, [role="button"]'));
      const htmlBtn = allBtns.find(b => {
        const t = (b.innerText || b.textContent || '').trim().toLowerCase();
        return t === 'create' || t === 'save' || t.includes('create form') || t.includes('add form') || t.includes('create');
      });
      if (htmlBtn) { htmlBtn.click(); return true; }
      return false;
    });

    if (!clickedCreate) {
      console.warn('Create button not found; saving screenshot.');
      await page.screenshot({ path: 'frontend/scripts/create-form-no-create.png', fullPage: true }).catch(() => {});
      throw new Error('Create button not found');
    }

    // Wait for the UI to reflect the new form (simple heuristic: page contains the form title)
    const created = await page.waitForFunction((title) => {
      const body = (document.body.innerText || '').toLowerCase();
      return body.includes(title.toLowerCase()) || !!document.querySelector('[role="dialog"].open');
    }, FORM_TITLE, { timeout: 5000 }).catch(() => null);

    if (!created) {
      await page.screenshot({ path: 'frontend/scripts/create-form-timeout.png', fullPage: true }).catch(() => {});
      throw new Error('Timed out waiting for created form to appear');
    }

    console.log('Form creation flow completed (title:', FORM_TITLE, ')');
  } catch (err) {
    console.error('Error in create_form script:', err && err.message ? err.message : err);
    throw err;
  } finally {
    await browser.close();
  }
}

if (require.main === module) {
  run().catch(err => {
    console.error(err);
    process.exit(1);
  });
}
