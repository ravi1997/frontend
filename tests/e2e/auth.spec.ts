import { test, expect } from '@playwright/test';

test.describe('Authentication Flows', () => {

    const corsHeaders = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    };

    test.beforeEach(async ({ page }) => {
        // Handle Preflight for all routes
        await page.route(/.*/, async (route) => {
            if (route.request().method() === 'OPTIONS') {
                return route.fulfill({ status: 200, headers: corsHeaders });
            }
            route.continue();
        });

        // Mock User Status - Initially Not Logged In
        await page.route(/\/user\/status/, async (route) => {
            if (route.request().method() === 'OPTIONS') return; // Handled by generic
            await route.fulfill({
                status: 401,
                json: { message: 'Unauthorized' },
                headers: corsHeaders
            });
        });
    });

    test('should allow user to login with email', async ({ page }) => {
        // Mock Login Success
        await page.route(/\/auth\/login/, async (route) => {
            const json = {
                access_token: 'fake-jwt-token',
                user: { id: 1, email: 'admin1@example.com', username: 'admin' }
            };
            await route.fulfill({
                status: 200,
                json,
                headers: corsHeaders
            });
        });

        // Mock User Status - After Login (Override)
        await page.route(/\/user\/status/, async (route) => {
            const json = { id: 1, email: 'admin1@example.com', username: 'admin' };
            await route.fulfill({
                status: 200,
                json,
                headers: corsHeaders
            });
        });

        await page.goto('/login');

        // Fill credentials
        await page.locator('#email').fill('admin1@example.com');
        await page.locator('#password').fill('Singh@1997');

        // Submit
        await page.locator('button[type="submit"]').click();

        // Expect redirect to dashboard
        await page.waitForURL(/\/dashboard/);

        // Final verification
        await expect(page.locator('h1')).toContainText('Welcome back, admin!', { timeout: 10000 });
    });

    test('should show error on invalid credentials', async ({ page }) => {
        // Mock Login Failure
        await page.route(/\/auth\/login/, async (route) => {
            await route.fulfill({
                status: 401,
                json: { message: 'Invalid credentials' },
                headers: corsHeaders
            });
        });

        await page.goto('/login');

        await page.locator('#email').fill('wrong@example.com');
        await page.locator('#password').fill('wrongpass');
        await page.locator('button[type="submit"]').click();

        // Expect error message
        await expect(page.locator('.text-destructive')).toContainText('Invalid credentials');
    });

    test('should navigate to register page', async ({ page }) => {
        await page.goto('/login');
        await page.click('text=Sign up');
        await expect(page).toHaveURL(/\/register/);
    });
});
