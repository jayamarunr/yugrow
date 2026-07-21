import type { Journey, UserContext } from '../types';

function getSteps(ctx: UserContext) {
  // Experienced user: skip identity setup
  if (!ctx.isNewUser && ctx.hasIdentity && ctx.hasWorkspace) {
    return [
      {
        id: 'create-website',
        title: 'Create your business website',
        description: 'Launch a professional website for your business using one of our templates.',
        platform: 'content-platform' as const,
        status: 'in-progress' as const,
        action: { label: 'Create website', href: '/sites/create' },
        aiPrompt: 'Suggest a website structure for my business.',
        coachTip: 'A professional website is the fastest way to establish credibility. Pick a template that matches your industry.',
        estimatedMinutes: 5,
      },
      {
        id: 'publish-first-page',
        title: 'Publish your first page',
        description: 'Add content to your site and publish it live.',
        platform: 'content-platform' as const,
        status: 'pending' as const,
        dependencies: ['create-website'],
        action: { label: 'Publish page', href: '/sites/pages' },
        coachTip: 'Even a single well-written page is enough to go live. Done is better than perfect.',
        estimatedMinutes: 2,
      },
      {
        id: 'connect-domain',
        title: 'Connect your custom domain',
        description: 'Replace your yugrow.com subdomain with your own domain name.',
        platform: 'content-platform' as const,
        status: 'pending' as const,
        dependencies: ['publish-first-page'],
        action: { label: 'Connect domain', href: '/sites/domain' },
        coachTip: 'A custom domain like yourcompany.com makes your site look professional.',
        estimatedMinutes: 3,
      },
    ];
  }

  // Agency: create a workspace for each client
  if (ctx.role === 'agency') {
    return [
      {
        id: 'create-workspace',
        title: 'Create client workspace',
        description: 'Set up a dedicated workspace for your client.',
        platform: 'platform-core' as const,
        status: 'in-progress' as const,
        action: { label: 'Create workspace', href: '/workspace/create' },
        coachTip: 'Keep each client in their own workspace for clean separation.',
        estimatedMinutes: 2,
      },
      {
        id: 'invite-team',
        title: 'Invite your team',
        description: 'Add team members who will work on this client account.',
        platform: 'platform-core' as const,
        status: 'pending' as const,
        dependencies: ['create-workspace'],
        action: { label: 'Invite team', href: '/workspace/members' },
        estimatedMinutes: 2,
      },
      {
        id: 'create-client-website',
        title: 'Build client website',
        description: 'Create a professional website for your client using AI.',
        platform: 'content-platform' as const,
        status: 'pending' as const,
        dependencies: ['invite-team'],
        action: { label: 'Create website', href: '/sites/create' },
        aiPrompt: 'Generate a website structure for a client in the following industry...',
        coachTip: 'Use AI to generate the initial structure, then customize.',
        estimatedMinutes: 5,
      },
      {
        id: 'publish-client-site',
        title: 'Publish and hand off',
        description: 'Publish the site and grant your client access.',
        platform: 'content-platform' as const,
        status: 'pending' as const,
        dependencies: ['create-client-website'],
        action: { label: 'Publish site', href: '/sites/publish' },
        estimatedMinutes: 2,
      },
    ];
  }

  // Default: new user onboarding
  return [
    {
      id: 'create-workspace',
      title: 'Create your workspace',
      description: 'Your command center for everything in Yugrow.',
      platform: 'platform-core' as const,
      status: 'in-progress' as const,
      action: { label: 'Set up workspace', href: '/workspace/setup' },
      coachTip: 'Your workspace is where all your business activity lives. Name it after your company.',
      estimatedMinutes: 2,
    },
    {
      id: 'create-company',
      title: 'Set up your company profile',
      description: 'Add your company name, description, and logo.',
      platform: 'platform-core' as const,
      status: 'pending' as const,
      dependencies: ['create-workspace'],
      action: { label: 'Create company profile', href: '/company/setup' },
      estimatedMinutes: 3,
    },
    {
      id: 'create-professional-identity',
      title: 'Build your professional identity',
      description: 'Create your digital business card and profile.',
      platform: 'relationship-platform' as const,
      status: 'pending' as const,
      dependencies: ['create-company'],
      action: { label: 'Create profile', href: '/identity/profile' },
      aiPrompt: 'Help me write a professional bio for my Yugrow profile.',
      coachTip: 'A complete profile with photo and bio gets 3x more connection requests.',
      estimatedMinutes: 3,
    },
    {
      id: 'create-website',
      title: 'Create your business website',
      description: 'Launch a professional website from a template.',
      platform: 'content-platform' as const,
      status: 'pending' as const,
      dependencies: ['create-company'],
      action: { label: 'Create website', href: '/sites/create' },
      aiPrompt: 'Suggest a website structure for my business.',
      coachTip: 'AI can generate your entire site from a short description. Try it.',
      estimatedMinutes: 5,
    },
    {
      id: 'publish-first-page',
      title: 'Publish your first page',
      description: 'Go live with your first published page.',
      platform: 'content-platform' as const,
      status: 'pending' as const,
      dependencies: ['create-website'],
      action: { label: 'Publish page', href: '/sites/pages' },
      coachTip: "Your site is live at workspace.yugrow.com. Share the link!",
      estimatedMinutes: 2,
    },
  ];
}

export const startBusinessJourney: Journey = {
  id: 'start-business',
  title: 'Start a Business',
  description: 'Set up your workspace, create your company profile, build your website, and publish your first page.',
  icon: '🚀',
  category: 'onboarding',
  estimatedMinutes: 15,
  achievement: {
    id: 'business-started',
    title: 'Business Started',
    description: 'You set up your business on Yugrow — workspace, identity, and website are live.',
    icon: '🏁',
  },
  contextualize: (ctx: UserContext) => getSteps(ctx),
  steps: getSteps({ isNewUser: true, hasIdentity: false, hasWebsite: false, hasWorkspace: false, hasConnections: false, completedJourneyIds: [] }),
};
