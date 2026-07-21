'use client';

// ─── Yugrow Theme Engine ───────────────────────────────────────────
// Runtime theme switching. Supports light/dark mode and workspace branding.

import React, { createContext, useContext, useState, useCallback, useMemo } from 'react';
import { colorTokens, type ColorScheme } from '../tokens';

export interface WorkspaceBranding {
  logo?: string;
  primaryColor?: string;
  favicon?: string;
}

interface ThemeContextValue {
  scheme: ColorScheme;
  branding: WorkspaceBranding;
  toggleScheme: () => void;
  setBranding: (branding: WorkspaceBranding) => void;
  resolveColor: (token: { light: string; dark: string }) => string;
}

const ThemeContext = createContext<ThemeContextValue | null>(null);

export function ThemeProvider({ children, initialScheme = 'light' }: {
  children: React.ReactNode;
  initialScheme?: ColorScheme;
}) {
  const [scheme, setScheme] = useState<ColorScheme>(initialScheme);
  const [branding, setBranding] = useState<WorkspaceBranding>({});

  const toggleScheme = useCallback(() => {
    setScheme((s) => (s === 'light' ? 'dark' : 'light'));
  }, []);

  const resolveColor = useCallback(
    (token: { light: string; dark: string }) => token[scheme],
    [scheme],
  );

  const value = useMemo(() => ({
    scheme,
    branding,
    toggleScheme,
    setBranding,
    resolveColor,
  }), [scheme, branding, toggleScheme, resolveColor]);

  return (
    <ThemeContext.Provider value={value}>
      <div className={`yugrow-theme-${scheme}`}
        style={{
          '--y-brand-primary': branding.primaryColor || colorTokens.brand.primary[scheme],
          '--y-bg': colorTokens.surface.background[scheme],
          '--y-surface': colorTokens.surface.card[scheme],
          '--y-text-primary': colorTokens.text.primary[scheme],
          '--y-text-secondary': colorTokens.text.secondary[scheme],
          '--y-border': colorTokens.border.default[scheme],
        } as React.CSSProperties}
      >
        {children}
      </div>
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const ctx = useContext(ThemeContext);
  if (!ctx) throw new Error('useTheme must be used within ThemeProvider');
  return ctx;
}
