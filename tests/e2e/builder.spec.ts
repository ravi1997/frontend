import { test, expect } from '@playwright/test';

test.describe('Form Builder Feature', () => {

    const corsHeaders = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    };

    test.beforeEach(async ({ page, context }) => {
        // Set Auth Cookie
        await context.addCookies([{
            name: 'access_token',
            value: 'fake-jwt-token',
            domain: 'localhost',
            path: '/',
        }]);

        // Unified Route Handler
        await page.route('**/*', async (route) => {
            const url = route.request().url();
            const method = route.request().method();

            if (method === 'OPTIONS') {
                return route.fulfill({ status: 200, headers: corsHeaders });
            }

            if (url.includes('/user/status')) {
                return route.fulfill({
                    status: 200,
                    json: { id: 1, email: 'admin1@example.com', username: 'admin' },
                    headers: corsHeaders
                });
            }

            if (url.includes('/api/v1/form') && method === 'POST') {
                const body = route.request().postDataJSON();
                return route.fulfill({
                    status: 201,
                    json: { id: 'new-form-id', ...body, created_at: new Date().toISOString() },
                    headers: corsHeaders
                });
            }

            route.continue();
        });
    });

    test('should allow creating a new form', async ({ page }) => {
        await page.goto('/builder/new');

        // Assert loaded
        await expect(page.locator('input[placeholder="Untitled Form"]')).toBeVisible({ timeout: 10000 });

        // Change Title
        await page.locator('input[placeholder="Untitled Form"]').fill('My E2E Test Form');

        // Add a "Short Text" field
        // Use a more specific locator for the library button
        await page.getByRole('button', { name: 'Short Text' }).click();

        // Wait for field to be added
        await page.waitForTimeout(1000);

        // Verify it appears in the canvas
        await expect(page.getByRole('main')).toContainText('Untitled short_text', { timeout: 10000 });

        // Save
        await page.getByRole('button', { name: 'Save Draft' }).click();

        // Expect redirect to the new form ID
        await page.waitForURL(/\/builder\/new-form-id/);
    });

    test('should open preview', async ({ page }) => {
        await page.goto('/builder/new');
        // Wait for hydration
        await page.waitForTimeout(1000);
        await page.getByRole('button', { name: 'Preview' }).click();
        await expect(page.locator('text=Form Preview')).toBeVisible();
    });
});
