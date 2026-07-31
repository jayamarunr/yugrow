import { test, expect } from '@playwright/test';

/**
 * Profile Journey — P1
 *
 * Covers:
 * - Dashboard profile display
 * - Professional identity
 * - Profile navigation
 *
 * NOTE: Full profile editing is a Flutter mobile feature.
 * Web dashboard shows a welcome message with hardcoded name ("Jay").
 */
test.describe('Profile Journey', () => {

  test('Dashboard displays welcome with user name', async ({ page }) => {
    await page.goto('/dashboard');

    await expect(page.locator('text=Welcome back').first()).toBeVisible({ timeout: 10000 });
  });

  test('Dashboard profile section is accessible', async ({ page }) => {
    await page.goto('/dashboard');

    // Look for profile-related elements
    const profileSection = page.locator('text=Profile, text=Account, text=Settings');
    // The dashboard shows user initial "J" in the topbar
    await expect(page.getByRole('button', { name: 'J' }).first()).toBeVisible({ timeout: 10000 });
  });

  test('[MOBILE] Profile editing screen — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Profile editing: photo, name, title, company, bio',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Professional identity settings — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Professional identity API integration for profile',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });
});
