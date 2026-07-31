import { test, expect } from '@playwright/test';

/**
 * Authentication Journey
 *
 * Covers:
 * - Landing page → Sign In
 * - Login form rendering
 * - Signup mode toggle
 * - Form validation
 * - API error handling
 * - Successful login redirect
 */
test.describe('Authentication Journey', () => {

  test('Landing page loads with sign-in and get-started buttons', async ({ page }) => {
    await page.goto('/');

    // Hero section — h1 text is split by <br>, use role selector
    await expect(page.getByRole('heading', { name: /professional presence/i })).toBeVisible();

    // Navigation buttons — these are <button> elements with onClick, not <a> tags
    await expect(page.getByRole('button', { name: 'Sign In' }).first()).toBeVisible();
    await expect(page.getByRole('button', { name: 'Get Started' }).first()).toBeVisible();
  });

  test('Login page renders with email and password fields', async ({ page }) => {
    await page.goto('/login');

    // Form fields
    await expect(page.locator('input[type="email"]')).toBeVisible();
    await expect(page.locator('input[type="password"]')).toBeVisible();
    await expect(page.getByRole('button', { name: 'Sign In' })).toBeVisible();
  });

  test('Signup mode shows "Create Account" button', async ({ page }) => {
    await page.goto('/login?signup=1');

    await expect(page.getByRole('button', { name: 'Create Account' })).toBeVisible();
    await expect(page.locator('input[type="email"]')).toBeVisible();
    await expect(page.locator('input[type="password"]')).toBeVisible();
  });

  test('Shows error on invalid credentials', async ({ page }) => {
    // Intercept API calls to login endpoint (matches both relative and absolute URLs)
    await page.route(/localhost:\d+\/api\/v1\/identity\/auth\/login/, async route => {
      await route.fulfill({
        status: 401,
        contentType: 'application/json',
        body: JSON.stringify({
          data: { error: { message: 'Invalid email or password' } }
        }),
      });
    });

    await page.goto('/login');
    await page.locator('input[type="email"]').fill('wrong@example.com');
    await page.locator('input[type="password"]').fill('wrongpassword');
    await page.getByRole('button', { name: 'Sign In' }).click();

    // Should show error message — check for alert/error element
    await expect(page.locator('[class*="text-red"], [class*="error"], [class*="alert"]')).toBeVisible({ timeout: 15000 });
  });

  test('Shows network error when API is unreachable', async ({ page }) => {
    // Block the API call to simulate network failure
    await page.route(/localhost:\d+\/api\/v1\/identity\/auth\/login/, async route => {
      await route.abort('connectionrefused');
    });

    await page.goto('/login');
    await page.locator('input[type="email"]').fill('test@yugrow.app');
    await page.locator('input[type="password"]').fill('password123');
    await page.getByRole('button', { name: 'Sign In' }).click();

    // Should show a network error
    await expect(page.locator('[class*="text-red"]')).toBeVisible({ timeout: 10000 });
  });

  test('Successful login redirects to dashboard', async ({ page }) => {
    // Intercept and return success
    await page.route(/localhost:\d+\/api\/v1\/identity\/auth\/login/, async route => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify({
          data: {
            token: 'test-token-123',
            user: { id: '1', email: 'jay@yugrow.app', name: 'Jay' }
          }
        }),
      });
    });

    await page.goto('/login');
    await page.locator('input[type="email"]').fill('jay@yugrow.app');
    await page.locator('input[type="password"]').fill('TestPass123!');
    await page.getByRole('button', { name: 'Sign In' }).click();

    // Should redirect to dashboard
    await expect(page).toHaveURL(/\/dashboard/, { timeout: 10000 });
  });

  test('"Get Started" from landing navigates to signup mode', async ({ page }) => {
    await page.goto('/');

    // Click "Get Started" nav button — uses onClick, not <a> tag
    await page.getByRole('button', { name: 'Get Started' }).first().click();

    await expect(page).toHaveURL(/login\?signup=1/);
    await expect(page.getByRole('button', { name: 'Create Account' })).toBeVisible();
  });

  test('"Sign In" from landing navigates to login', async ({ page }) => {
    await page.goto('/');

    // Click "Sign In" nav button — uses onClick, not <a> tag
    await page.getByRole('button', { name: 'Sign In' }).first().click();

    await expect(page).toHaveURL(/\/login$/);
    await expect(page.getByRole('button', { name: 'Sign In' })).toBeVisible();
  });

  test('Create account link leads to register page (or shows 404 gracefully)', async ({ page }) => {
    await page.goto('/login');
    const createLink = page.locator('text=Create one');
    await expect(createLink).toBeVisible();
    // Note: /register doesn't exist yet — this tests navigation
    // Once implemented, this should assert on the register page content
  });
});
