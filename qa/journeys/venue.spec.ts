import { test, expect } from '@playwright/test';

/**
 * Venue Journey — P1
 *
 * Covers:
 * - Venue information display on event pages
 * - Venue address rendering
 *
 * NOTE: Venue search and creation are Flutter mobile features.
 */
test.describe('Venue Journey', () => {

  const mockEvent = {
    id: 'evt_venue_001',
    name: 'Venue Test Event',
    description: 'Testing venue display.',
    eventType: 'in-person',
    venue: {
      name: 'Test Venue',
      address: '456 Test Avenue, Test City',
    },
    startDate: '2026-08-20T18:00:00Z',
    attendeeCount: 15,
    hostName: 'Test Host',
    topics: ['Testing'],
  };

  test('Event page displays venue name and address', async ({ page }) => {
    await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(mockEvent),
      });
    });

    await page.goto('/e/evt_venue_001');

    await expect(page.locator(`text=${mockEvent.venue.name}`)).toBeVisible();
    await expect(page.locator(`text=${mockEvent.venue.address}`)).toBeVisible();
  });

  test('Event venue shows in detail card', async ({ page }) => {
    await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(mockEvent),
      });
    });

    await page.goto('/e/evt_venue_001');

    // Venue should be in a detail card
    const venueCard = page.locator(`text=${mockEvent.venue.name}`).locator('..');
    await expect(venueCard).toBeVisible();
  });

  test('[MOBILE] Venue search functionality — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Venue search with Mapbox integration during event creation',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });

  test('[MOBILE] Venue creation flow — requires Flutter integration test', async () => {
    test.info().annotations.push({
      type: 'mobile',
      description: 'Creating a new venue during event creation',
    });
    test.skip(true, 'Flutter mobile test — run via flutter test');
  });
});
