'use client';

import React, { useState } from 'react';
import { Input } from '../components/Input';
import { Button } from '../components/Button';

interface AssistantPanelProps {
  open: boolean;
  onClose: () => void;
}

const suggestions = [
  'Create a website for my business',
  'Find all invoices due this month',
  'Broadcast a hiring request',
  'Write a blog post about AI',
  'Show me my sales pipeline',
];

export function AssistantPanel({ open, onClose }: AssistantPanelProps) {
  const [query, setQuery] = useState('');

  if (!open) return null;

  return (
    <div className="fixed inset-y-0 right-0 w-96 z-50 border-l border-[var(--y-border)] bg-[var(--y-bg)] shadow-xl flex flex-col">
      {/* Header */}
      <div className="flex items-center justify-between px-4 h-14 border-b border-[var(--y-border)]">
        <div className="flex items-center gap-2">
          <svg className="w-5 h-5 text-[var(--y-brand-primary)]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
          </svg>
          <span className="font-semibold text-sm text-[var(--y-text-primary)]">AI Assistant</span>
        </div>
        <button onClick={onClose} className="p-1 rounded hover:bg-[var(--y-surface)]">
          <svg className="w-5 h-5 text-[var(--y-text-secondary)]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>

      {/* Suggestions */}
      <div className="flex-1 overflow-y-auto p-4">
        <p className="text-xs font-medium text-[var(--y-text-secondary)] uppercase tracking-wider mb-3">Try asking</p>
        <div className="space-y-2">
          {suggestions.map((suggestion) => (
            <button
              key={suggestion}
              onClick={() => setQuery(suggestion)}
              className="w-full text-left p-3 rounded-lg text-sm text-[var(--y-text-secondary)] hover:bg-[var(--y-surface)] hover:text-[var(--y-text-primary)] transition-colors border border-[var(--y-border)]"
            >
              {suggestion}
            </button>
          ))}
        </div>
      </div>

      {/* Input */}
      <div className="p-4 border-t border-[var(--y-border)]">
        <div className="flex gap-2">
          <input
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Ask Yugrow..."
            className="flex-1 rounded-lg border border-[var(--y-border)] bg-[var(--y-surface)] px-3 py-2 text-sm text-[var(--y-text-primary)] placeholder:text-[var(--y-text-disabled)] focus:outline-none focus:ring-2 focus:ring-[var(--y-brand-primary)]"
          />
          <Button size="sm">Ask</Button>
        </div>
      </div>
    </div>
  );
}
