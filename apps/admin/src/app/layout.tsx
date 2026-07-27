import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Yugrow Admin',
  description: 'Yugrow Platform Administration',
};

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
