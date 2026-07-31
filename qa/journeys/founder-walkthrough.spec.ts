import { test, expect } from '@playwright/test';

/**
 * Founder Walkthrough — The Complete Yugrow Journey
 *
 * This is the master regression test. It simulates a real user's
 * full journey through the Yugrow platform.
 *
 * Journey steps:
 *   1. Landing Page → View hero, features, how-it-works
 *   2. Sign Up → Navigate to signup
 *   3. Sign In → Login with credentials
 *   4. Dashboard → View widgets, journeys, coach
 *   5. Event Discovery → View public event
 *   6. Express Interest → Toggle interested
 *   7. Health Check → Verify platform status
 *
 * Each step is independent so failures are isolated.
 */
test.describe('Founder Walkthrough — Complete Yugrow Journey', () => {

  test.describe('Step 1: Landing Page', () => {

    test('Hero section renders with all key elements', async ({ page }) => {
      await page.goto('/');

      // h1 text is split by <br>, use role selector
      await expect(page.getByRole('heading', { name: /professional presence/i })).toBeVisible();
      // Nav buttons are <button> with onClick, not <a> tags
      await expect(page.getByRole('button', { name: 'Sign In' }).first()).toBeVisible();
      await expect(page.getByRole('button', { name: 'Get Started' }).first()).toBeVisible();
    });

    test('How It Works section displays 4 steps', async ({ page }) => {
      await page.goto('/');

      const steps = ['Find an Event', 'Check In', 'Meet People', 'Stay Connected'];
      for (const step of steps) {
        await expect(page.locator(`text=${step}`).first()).toBeVisible();
      }
    });

    test('Feature cards are all rendered', async ({ page }) => {
      await page.goto('/');

      const features = ['Discover Events', 'Check In', 'Meet Professionals', 'Connect Instantly', 'Continue Conversations', 'Missed Connections'];
      for (const feature of features) {
        await expect(page.locator(`text=${feature}`).first()).toBeVisible();
      }
    });

    test('CTA buttons navigate correctly', async ({ page }) => {
      await page.goto('/');

      // "Get Started" → signup (nav button uses onClick, not <a>)
      await page.getByRole('button', { name: 'Get Started' }).first().click();
      await expect(page).toHaveURL(/login\?signup=1/);
    });

    test('Page is visually complete with no console errors', async ({ page }) => {
      const errors: string[] = [];
      page.on('console', msg => msg.type() === 'error' && errors.push(msg.text()));

      await page.goto('/');
      await page.waitForLoadState('networkidle');

      expect(errors).toEqual([]);
    });
  });

  test.describe('Step 2: Sign In', () => {

    test('Login form renders with all fields', async ({ page }) => {
      await page.goto('/login');

      await expect(page.locator('input[type="email"]')).toBeVisible();
      await expect(page.locator('input[type="password"]')).toBeVisible();
      await expect(page.getByRole('button', { name: 'Sign In' })).toBeVisible();
    });

    test('Shows error on invalid credentials', async ({ page }) => {
      await page.route(/localhost:\d+\/api\/v1\/identity\/auth\/login/, async route => {
        await route.fulfill({
          status: 401,
          contentType: 'application/json',
          body: JSON.stringify({ data: { error: { message: 'Invalid email or password' } } }),
        });
      });

      await page.goto('/login');
      await page.locator('input[type="email"]').fill('wrong@example.com');
      await page.locator('input[type="password"]').fill('badpassword');
      await page.getByRole('button', { name: 'Sign In' }).click();

      await expect(page.locator('[class*="text-red"], [class*="error"], [class*="alert"]')).toBeVisible({ timeout: 15000 });
    });

    test('Successful login redirects to dashboard', async ({ page }) => {
      await page.route(/localhost:\d+\/api\/v1\/identity\/auth\/login/, async route => {
        await route.fulfill({
          status: 200,
          contentType: 'application/json',
          body: JSON.stringify({
            data: {
              token: 'test-token-walkthrough',
              user: { id: '1', email: 'jay@yugrow.app', name: 'Jay' },
            },
          }),
        });
      });

      await page.goto('/login');
      await page.locator('input[type="email"]').fill('jay@yugrow.app');
      await page.locator('input[type="password"]').fill('TestPass123!');
      await page.getByRole('button', { name: 'Sign In' }).click();

      await expect(page).toHaveURL(/\/dashboard/, { timeout: 10000 });
    });
  });

  test.describe('Step 3: Dashboard', () => {

    test('Dashboard displays welcome and key sections', async ({ page }) => {
      await page.goto('/dashboard');

      // Welcome guide shows first
      await expect(page.getByRole('heading', { name: /welcome to yugrow/i })).toBeVisible({ timeout: 10000 });
      // Scroll down to widgets
      await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
      await expect(page.locator('text=Recent Activity').first()).toBeVisible();
      await expect(page.locator('text=Quick Stats').first()).toBeVisible();
      await expect(page.locator('text=Upcoming Events').first()).toBeVisible();
    });

    test('Quick Stats displays all 4 metrics', async ({ page }) => {
      await page.goto('/dashboard');

      await expect(page.locator('text=Open Deals')).toBeVisible({ timeout: 10000 });
      await expect(page.locator('text=Pending Invoices')).toBeVisible();
      await expect(page.locator('text=Active Broadcasts')).toBeVisible();
      await expect(page.locator('text=Unread Messages')).toBeVisible();
    });

    test('Recent Activity shows all 4 items', async ({ page }) => {
      await page.goto('/dashboard');

      for (const activity of ['New lead', 'Invoice paid', 'Blog published', 'Broadcast sent']) {
        await expect(page.locator(`text=${activity}`).first()).toBeVisible({ timeout: 5000 });
      }
    });

    test('Journey launcher shows available journeys', async ({ page }) => {
      await page.goto('/dashboard');

      // Journey cards are visible
      await expect(page.getByRole('button', { name: /start a business/i }).first()).toBeVisible({ timeout: 10000 });
      await expect(page.getByRole('button', { name: /find customers/i }).first()).toBeVisible();
      await expect(page.getByRole('button', { name: /attend an event/i }).first()).toBeVisible();
    });
  });

  test.describe('Step 4: Event Discovery', () => {

    const mockEvent = {
      id: 'evt_walkthrough',
      name: 'Yugrow Community Meetup',
      title: 'Yugrow Community Meetup',
      description: 'Monthly community networking event.',
      eventType: 'in-person',
      startDate: '2026-08-20T18:00:00Z',
      venue: { name: 'Yugrow HQ', address: '123 Innovation Drive' },
      attendeeCount: 28,
      hostName: 'Yugrow Team',
      topics: ['Networking', 'Community', 'Yugrow'],
    };

    test('Event page loads with all details', async ({ page }) => {
      await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
        await route.fulfill({
          status: 200,
          contentType: 'application/json',
          body: JSON.stringify(mockEvent),
        });
      });

      await page.goto('/e/evt_walkthrough');

      await expect(page.locator(`text=${mockEvent.name}`)).toBeVisible();
      await expect(page.locator(`text=${mockEvent.description}`)).toBeVisible();
      await expect(page.locator(`text=${mockEvent.venue.name}`)).toBeVisible();
      await expect(page.locator(`text=${mockEvent.hostName}`)).toBeVisible();

      for (const topic of mockEvent.topics) {
        await expect(page.locator(`text=${topic}`).first()).toBeVisible();
      }
    });

    test('Interested button is interactive', async ({ page }) => {
      await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
        await route.fulfill({
          status: 200,
          contentType: 'application/json',
          body: JSON.stringify(mockEvent),
        });
      });

      await page.goto('/e/evt_walkthrough');
      const btn = page.locator('button:has-text("Interested"), button:has-text("☆")').first();
      await expect(btn).toBeVisible();
      await btn.click();
    });

    test('Download CTA is present', async ({ page }) => {
      await page.route(/localhost:\d+\/api\/v1\/checkin\/events\/[^\/]+\/public/, async route => {
        await route.fulfill({
          status: 200,
          contentType: 'application/json',
          body: JSON.stringify(mockEvent),
        });
      });

      await page.goto('/e/evt_walkthrough');
      // Button uses onClick, not <a> tag
      await expect(page.getByRole('button', { name: /install|download|app/i }).first()).toBeVisible();
    });
  });

  test.describe('Step 5: Platform Health', () => {

    test('Health page shows status', async ({ page }) => {
      await page.goto('/health');

      await expect(page.locator('text=Yugrow Web Platform')).toBeVisible();
      await expect(page.locator('text=Running')).toBeVisible();
    });
  });
});
