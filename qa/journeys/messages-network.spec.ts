import { test, expect } from '@playwright/test';

/**
 * Messages & Network Journey — P1
 *
 * Covers:
 * - Messages screen
 * - Network screen
 * - Relationship management
 *
 * NOTE: Full Messages and Network screens are Flutter mobile features.
 * Web dashboard shows related widgets (Recent Activity, Quick Stats).
 */
test.describe('Messages & Network Journey', () => {

  test('Dashboard shows Recent Activity widget', async ({ page }) => {
    await page.goto('/dashboard');

    await expect(page.locator('text=Recent Activity').first()).toBeVisible({ timeout: 10000 });
  });

  test('Recent Activity includes connection-related items', async ({ page }) => {
    await page.goto('/dashboard');

    await expect(page.locator('text=New lead').first()).toBeVisible({ timeout: 10000 });
    await expect(page.locator('text=Broadcast sent').first()).toBeVisible();
  });

  test('Dashboard shows Unread Messages stat', async ({ page }) => {
    await page.goto('/dashboard');

    await expect(page.locator('text=Unread Messages')).toBeVisible({ timeout: 10000 });
  });

  test('[MOBILE] Messages screen loads — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Messages screen showing conversation list',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Network screen loads — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Network screen showing all connections',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Network relationship filtering — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Filter connections by event, date, or relevance',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });
});
