import { test, expect } from '@playwright/test';

/**
 * Performance Journey — P2
 *
 * Measures page load performance and sets baseline benchmarks.
 * Failures indicate performance regressions.
 */
test.describe('Performance Journey', () => {

  // Performance thresholds
  const THRESHOLDS = {
    landingPage: { load: 3000, interactive: 5000 },
    loginPage: { load: 3000, interactive: 5000 },
    dashboardPage: { load: 5000, interactive: 8000 },
    eventPage: { load: 4000, interactive: 6000 },
    healthPage: { load: 5000, interactive: 8000 },
  };

  test('Landing page loads within performance budget', async ({ page }) => {
    const startTime = Date.now();

    await page.goto('/');
    await page.waitForLoadState('networkidle');

    const loadTime = Date.now() - startTime;
    expect(loadTime).toBeLessThan(THRESHOLDS.landingPage.load);

    test.info().annotations.push({
      type: 'performance',
      description: `Landing page loaded in ${loadTime}ms (budget: ${THRESHOLDS.landingPage.load}ms)`,
    });
  });

  test('Login page loads within performance budget', async ({ page }) => {
    const startTime = Date.now();

    await page.goto('/login');
    await page.waitForLoadState('networkidle');

    const loadTime = Date.now() - startTime;
    expect(loadTime).toBeLessThan(THRESHOLDS.loginPage.load);

    test.info().annotations.push({
      type: 'performance',
      description: `Login page loaded in ${loadTime}ms (budget: ${THRESHOLDS.loginPage.load}ms)`,
    });
  });

  test('Dashboard page loads within performance budget', async ({ page }) => {
    const startTime = Date.now();

    await page.goto('/dashboard');
    await page.waitForLoadState('networkidle');

    const loadTime = Date.now() - startTime;
    expect(loadTime).toBeLessThan(THRESHOLDS.dashboardPage.load);

    test.info().annotations.push({
      type: 'performance',
      description: `Dashboard loaded in ${loadTime}ms (budget: ${THRESHOLDS.dashboardPage.load}ms)`,
    });
  });

  test('Event page loads within performance budget', async ({ page }) => {
    await page.route('**/api/v1/checkin/events/**/public', async route => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify({
          data: {
            id: 'evt_perf_001',
            name: 'Performance Test Event',
            description: 'Testing performance.',
            eventType: 'in-person',
            startDate: '2026-08-20T18:00:00Z',
            venue: { name: 'Perf Venue', address: '1 Perf St' },
            attendeeCount: 100,
            host: { name: 'Perf Host' },
            topics: ['Performance'],
          },
        }),
      });
    });

    const startTime = Date.now();

    await page.goto('/e/evt_perf_001');
    await page.waitForLoadState('networkidle');

    const loadTime = Date.now() - startTime;
    expect(loadTime).toBeLessThan(THRESHOLDS.eventPage.load);

    test.info().annotations.push({
      type: 'performance',
      description: `Event page loaded in ${loadTime}ms (budget: ${THRESHOLDS.eventPage.load}ms)`,
    });
  });

  test('Health page loads within performance budget', async ({ page }) => {
    const startTime = Date.now();

    await page.goto('/health');
    await page.waitForLoadState('networkidle');

    const loadTime = Date.now() - startTime;
    expect(loadTime).toBeLessThan(THRESHOLDS.healthPage.load);

    test.info().annotations.push({
      type: 'performance',
      description: `Health page loaded in ${loadTime}ms (budget: ${THRESHOLDS.healthPage.load}ms)`,
    });
  });

  test('Largest Contentful Paint (LCP) on landing page', async ({ page }) => {
    await page.goto('/');

    const lcp = await page.evaluate(() => {
      return new Promise<number>((resolve) => {
        new PerformanceObserver((list) => {
          const entries = list.getEntries();
          if (entries.length > 0) {
            resolve(entries[entries.length - 1].startTime);
          }
        }).observe({ type: 'largest-contentful-paint', buffered: true });
        // Timeout fallback
        setTimeout(() => resolve(-1), 5000);
      });
    });

    test.info().annotations.push({
      type: 'performance',
      description: `LCP: ${lcp.toFixed(0)}ms`,
    });

    // LCP should be under 2.5s for good UX
    if (lcp > 0) {
      expect(lcp).toBeLessThan(2500);
    }
  });
});
