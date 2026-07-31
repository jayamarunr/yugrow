import { test, expect } from '@playwright/test';

/**
 * Connection Journey — P1
 *
 * Covers:
 * - Connection request flow
 *
 * NOTE: Connection requests (sending, receiving, accepting) are Flutter mobile features.
 * Web dashboard shows connection-related widgets.
 */
test.describe('Connection Journey', () => {

  test('Dashboard shows connection-related widgets', async ({ page }) => {
    await page.goto('/dashboard');

    // Quick Stats shows "Unread Messages" — related to connections
    await expect(page.locator('text=Unread Messages')).toBeVisible({ timeout: 10000 });
  });

  test('[MOBILE] Send connection request — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Sending a connection request to another attendee',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Accept connection request — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Accepting an incoming connection request',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Connection confirmation — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Visual confirmation when a connection is established',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Connection list in Network tab — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Network screen showing all established connections',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });
});
