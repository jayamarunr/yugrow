import { test, expect } from '@playwright/test';

/**
 * Onboarding Journey — P0
 *
 * NOTE: Onboarding is primarily a Flutter mobile flow.
 * These tests cover the web signup entry point.
 * Full onboarding flow tests require Flutter integration tests.
 */
test.describe('Onboarding Journey', () => {

  test('Signup page is accessible from landing page', async ({ page }) => {
    await page.goto('/');

    // Click "Get Started" nav button — uses onClick, not <a> tag
    await page.getByRole('button', { name: 'Get Started' }).first().click();

    await expect(page).toHaveURL(/login\?signup=1/);
    await expect(page.getByRole('button', { name: /create account/i })).toBeVisible();
  });

  test('Signup form accepts email and password input', async ({ page }) => {
    await page.goto('/login?signup=1');

    await page.locator('input[type="email"]').fill('newuser@example.com');
    await page.locator('input[type="password"]').fill('SecurePass123!');

    await expect(page.locator('input[type="email"]')).toHaveValue('newuser@example.com');
    await expect(page.locator('input[type="password"]')).toHaveValue('SecurePass123!');
  });

  test('Signup shows loading state while creating account', async ({ page }) => {
    // Delay the API response to see loading state
    await page.route('**/api/v1/identity/auth/login', async route => {
      await new Promise(resolve => setTimeout(resolve, 3000));
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify({
          data: { token: 'test-token', user: { id: '2', email: 'test@yugrow.app', name: 'Test User' } },
        }),
      });
    });

    await page.goto('/login?signup=1');
    await page.locator('input[type="email"]').fill('test@yugrow.app');
    await page.locator('input[type="password"]').fill('Password123!');
    await page.getByRole('button', { name: /create account/i }).click();

    // Button should show loading state
    await expect(page.getByRole('button', { name: /create account/i })).toBeDisabled({ timeout: 3000 });
  });

  test('[MOBILE] Onboarding wizard — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Full onboarding flow (profile setup, interests, notifications) requires Flutter driver tests',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Profile setup during onboarding — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Profile photo, name, title, company setup during onboarding',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Notification permissions prompt — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Notification permission dialog during onboarding',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });
});
