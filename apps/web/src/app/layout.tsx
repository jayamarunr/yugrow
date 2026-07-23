import type { Metadata } from 'next';
import { ThemeProvider, ToastProvider } from '@ui';
import './globals.css';

export const metadata: Metadata = {
  title: 'Yugrow — Professional Presence Platform',
  description: 'Discover business events, meet professionals around you, and build relationships that started in person.',
  openGraph: {
    title: 'Yugrow — Professional Presence Platform',
    description: 'Discover business events, meet professionals around you, and build relationships that started in person.',
    type: 'website',
  },
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
