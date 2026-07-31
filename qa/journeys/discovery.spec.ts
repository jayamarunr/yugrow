import { test, expect } from '@playwright/test';

/**
 * Discovery Journey — P1
 *
 * Covers:
 * - Event attendee discovery
 * - Live presence display
 *
 * NOTE: Full attendee discovery and live presence is a Flutter mobile feature.
 * Web event page shows attendee count.
 */
test.describe('Discovery Journey', () => {

  const mockEvent = {
    id: 'evt_discovery_001',
    name: 'Discovery Test Event',
    description: 'Testing attendee discovery.',
    eventType: 'in-person',
    startDate: new Date(Date.now() + 86400000).toISOString(), // tomorrow
    venue: { name: 'Discovery Venue', address: '789 Discovery Blvd' },
    attendeeCount: 42,
    hostName: 'Discovery Host',
    topics: ['Networking', 'Discovery'],
  };

  test('Event page shows attendee count', async ({ page }) => {
    await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(mockEvent),
      });
    });

    await page.goto('/e/evt_discovery_001');

    await expect(page.locator(`text=${mockEvent.attendeeCount}`)).toBeVisible();
  });

  test('[MOBILE] Live attendee list — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Live presence screen showing real-time attendees',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Attendee profile cards — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Attendee profile cards with name, title, company',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Presence indicators — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Green dot / presence indicators for checked-in attendees',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });
});
