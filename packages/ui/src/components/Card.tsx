'use client';

import React from 'react';

interface CardProps {
  children: React.ReactNode;
  title?: string;
  subtitle?: string;
  actions?: React.ReactNode;
  padding?: 'sm' | 'md' | 'lg';
  className?: string;
  onClick?: () => void;
  hoverable?: boolean;
}

const paddingStyles = {
  sm: 'p-3',
  md: 'p-4',
  lg: 'p-6',
};

export function Card({
  children,
  title,
  subtitle,
  actions,
  padding = 'md',
  className = '',
  onClick,
  hoverable = false,
}: CardProps) {
  const Component = onClick ? 'button' : 'div';

  return (
    <Component
      onClick={onClick}
      className={`
        rounded-xl border border-[var(--y-border)] bg-[var(--y-surface)]
        ${onClick || hoverable ? 'hover:shadow-md hover:border-[var(--y-border-hover)] transition-all duration-150 cursor-pointer' : ''}
        text-left w-full
        ${paddingStyles[padding]} ${className}
      `}
    >
      {(title || actions) && (
        <div className="flex items-center justify-between mb-3">
          <div>
            {title && <h3 className="text-sm font-semibold text-[var(--y-text-primary)]">{title}</h3>}
            {subtitle && <p className="text-xs text-[var(--y-text-secondary)] mt-0.5">{subtitle}</p>}
          </div>
          {actions && <div className="flex items-center gap-2">{actions}</div>}
        </div>
      )}
      {children}
    </Component>
  );
}
