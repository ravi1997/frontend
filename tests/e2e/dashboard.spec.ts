import { test, expect } from '@playwright/test';

test.describe('Dashboard Feature', () => {

    const mockForms = [
        { id: 'f1', title: 'Survey 2024', created_at: new Date().toISOString(), is_public: true },
        { id: 'f2', title: 'Draft Form', created_at: new Date().toISOString(), is_public: false },
    ];

    const corsHeaders = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    };

    test.beforeEach(async ({ page, context }) => {
        // Debug: Log all console messages
        page.on('console', msg => console.log('PAGE LOG:', msg.text()));

        // Log all requests
        page.on('request', request => {
            console.log(`>> REQUEST: ${request.method()} ${request.url()}`);
        });

        // Log all responses
        page.on('response', response => {
            console.log(`<< RESPONSE: ${response.status()} ${response.url()}`);
        });

        // Set Auth Cookie to bypass Middleware
        await context.addCookies([
            {
                name: 'access_token',
                value: 'fake-jwt-token',
                domain: 'localhost',
                path: '/',
            },
            {
                name: 'access_token',
                value: 'fake-jwt-token',
                domain: '127.0.0.1',
                path: '/',
            }
        ]);

        // Unified Route Handler
        await page.route('**/*', async (route) => {
            const url = route.request().url();
            const method = route.request().method();

            // Handle Preflight
            if (method === 'OPTIONS') {
                return route.fulfill({ status: 200, headers: corsHeaders });
            }

            // Mock User Status
            if (url.includes('/user/status')) {
                console.log('--- MOCKING user/status HIT ---');
                return route.fulfill({
                    status: 200,
                    json: { id: 1, email: 'admin1@example.com', username: 'admin' },
                    headers: corsHeaders
                });
            }

            // Mock Forms List
            if (url.includes('/form') && method === 'GET') {
                console.log('--- MOCKING form GET HIT ---');
                return route.fulfill({
                    status: 200,
                    json: mockForms,
                    headers: corsHeaders
                });
            }

            route.continue();
        });
    });

    test('should display stats and form list', async ({ page }) => {
        await page.goto('/dashboard');

        // Wait for user status to load
        await expect(page.locator('h1')).toContainText('Welcome back, admin!', { timeout: 15000 });

        // Check Stats - Use more robust selectors
        const totalFormsCard = page.locator('div.rounded-xl').filter({ hasText: 'Total Forms' });
        await expect(totalFormsCard.locator('.text-2xl')).toHaveText('2', { timeout: 10000 });

        const activeFormsCard = page.locator('div.rounded-xl').filter({ hasText: 'Active Forms' });
        await expect(activeFormsCard.locator('.text-2xl')).toHaveText('1');

        // Check Recent Forms List
        await expect(page.locator('text=Survey 2024')).toBeVisible();
        await expect(page.locator('text=Draft Form')).toBeVisible();
    });

    test('should navigate to form builder', async ({ page }) => {
        await page.goto('/dashboard');

        // Ensure page is ready
        await expect(page.locator('h1')).toContainText('Welcome back, admin!');

        // Navigate
        await Promise.all([
            page.waitForURL(/\/builder\/new/, { timeout: 15000 }),
            page.getByRole('link', { name: 'Create New Form' }).click(),
        ]);
    });
});
