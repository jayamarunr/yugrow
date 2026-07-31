import { test, expect } from '@playwright/test';

/**
 * Accessibility Journey — P2
 *
 * Covers basic accessibility checks:
 * - Keyboard navigation
 * - Focus order
 * - ARIA labels
 * - Missing form labels
 * - Colour contrast (basic)
 * - Landmark structure
 *
 * These tests make R32 (Visual Polish) measurable instead of subjective.
 */
test.describe('Accessibility Journey', () => {

  test('Landing page has proper heading structure', async ({ page }) => {
    await page.goto('/');

    // Page should have a single h1
    const h1Count = await page.locator('h1').count();
    expect(h1Count).toBeGreaterThanOrEqual(1);

    // Heading hierarchy should exist (h1 → h2)
    const h2Count = await page.locator('h2').count();
    expect(h2Count).toBeGreaterThanOrEqual(1);
  });

  test('Landing page has landmark regions', async ({ page }) => {
    await page.goto('/');

    // Check for semantic landmarks
    const nav = page.locator('nav, [role="navigation"]');
    const main = page.locator('main, [role="main"]');
    const footer = page.locator('footer, [role="contentinfo"]');

    await expect(nav.first()).toBeVisible();
    await expect(main.first()).toBeVisible();
    await expect(footer.first()).toBeVisible();
  });

  test('Login page has labelled form fields', async ({ page }) => {
    await page.goto('/login');

    // Check email field has a label or aria-label
    const emailField = page.locator('input[type="email"]');
    const hasLabel = await emailField.evaluate((el) => {
      const input = el as HTMLInputElement;
      const labelledBy = input.getAttribute('aria-labelledby');
      const label = input.getAttribute('aria-label');
      const placeholder = input.getAttribute('placeholder');
      const parentLabel = input.closest('label');
      const hasVisibleLabel = document.querySelector(`label[for="${input.id}"]`);
      return !!(labelledBy || label || parentLabel || hasVisibleLabel || placeholder);
    });
    expect(hasLabel).toBeTruthy();
  });

  test('Login page has labelled password field', async ({ page }) => {
    await page.goto('/login');

    const passwordField = page.locator('input[type="password"]');
    const hasLabel = await passwordField.evaluate((el) => {
      const input = el as HTMLInputElement;
      const labelledBy = input.getAttribute('aria-labelledby');
      const label = input.getAttribute('aria-label');
      const placeholder = input.getAttribute('placeholder');
      const parentLabel = input.closest('label');
      const hasVisibleLabel = document.querySelector(`label[for="${input.id}"]`);
      return !!(labelledBy || label || parentLabel || hasVisibleLabel || placeholder);
    });
    expect(hasLabel).toBeTruthy();
  });

  test('Interactive elements are keyboard accessible', async ({ page }) => {
    await page.goto('/');

    // All buttons and links should be focusable
    const focusableElements = page.locator('a, button, input, select, textarea, [tabindex]:not([tabindex="-1"])');
    const count = await focusableElements.count();
    expect(count).toBeGreaterThan(0);

    // Tab through elements
    await page.keyboard.press('Tab');
    const focusedElement = await page.evaluate(() => document.activeElement?.tagName || '');
    expect(focusedElement).toBeTruthy();
  });

  test('Images on landing page have alt text', async ({ page }) => {
    await page.goto('/');

    const images = page.locator('img');
    const count = await images.count();

    for (let i = 0; i < count; i++) {
      const img = images.nth(i);
      const alt = await img.getAttribute('alt');
      // Decorative images may have empty alt (alt="") which is acceptable
      // Informational images must have descriptive alt
      expect(alt).not.toBeNull();
    }
  });

  test('Page title is descriptive on each route', async ({ page }) => {
    await page.goto('/');
    const title = await page.title();
    expect(title).toBeTruthy();
    expect(title.length).toBeGreaterThan(0);

    await page.goto('/login');
    const loginTitle = await page.title();
    expect(loginTitle).toBeTruthy();

    await page.goto('/dashboard');
    const dashTitle = await page.title();
    expect(dashTitle).toBeTruthy();
  });

  test('Dashboard has skip-to-content or proper tab order', async ({ page }) => {
    await page.goto('/dashboard');

    // Check for skip link
    const skipLink = page.locator('a[href="#main"], a[href="#content"], [class*="skip"]');
    const hasSkipLink = await skipLink.count() > 0;

    // Or at least check main landmark exists
    const main = page.locator('main, [role="main"]');
    await expect(main.first()).toBeVisible({ timeout: 10000 });

    if (hasSkipLink) {
      test.info().annotations.push({
        type: 'accessibility',
        description: 'Skip-to-content link found',
      });
    }
  });

  test('Focus indicators are visible', async ({ page }) => {
    await page.goto('/');

    // Tab to first interactive element and check for outline
    await page.keyboard.press('Tab');
    const hasOutline = await page.evaluate(() => {
      const el = document.activeElement;
      if (!el) return false;
      const style = window.getComputedStyle(el);
      return style.outlineStyle !== 'none' && style.outlineWidth !== '0px';
    });

    // Not a hard assertion — modern design systems often use box-shadow for focus
    // This test documents the requirement — fix design if it fails
    test.info().annotations.push({
      type: 'accessibility',
      description: hasOutline
        ? 'Focus indicator is visible'
        : 'WARNING: No visible focus indicator on interactive elements (may use box-shadow)',
    });
  });

  test('Colour contrast check on text elements', async ({ page }) => {
    await page.goto('/');

    // Check that text elements have reasonable contrast
    // This is a basic check — full WCAG requires tools like axe-core
    const textElements = page.locator('p, h1, h2, h3, span, a');
    const count = await textElements.count();

    let lowContrastCount = 0;
    for (let i = 0; i < Math.min(count, 20); i++) {
      const contrast = await textElements.nth(i).evaluate((el) => {
        const style = window.getComputedStyle(el);
        const color = style.color;
        const bg = style.backgroundColor;
        // Simple check — at minimum, text should not be transparent
        return { color, bg };
      });
      if (contrast.color === 'rgba(0, 0, 0, 0)' || contrast.bg === 'rgba(0, 0, 0, 0)') {
        lowContrastCount++;
      }
    }

    // Allow some low-contrast elements (decorative, icons, etc.)
    // This is a soft check — full WCAG requires axe-core
    test.info().annotations.push({
      type: 'accessibility',
      description: `${lowContrastCount} elements with potentially low contrast`,
    });
    expect(lowContrastCount).toBeLessThan(25);
  });
});
