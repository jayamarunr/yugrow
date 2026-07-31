/**
 * YDS Tailwind Tokens
 *
 * Single source of truth for Tailwind CSS config.
 * Values must match packages/design-system/lib/src/ exactly.
 *
 * Usage in tailwind.config.js:
 *   const yds = require('./packages/design-system/web/tailwind.tokens');
 *   module.exports = {
 *     theme: { extend: yds },
 *   };
 */

const ydsTokens = {
  fontFamily: {
    sans: ['Inter', 'sans-serif'],
  },
  colors: {
    brand: {
      primary: '#0F8B6D',
      hover: '#0B755C',
      pressed: '#065F46',
      soft: '#E8F8F2',
    },
    surface: {
      DEFAULT: '#FFFFFF',
      elevated: '#FFFFFF',
      hover: '#F8FAFC',
    },
    text: {
      primary: '#0F172A',
      secondary: '#475569',
      disabled: '#94A3B8',
      inverse: '#FFFFFF',
      link: '#0F8B6D',
    },
    border: {
      DEFAULT: '#E2E8F0',
      hover: '#CBD5E1',
      active: '#0F8B6D',
    },
    success: {
      DEFAULT: '#059669',
      soft: '#ECFDF5',
    },
    warning: {
      DEFAULT: '#D97706',
      soft: '#FFFBEB',
    },
    danger: {
      DEFAULT: '#DC2626',
      soft: '#FEF2F2',
    },
    info: '#2563EB',
  },
  spacing: {
    18: '4.5rem',
  },
  borderRadius: {
    xs: '4px',
    sm: '8px',
    md: '12px',
    lg: '14px',
    xl: '16px',
    '2xl': '20px',
  },
  boxShadow: {
    card: '0 1px 3px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.04)',
    elevated: '0 4px 12px rgba(0,0,0,0.05), 0 2px 4px rgba(0,0,0,0.04)',
    dialog: '0 20px 60px rgba(0,0,0,0.08), 0 8px 20px rgba(0,0,0,0.06)',
  },
  transitionDuration: {
    fast: '150ms',
    normal: '250ms',
    slow: '350ms',
  },
  fontSize: {
    hero: ['48px', { lineHeight: '1.1', fontWeight: '700', letterSpacing: '-0.02em' }],
    '2xl': ['32px', { lineHeight: '1.2', fontWeight: '700', letterSpacing: '-0.02em' }],
  },
};

module.exports = ydsTokens;
