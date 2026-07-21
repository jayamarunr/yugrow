// ─── Empty State Component ──────────────────────────────────────────

import React from 'react';
import { Button } from './Button';

interface EmptyStateProps {
  icon?: React.ReactNode;
  title: string;
  description?: string;
  action?: { label: string; onClick: () => void };
}

export function EmptyState({ icon, title, description, action }: EmptyStateProps) {
  return (
    <div className="flex flex-col items-center justify-center py-16 px-4 text-center">
      {icon && (
        <div className="w-12 h-12 mb-4 text-[var(--y-text-disabled)]">
          {icon}
        </div>
      )}
      <h3 className="text-base font-semibold text-[var(--y-text-primary)]">{title}</h3>
      {description && (
        <p className="mt-1 text-sm text-[var(--y-text-secondary)] max-w-sm">{description}</p>
      )}
      {action && (
        <Button variant="primary" size="sm" onClick={action.onClick} className="mt-4">
          {action.label}
        </Button>
      )}
    </div>
  );
}
