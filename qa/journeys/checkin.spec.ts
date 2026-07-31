import { test, expect } from '@playwright/test';

/**
 * Check-in Journey — P0
 *
 * Covers:
 * - Event page check-in button
 * - "I'm Here" button visibility
 * - Check-in flow preconditions
 *
 * NOTE: Full check-in flow (QR code, NFC, geolocation) is a Flutter mobile feature.
 * Web app shows event details and directs users to download the mobile app.
 */
test.describe('Check-in Journey', () => {

  const mockEvent = {
    id: 'evt_checkin_001',
    name: 'Check-in Test Event',
    description: 'Testing check-in flow.',
    eventType: 'in-person',
    startDate: new Date(Date.now() - 3600000).toISOString(), // 1 hour ago (started)
    venue: { name: 'Check-in Venue', address: '123 Checkin St' },
    attendeeCount: 30,
    hostName: 'Event Host',
    topics: ['Check-in', 'Testing'],
  };

  test('Event page shows install CTA for check-in', async ({ page }) => {
    await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(mockEvent),
      });
    });

    await page.goto('/e/evt_checkin_001');

    // "Install Yugrow to Network" CTA — button uses onClick, not <a> tag
    await expect(page.getByRole('button', { name: /install|download|app|yugrow/i }).first()).toBeVisible();
  });

  test('Event page shows networking disclaimer', async ({ page }) => {
    await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(mockEvent),
      });
    });

    await page.goto('/e/evt_checkin_001');

    await expect(page.locator('text=Networking only begins after you check in at the venue')).toBeVisible();
  });

  test('[MOBILE] Check-in with QR code — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'QR code scanning at venue for check-in',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] "I\'m Here" button at event — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: '"I\'m Here" button disabled for future events, enabled for live events',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Check-in with geolocation — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Geolocation-based check-in verification',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });
});
