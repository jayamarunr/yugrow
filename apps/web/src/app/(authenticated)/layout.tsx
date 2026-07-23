// ─── Authenticated Layout — Platform Shell with Journey Engine ─────

import { Shell, JourneyProvider } from '@ui';

const demoWorkspaces = [
  { id: 'personal', name: 'Personal', type: 'personal' as const },
  { id: 'yugrow', name: 'Yugrow Technologies', type: 'company' as const },
  { id: 'thedataco', name: 'The Data Company', type: 'company' as const },
];

export default function AuthenticatedLayout({ children }: { children: React.ReactNode }) {
  return (
    <JourneyProvider>
      <Shell
        workspaces={demoWorkspaces}
        activeWorkspaceId="yugrow"
      >
        {children}
      </Shell>
    </JourneyProvider>
  );
}
