'use client';

import React from 'react';
import { Dialog } from '../components/Dialog';
import { Button } from '../components/Button';

interface Workspace {
  id: string;
  name: string;
  type: 'personal' | 'company' | 'brand';
  logo?: string;
}

interface WorkspaceSwitcherProps {
  open: boolean;
  onClose: () => void;
  workspaces: Workspace[];
  activeWorkspaceId: string;
  onSwitch: (workspaceId: string) => void;
}

const typeIcons: Record<string, string> = {
  personal: '\uD83D\uDC64',  // 👤
  company: '\uD83C\uDFE2',   // 🏢
  brand: '\uD83C\uDF1F',     // 🌟
};

export function WorkspaceSwitcher({
  open,
  onClose,
  workspaces,
  activeWorkspaceId,
  onSwitch,
}: WorkspaceSwitcherProps) {
  return (
    <Dialog open={open} onClose={onClose} title="Switch Workspace" size="sm">
      <div className="space-y-1">
        {workspaces.map((ws) => (
          <button
            key={ws.id}
            onClick={() => {
              onSwitch(ws.id);
              onClose();
            }}
            className={`
              w-full flex items-center gap-3 px-3 py-3 rounded-lg text-left transition-colors
              ${ws.id === activeWorkspaceId
                ? 'bg-[var(--y-brand-primary)]/10 border border-[var(--y-brand-primary)]/20'
                : 'hover:bg-[var(--y-surface)] border border-transparent'
              }
            `}
          >
            <span className="text-lg">{typeIcons[ws.type] || '\uD83D\uDCC1'}</span>
            <div className="flex-1 min-w-0">
              <p className="text-sm font-medium text-[var(--y-text-primary)] truncate">{ws.name}</p>
              <p className="text-xs text-[var(--y-text-secondary)] capitalize">{ws.type}</p>
            </div>
            {ws.id === activeWorkspaceId && (
              <svg className="w-4 h-4 text-[var(--y-brand-primary)]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
              </svg>
            )}
          </button>
        ))}
      </div>

      <div className="mt-4 pt-4 border-t border-[var(--y-border)]">
        <Button variant="ghost" size="sm" className="w-full justify-start">
          + Create Workspace
        </Button>
      </div>
    </Dialog>
  );
}
