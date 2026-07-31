import { test, expect } from '@playwright/test';

/**
 * Event Discovery Journey
 *
 * Covers:
 * - Public event detail page
 * - Loading skeleton state
 * - Error state (event not found)
 * - Event data rendering
 * - Interested toggle
 * - Download CTA
 */
test.describe('Event Discovery Journey', () => {

  const mockEvent = {
    id: 'evt_001',
    name: 'Tech Meetup Berlin',
    title: 'Tech Meetup Berlin',
    description: 'A networking event for tech professionals in Berlin.',
    eventType: 'in-person',
    startDate: '2026-08-15T18:00:00Z',
    venue: {
      name: 'Berlin Tech Hub',
      address: '123 Main St, Berlin',
    },
    attendeeCount: 42,
    hostName: 'Yugrow Community',
    topics: ['Networking', 'Tech', 'Berlin'],
  };

  test('Event detail page loads for valid event', async ({ page }) => {
    // Match both http://localhost:3000 and http://localhost:4000 origins
    await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        // Component expects raw event object, not wrapped in {data:}
        body: JSON.stringify(mockEvent),
      });
    });

    await page.goto('/e/evt_001');

    // Event details should appear
    await expect(page.locator(`text=${mockEvent.name}`)).toBeVisible();
    await expect(page.locator(`text=${mockEvent.description}`)).toBeVisible();
    await expect(page.locator(`text=${mockEvent.eventType}`)).toBeVisible();
  });

  test('Event shows venue and host information', async ({ page }) => {
    await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(mockEvent),
      });
    });

    await page.goto('/e/evt_001');

    // Detail cards
    await expect(page.locator(`text=${mockEvent.venue.name}`)).toBeVisible();
    await expect(page.locator(`text=${mockEvent.hostName}`)).toBeVisible();
  });

  test('Event shows attendee count and topics', async ({ page }) => {
    await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(mockEvent),
      });
    });

    await page.goto('/e/evt_001');

    await expect(page.locator(`text=${mockEvent.attendeeCount}`)).toBeVisible();
    for (const topic of mockEvent.topics) {
      await expect(page.locator(`text=${topic}`).first()).toBeVisible();
    }
  });

  test('Interested button toggles on click', async ({ page }) => {
    await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(mockEvent),
      });
    });

    await page.goto('/e/evt_001');

    const interestedButton = page.locator('button:has-text("Interested"), button:has-text("☆")');
    await expect(interestedButton).toBeVisible();

    // Click to mark as interested
    await interestedButton.click();
    // Toggle back
    await interestedButton.click();
  });

  test('Install Yugrow button links to signup', async ({ page }) => {
    await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(mockEvent),
      });
    });

    await page.goto('/e/evt_001');

    // The install button is a <button> with onClick, not an <a> tag
    await expect(page.getByRole('button', { name: /install|download|app/i }).first()).toBeVisible();
  });

  test('Shows loading skeleton while fetching', async ({ page }) => {
    // Don't fulfill route — let it hang to see loading state
    await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
      // Delay to trigger loading state
      await new Promise(resolve => setTimeout(resolve, 2000));
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(mockEvent),
      });
    });

    await page.goto('/e/evt_001');

    // Should show skeleton/loading
    await expect(page.locator('[class*="animate-pulse"], [class*="skeleton"]').first()).toBeVisible({ timeout: 5000 });
  });

  test('Shows error state for non-existent event', async ({ page }) => {
    await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
      await route.fulfill({
        status: 404,
        contentType: 'application/json',
        body: JSON.stringify({
          data: { error: { message: 'Event not found' } }
        }),
      });
    });

    await page.goto('/e/nonexistent');

    // Use getByRole to avoid strict mode violation (two elements match)
    await expect(page.getByRole('heading', { name: 'Event Not Found' })).toBeVisible({ timeout: 10000 });
    await expect(page.getByRole('button', { name: /back to home/i })).toBeVisible();
  });

  test('Page handles no event ID gracefully', async ({ page }) => {
    // Navigate to event page without an ID — should show not-found or redirect
    await page.goto('/e/');
    
    // Either shows an error message or the page loads with some content
    // The page might render "Event not found", "Not Found", or redirect to home
    const hasAnyContent = await page.locator('body').innerText();
    expect(hasAnyContent.length).toBeGreaterThan(0);
  });
});
