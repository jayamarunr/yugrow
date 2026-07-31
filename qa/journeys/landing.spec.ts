import { test, expect } from '@playwright/test';

/**
 * Landing Page Journey
 *
 * Covers:
 * - Hero section rendering
 * - Feature cards
 * - How it works section
 * - Professional checklist
 * - CTA buttons
 * - Footer links
 * - Navigation
 */
test.describe('Landing Page Journey', () => {

  test('Hero section renders correctly', async ({ page }) => {
    await page.goto('/');

    // Core hero content — h1 text is split by <br> so use partial match
    await expect(page.getByRole('heading', { name: /professional presence/i })).toBeVisible();
    await expect(page.getByRole('button', { name: 'Download the App' })).toBeVisible();
  });

  test('How It Works section displays 4 steps', async ({ page }) => {
    await page.goto('/');

    const steps = ['Find an Event', 'Check In', 'Meet People', 'Stay Connected'];
    for (const step of steps) {
      await expect(page.locator(`text=${step}`).first()).toBeVisible();
    }
  });

  test('Features grid displays all 6 feature cards', async ({ page }) => {
    await page.goto('/');

    const features = [
      'Discover Events',
      'Check In',
      'Meet Professionals',
      'Connect Instantly',
      'Continue Conversations',
      'Missed Connections',
    ];

    for (const feature of features) {
      await expect(page.locator(`text=${feature}`).first()).toBeVisible();
    }
  });

  test('Built for Professionals checklist is visible', async ({ page }) => {
    await page.goto('/');

    await expect(page.locator('text=Built for Professionals')).toBeVisible();
  });

  test('Footer contains legal links', async ({ page }) => {
    await page.goto('/');

    const footer = page.locator('footer');
    await expect(footer).toBeVisible();

    // Privacy and Terms links exist (even if routes don't yet)
    await expect(footer.locator('a[href="/privacy"]')).toBeVisible();
    await expect(footer.locator('a[href="/terms"]')).toBeVisible();
    await expect(footer.locator('a[href="mailto:hello@yugrow.app"]')).toBeVisible();
  });

  test('Get Started CTA navigates to signup', async ({ page }) => {
    await page.goto('/');

    // The "Sign In" button in the nav and hero use onClick + router.push, not <a> tags
    // Click the "Get Started" nav button
    await page.getByRole('button', { name: 'Get Started' }).first().click();
    await expect(page).toHaveURL(/login\?signup=1/);
  });

  test('Landing page header contains Yugrow branding', async ({ page }) => {
    await page.goto('/');
    // The Yugrow logo is visible in the header
    await expect(page.locator('text=Yugrow').first()).toBeVisible();
  });

  test('Page loads without console errors', async ({ page }) => {
    const consoleErrors: string[] = [];

    page.on('console', (msg) => {
      if (msg.type() === 'error') {
        consoleErrors.push(msg.text());
      }
    });

    await page.goto('/');
    await page.waitForLoadState('networkidle');

    expect(consoleErrors.length).toBe(0);
  });
});
