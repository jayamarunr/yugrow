// ─── Authenticated Layout — Platform Shell with Journey Engine ─────
import { Shell, JourneyProvider } from '@ui';
const demoWorkspaces = [
    { id: 'personal', name: 'Personal', type: 'personal' },
    { id: 'yugrow', name: 'Yugrow Technologies', type: 'company' },
    { id: 'thedataco', name: 'The Data Company', type: 'company' },
];
export default function AuthenticatedLayout({ children }) {
    return (<JourneyProvider>
      <Shell workspaces={demoWorkspaces} activeWorkspaceId="yugrow">
        {children}
      </Shell>
    </JourneyProvider>);
}
//# sourceMappingURL=layout.js.map