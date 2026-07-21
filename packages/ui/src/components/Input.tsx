'use client';

import React, { forwardRef } from 'react';

interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
  hint?: string;
  icon?: React.ReactNode;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ label, error, hint, icon, className = '', ...props }, ref) => {
    return (
      <div className="flex flex-col gap-1.5">
        {label && (
          <label className="text-sm font-medium text-[var(--y-text-primary)]">
            {label}
          </label>
        )}
        <div className="relative">
          {icon && (
            <div className="absolute left-3 top-1/2 -translate-y-1/2 text-[var(--y-text-secondary)]">
              {icon}
            </div>
          )}
          <input
            ref={ref}
            className={`
              w-full rounded-lg border bg-[var(--y-bg)] text-[var(--y-text-primary)]
              placeholder:text-[var(--y-text-disabled)]
              transition-colors duration-150
              focus:outline-none focus:ring-2 focus:ring-[var(--y-brand-primary)] focus:border-transparent
              disabled:opacity-50 disabled:cursor-not-allowed
              ${icon ? 'pl-10' : 'pl-3'} pr-3 py-2 text-sm
              ${error ? 'border-red-500 focus:ring-red-500' : 'border-[var(--y-border)]'}
              ${className}
            `}
            {...props}
          />
        </div>
        {error && <p className="text-xs text-red-500">{error}</p>}
        {hint && !error && <p className="text-xs text-[var(--y-text-secondary)]">{hint}</p>}
      </div>
    );
  },
);

Input.displayName = 'Input';
