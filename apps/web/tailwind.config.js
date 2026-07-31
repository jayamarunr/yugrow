/** @type {import('tailwindcss').Config} */
const yds = require('../../packages/design-system/web/tailwind.tokens');

module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: yds,
  },
  plugins: [],
}

