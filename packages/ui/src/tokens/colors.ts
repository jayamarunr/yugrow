// ─── Yugrow Design Language — Color Tokens ──────────────────────────
// Semantic color tokens. Actual values can evolve without changing components.

export const colorTokens = {
  // Brand
  brand: {
    primary: { light: '#2563EB', dark: '#60A5FA' },       // Trustworthy blue
    secondary: { light: '#7C3AED', dark: '#A78BFA' },      // Intelligent purple
    accent: { light: '#059669', dark: '#34D399' },          // Growth green
  },

  // Surfaces
  surface: {
    background: { light: '#FFFFFF', dark: '#0F172A' },
    card: { light: '#F8FAFC', dark: '#1E293B' },
    elevated: { light: '#FFFFFF', dark: '#334155' },
    modal: { light: '#FFFFFF', dark: '#1E293B' },
  },

  // Text
  text: {
    primary: { light: '#0F172A', dark: '#F1F5F9' },
    secondary: { light: '#475569', dark: '#94A3B8' },
    disabled: { light: '#94A3B8', dark: '#64748B' },
    inverse: { light: '#FFFFFF', dark: '#0F172A' },
  },

  // Borders
  border: {
    default: { light: '#E2E8F0', dark: '#334155' },
    hover: { light: '#CBD5E1', dark: '#475569' },
    focus: { light: '#2563EB', dark: '#60A5FA' },
  },

  // States
  state: {
    success: { light: '#059669', dark: '#34D399' },
    warning: { light: '#D97706', dark: '#FBBF24' },
    error: { light: '#DC2626', dark: '#F87171' },
    info: { light: '#2563EB', dark: '#60A5FA' },
  },

  // Charts & Data Viz
  chart: {
    blue: '#3B82F6',
    purple: '#8B5CF6',
    green: '#10B981',
    orange: '#F59E0B',
    red: '#EF4444',
    pink: '#EC4899',
    teal: '#14B8A6',
    indigo: '#6366F1',
  },
} as const;

export type ColorScheme = 'light' | 'dark';
export type ColorToken = typeof colorTokens;
