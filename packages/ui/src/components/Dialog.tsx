'use client';

import React, { useEffect } from 'react';
import { Button } from './Button';

interface DialogProps {
  open: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
  actions?: React.ReactNode;
  size?: 'sm' | 'md' | 'lg';
}

const sizeStyles = {
  sm: 'max-w-sm',
  md: 'max-w-lg',
  lg: 'max-w-2xl',
};

export function Dialog({ open, onClose, title, children, actions, size = 'md' }: DialogProps) {
  useEffect(() => {
    if (open) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => { document.body.style.overflow = ''; };
  }, [open]);

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={onClose} />
      <div className={`
        relative w-full ${sizeStyles[size]} mx-4
        rounded-xl border border-[var(--y-border)] bg-[var(--y-bg)] shadow-xl
        p-6
      `}>
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold text-[var(--y-text-primary)]">{title}</h2>
          <button onClick={onClose} className="text-[var(--y-text-secondary)] hover:text-[var(--y-text-primary)]">
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <div className="text-sm text-[var(--y-text-secondary)]">{children}</div>
        {actions && (
          <div className="flex justify-end gap-3 mt-6">{actions}</div>
        )}
      </div>
    </div>
  );
}
