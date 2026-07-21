'use client';

import React, { useState } from 'react';
import { usePathname } from 'next/navigation';
import { getNavTree, type NavItem } from '../registry/NavigationRegistry';
import { useJourneys } from '../journeys/JourneyProvider';
import { JourneySidebar } from '../journeys/JourneySidebar';
import { getWorkspaceNavTree } from '../registry/NavigationRegistry';

interface SidebarProps {
  onOpenLauncher: () => void;
  onOpenWorkspaceSwitcher: () => void;
  onOpenWelcome?: () => void;
}

export function Sidebar({
  onOpenLauncher,
  onOpenWorkspaceSwitcher,
  onOpenWelcome,
}: SidebarProps) {
  const pathname = usePathname();
  const [collapsed, setCollapsed] = useState(false);
  const navItems = getNavTree();

  const journeyCtx = useJourneys();
  const {
    navMode, toggleNavMode,
    activeJourney,
    state,
    startJourney,
    getAvailableJourneys,
  } = journeyCtx;

  const isActive = (href: string) => pathname?.startsWith(href);

  return (
    <aside
      className={`
        flex flex-col border-r border-[var(--y-border)] bg-[var(--y-bg)] transition-all duration-200
        ${collapsed ? 'w-16' : 'w-56'}
      `}
    >
      {/* Logo */}
      <div className="flex items-center h-14 px-4 border-b border-[var(--y-border)]">
        <div className="flex items-center gap-2 flex-1 min-w-0">
          <div className="w-7 h-7 rounded-lg bg-[var(--y-brand-primary)] flex items-center justify-center text-white font-bold text-xs flex-shrink-0">
            Y
          </div>
          {!collapsed && <span className="font-bold text-sm text-[var(--y-text-primary)] truncate">Yugrow</span>}
        </div>
        <button
          onClick={() => setCollapsed(!collapsed)}
          className="text-[var(--y-text-secondary)] hover:text-[var(--y-text-primary)] flex-shrink-0"
        >
          <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
          </svg>
        </button>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto p-2 space-y-1">
        {/* Journey-aware navigation (shown when not collapsed) */}
        {!collapsed && (
          <div className="mb-2">
            <JourneySidebar
              navMode={navMode}
              onToggleMode={toggleNavMode}
              activeJourneyId={activeJourney?.id ?? null}
              availableJourneys={getAvailableJourneys().map((j) => ({
                id: j.id,
                title: j.title,
                icon: j.icon,
                category: j.category,
              }))}
              completedJourneys={state.completedJourneys}
              onStartJourney={startJourney}
              onOpenWelcome={() => onOpenWelcome?.()}
            />
          </div>
        )}

        {(getWorkspaceNavTree().length > 0 ? getWorkspaceNavTree() : navItems).map((item) => (
          <NavLink key={item.id} item={item} collapsed={collapsed} isActive={isActive(item.href)} />
        ))}

        {/* App Launcher */}
        <button
          onClick={onOpenLauncher}
          className="w-full flex items-center gap-3 px-3 py-2 rounded-lg text-sm text-[var(--y-text-secondary)] hover:bg-[var(--y-surface)] hover:text-[var(--y-text-primary)] transition-colors"
        >
          <svg className="w-5 h-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
          </svg>
          {!collapsed && <span>Apps</span>}
        </button>
      </nav>

      {/* Bottom */}
      <div className="p-2 border-t border-[var(--y-border)]">
        <button
          onClick={onOpenWorkspaceSwitcher}
          className="w-full flex items-center gap-3 px-3 py-2 rounded-lg text-sm text-[var(--y-text-secondary)] hover:bg-[var(--y-surface)] hover:text-[var(--y-text-primary)] transition-colors"
        >
          <div className="w-5 h-5 rounded-full bg-[var(--y-brand-primary)] flex items-center justify-center text-white text-xs font-bold flex-shrink-0">
            W
          </div>
          {!collapsed && (
            <div className="flex-1 text-left min-w-0">
              <p className="text-xs font-medium text-[var(--y-text-primary)] truncate">Workspace</p>
              <p className="text-[10px] truncate">Switch</p>
            </div>
          )}
        </button>
      </div>
    </aside>
  );
}

function NavLink({ item, collapsed, isActive: active }: { item: NavItem; collapsed: boolean; isActive: boolean }) {
  return (
    <a
      href={item.href}
      className={`
        flex items-center gap-3 px-3 py-2 rounded-lg text-sm transition-colors relative
        ${active
          ? 'bg-[var(--y-surface)] text-[var(--y-brand-primary)] font-medium'
          : 'text-[var(--y-text-secondary)] hover:bg-[var(--y-surface)] hover:text-[var(--y-text-primary)]'
        }
      `}
    >
      <span className="w-5 h-5 flex-shrink-0">{item.icon}</span>
      {!collapsed && <span className="truncate">{item.label}</span>}
      {item.badge && (
        <span className="ml-auto bg-red-500 text-white text-[10px] px-1.5 py-0.5 rounded-full">{item.badge}</span>
      )}
    </a>
  );
}
