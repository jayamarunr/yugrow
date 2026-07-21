'use client';

import React from 'react';
import { Dialog } from '../components/Dialog';

interface Notification {
  id: string;
  title: string;
  message: string;
  time: string;
  read: boolean;
  product: string;
}

interface NotificationCenterProps {
  open: boolean;
  onClose: () => void;
  notifications?: Notification[];
}

const defaultNotifications: Notification[] = [
  { id: '1', title: 'New lead assigned', message: 'John Doe was assigned to your pipeline', time: '2m ago', read: false, product: 'CRM' },
  { id: '2', title: 'Invoice overdue', message: 'Invoice #INV-2024-089 is 3 days overdue', time: '1h ago', read: false, product: 'Finance' },
  { id: '3', title: 'Broadcast response', message: '3 people responded to your hiring request', time: '3h ago', read: false, product: 'Broadcast' },
];

export function NotificationCenter({ open, onClose, notifications = defaultNotifications }: NotificationCenterProps) {
  const unread = notifications.filter((n) => !n.read).length;

  return (
    <Dialog open={open} onClose={onClose} title={`Notifications (${unread})`} size="md">
      <div className="space-y-1 -mx-2">
        {notifications.map((n) => (
          <div
            key={n.id}
            className={`flex gap-3 p-3 rounded-lg ${!n.read ? 'bg-[var(--y-surface)]' : ''}`}
          >
            <div className={`w-2 h-2 rounded-full mt-1.5 flex-shrink-0 ${!n.read ? 'bg-[var(--y-brand-primary)]' : 'bg-transparent'}`} />
            <div className="flex-1 min-w-0">
              <div className="flex items-center justify-between">
                <p className="text-sm font-medium text-[var(--y-text-primary)]">{n.title}</p>
                <span className="text-[10px] text-[var(--y-text-secondary)]">{n.time}</span>
              </div>
              <p className="text-xs text-[var(--y-text-secondary)] mt-0.5">{n.message}</p>
              <span className="text-[10px] text-[var(--y-brand-primary)] mt-1 inline-block">{n.product}</span>
            </div>
          </div>
        ))}
      </div>
    </Dialog>
  );
}
