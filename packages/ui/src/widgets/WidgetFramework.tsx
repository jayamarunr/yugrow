// ─── Widget Framework ───────────────────────────────────────────────
// Products register widgets. Dashboards are composed from registered widgets.

'use client';

import React from 'react';
import { Card } from '../components/Card';

export interface WidgetDefinition {
  id: string;
  title: string;
  description?: string;
  component: React.ComponentType<any>;
  defaultWidth?: 'full' | 'half' | 'third';
  defaultHeight?: 'sm' | 'md' | 'lg';
  requiredCapability?: string;
}

const widgetRegistry = new Map<string, WidgetDefinition>();

export function registerWidget(widget: WidgetDefinition) {
  widgetRegistry.set(widget.id, widget);
}

export function getWidget(id: string): WidgetDefinition | undefined {
  return widgetRegistry.get(id);
}

export function getAllWidgets(): WidgetDefinition[] {
  return Array.from(widgetRegistry.values());
}

// ─── Dashboard Grid ────────────────────────────────────────────────

interface DashboardGridProps {
  widgets: Array<{ id: string; props?: any }>;
}

const widthClasses = {
  full: 'col-span-full',
  half: 'col-span-2',
  third: 'col-span-1',
};

export function DashboardGrid({ widgets }: DashboardGridProps) {
  return (
    <div className="grid grid-cols-3 gap-4">
      {widgets.map(({ id, props }) => {
        const def = getWidget(id);
        if (!def) return null;
        const width = widthClasses[def.defaultWidth || 'full'];
        return (
          <div key={id} className={width}>
            <Card title={def.title} padding="md">
              <def.component {...props} />
            </Card>
          </div>
        );
      })}
    </div>
  );
}
