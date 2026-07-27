/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          primary: '#0F766E',
          secondary: '#4338CA',
          accent: '#EA580C',
        },
      },
    },
  },
  plugins: [],
}

