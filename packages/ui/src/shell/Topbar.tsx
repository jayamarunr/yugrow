'use client';

import React, { useState } from 'react';
import { useTheme } from '../theme';

interface TopbarProps {
  onSearch: (query: string) => void;
  onOpenAssistant: () => void;
}

export function Topbar({ onSearch, onOpenAssistant }: TopbarProps) {
  const { scheme, toggleScheme } = useTheme();
  const [searchFocused, setSearchFocused] = useState(false);

  return (
    <header className="flex items-center h-14 px-4 border-b border-[var(--y-border)] bg-[var(--y-bg)] gap-4">
      {/* Workspace Switcher Trigger */}
      <div className="flex items-center gap-2 min-w-0">
        <div className="w-2 h-2 rounded-full bg-green-500 flex-shrink-0" />
        <span className="text-sm font-medium text-[var(--y-text-primary)] truncate">Yugrow Technologies</span>
        <svg className="w-3.5 h-3.5 text-[var(--y-text-secondary)] flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </div>

      {/* Global Search */}
      <div className="flex-1 max-w-md">
        <div className="relative">
          <svg className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-[var(--y-text-secondary)]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
          <input
            placeholder="Search people, companies, invoices, events..."
            onFocus={() => setSearchFocused(true)}
            onBlur={() => setSearchFocused(false)}
            onChange={(e) => onSearch(e.target.value)}
            className="w-full pl-9 pr-3 py-1.5 text-sm rounded-lg border border-[var(--y-border)] bg-[var(--y-surface)] text-[var(--y-text-primary)] placeholder:text-[var(--y-text-disabled)] focus:outline-none focus:ring-2 focus:ring-[var(--y-brand-primary)] transition-all"
          />
          {searchFocused && (
            <div className="absolute top-full mt-1 left-0 right-0 rounded-lg border border-[var(--y-border)] bg-[var(--y-bg)] shadow-lg p-2 z-40">
              <p className="text-xs text-[var(--y-text-secondary)] p-2">Type to search across all data...</p>
            </div>
          )}
        </div>
      </div>

      {/* Right Actions */}
      <div className="flex items-center gap-2">
        {/* AI Assistant */}
        <button
          onClick={onOpenAssistant}
          className="p-2 rounded-lg text-[var(--y-text-secondary)] hover:bg-[var(--y-surface)] hover:text-[var(--y-text-primary)] transition-colors relative"
          title="AI Assistant"
        >
          <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
          </svg>
        </button>

        {/* Notifications */}
        <button className="p-2 rounded-lg text-[var(--y-text-secondary)] hover:bg-[var(--y-surface)] hover:text-[var(--y-text-primary)] transition-colors relative">
          <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
          </svg>
          <span className="absolute -top-0.5 -right-0.5 w-4 h-4 bg-red-500 text-white text-[9px] font-bold rounded-full flex items-center justify-center">3</span>
        </button>

        {/* Theme Toggle */}
        <button
          onClick={toggleScheme}
          className="p-2 rounded-lg text-[var(--y-text-secondary)] hover:bg-[var(--y-surface)] hover:text-[var(--y-text-primary)] transition-colors"
          title="Toggle theme"
        >
          {scheme === 'light' ? (
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
            </svg>
          ) : (
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
            </svg>
          )}
        </button>

        {/* User Profile */}
        <button className="flex items-center gap-2 p-1.5 rounded-lg hover:bg-[var(--y-surface)] transition-colors">
          <div className="w-7 h-7 rounded-full bg-purple-500 flex items-center justify-center text-white text-xs font-bold">
            J
          </div>
          <svg className="w-3.5 h-3.5 text-[var(--y-text-secondary)]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
          </svg>
        </button>
      </div>
    </header>
  );
}
