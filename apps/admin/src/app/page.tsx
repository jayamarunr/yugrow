'use client';

export default function AdminDashboard() {
  return (
    <div style={{ padding: '2rem', fontFamily: 'system-ui, sans-serif' }}>
      <h1 style={{ fontSize: '1.5rem', fontWeight: 600, marginBottom: '0.5rem' }}>
        Yugrow Admin
      </h1>
      <p style={{ color: '#666', marginBottom: '2rem' }}>
        Platform Administration Dashboard
      </p>

      <div style={{ display: 'grid', gap: '1rem', maxWidth: '600px' }}>
        <Card title="Products" description="Manage platform products, plans, and feature flags" />
        <Card title="Users & Workspaces" description="Manage users, workspaces, and memberships" />
        <Card title="Permissions" description="Configure roles, capabilities, and access control" />
        <Card title="Audit Log" description="View platform audit trail and security events" />
        <Card title="System Health" description="Monitor services, queues, and infrastructure" />
      </div>
    </div>
  );
}

function Card({ title, description }: { title: string; description: string }) {
  return (
    <div
      style={{
        padding: '1.25rem',
        border: '1px solid #e5e7eb',
        borderRadius: '8px',
        cursor: 'pointer',
        transition: 'box-shadow 0.2s',
      }}
      onMouseEnter={(e) => (e.currentTarget.style.boxShadow = '0 2px 8px rgba(0,0,0,0.08)')}
      onMouseLeave={(e) => (e.currentTarget.style.boxShadow = 'none')}
    >
      <h2 style={{ fontSize: '1rem', fontWeight: 600, marginBottom: '0.25rem' }}>{title}</h2>
      <p style={{ fontSize: '0.875rem', color: '#666', margin: 0 }}>{description}</p>
    </div>
  );
}
