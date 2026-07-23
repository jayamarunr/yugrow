export default function HealthPage() {
    return (<div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', fontFamily: 'system-ui, sans-serif' }}>
      <h1 style={{ fontSize: '2rem', fontWeight: 700 }}>Yugrow Web Platform</h1>
      <p style={{ color: '#22c55e', fontSize: '1.125rem' }}>Status: Running</p>
      <p style={{ color: '#666', marginTop: '0.5rem' }}>
        API: <span id="api-status">Checking...</span>
      </p>
    </div>);
}
//# sourceMappingURL=page.js.map