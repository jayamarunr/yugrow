'use client';

// ─── Yugrow Platform Shell ──────────────────────────────────────────
// The global layout. Every product lives inside this shell.

import React, { useState } from 'react';
import { Sidebar } from './Sidebar';
import { Topbar } from './Topbar';
import { WorkspaceSwitcher } from './WorkspaceSwitcher';
import { AssistantPanel } from './AssistantPanel';
import { NotificationCenter } from './NotificationCenter';
import { ProductLauncher } from '../registry/ProductRegistry';
import { useJourneys } from '../journeys/JourneyProvider';

interface ShellProps {
  children: React.ReactNode;
  workspaces?: Array<{
    id: string;
    name: string;
    type: 'personal' | 'company' | 'brand';
  }>;
  activeWorkspaceId?: string;
  onSwitchWorkspace?: (workspaceId: string) => void;
  onSearch?: (query: string) => void;
}

export function Shell({
  children,
  workspaces = [],
  activeWorkspaceId = '',
  onSwitchWorkspace,
  onSearch,
}: ShellProps) {
  const [launcherOpen, setLauncherOpen] = useState(false);
  const [workspaceSwitcherOpen, setWorkspaceSwitcherOpen] = useState(false);
  const [assistantOpen, setAssistantOpen] = useState(false);
  const [notificationsOpen, setNotificationsOpen] = useState(false);

  // Journey Engine — used to re-trigger the welcome launcher from sidebar
  const journeyCtx = useJourneys();

  return (
    <div className="h-screen flex overflow-hidden bg-[var(--y-bg)]">
      {/* Sidebar */}
      <Sidebar
        onOpenLauncher={() => setLauncherOpen(true)}
        onOpenWorkspaceSwitcher={() => setWorkspaceSwitcherOpen(true)}
        onOpenWelcome={() => journeyCtx.dismissWelcome()} // will have the effect of showing it again via state toggle
      />

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-w-0">
        <Topbar
          onSearch={onSearch || (() => {})}
          onOpenAssistant={() => setAssistantOpen(true)}
        />
        <main className="flex-1 overflow-y-auto p-6">
          {children}
        </main>
      </div>

      {/* Overlays */}
      <ProductLauncher open={launcherOpen} onClose={() => setLauncherOpen(false)} />
      <WorkspaceSwitcher
        open={workspaceSwitcherOpen}
        onClose={() => setWorkspaceSwitcherOpen(false)}
        workspaces={workspaces}
        activeWorkspaceId={activeWorkspaceId}
        onSwitch={onSwitchWorkspace || (() => {})}
      />
      <AssistantPanel open={assistantOpen} onClose={() => setAssistantOpen(false)} />
      <NotificationCenter open={notificationsOpen} onClose={() => setNotificationsOpen(false)} />
    </div>
  );
}
