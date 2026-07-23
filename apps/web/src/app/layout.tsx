import type { Metadata } from 'next';
import { ThemeProvider, ToastProvider } from '@ui';
import './globals.css';

export const metadata: Metadata = {
  title: 'Yugrow — One Platform. Endless Growth.',
  description: 'AI-native business platform that unifies everything a growing business needs.',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body>
        <ThemeProvider>
          <ToastProvider>
            {children}
          </ToastProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
