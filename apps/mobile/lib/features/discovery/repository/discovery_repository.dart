import 'package:flutter/foundation.dart';
import '../models/professional.dart';

class DiscoveryRepository {
  Future<List<Professional>> getProfessionals() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      const Professional(
        id: 'p-001', name: 'Rajesh Kumar', title: 'Founder & CEO',
        company: 'Kovai Automation', industry: 'Manufacturing',
        mutualConnections: 4, relevanceReason: '4 mutual connections',
        isRecentlyArrived: true, minutesAgo: 1,
        about: 'Built Kovai Automation from a garage workshop to a 200-employee manufacturing technology company. Passionate about Industry 4.0 and smart factory solutions.',
        skills: ['Industrial Automation', 'Lean Manufacturing', 'Supply Chain'],
        lookingFor: 'Automation partners, distributors in South India',
        recentActivity: 'Posted about smart factory ROI at Manufacturing Expo',
      ),
      const Professional(
        id: 'p-002', name: 'Priya Srinivasan', title: 'HR Director',
        company: 'Zoho Corporation', industry: 'Technology',
        mutualConnections: 3, relevanceReason: 'Hiring',
        isRecentlyArrived: true, minutesAgo: 3,
        about: 'Leading talent acquisition at Zoho. Building engineering teams across Chennai and Bangalore.',
        skills: ['Talent Acquisition', 'HR Strategy', 'Organizational Design'],
        lookingFor: 'Engineering talent, HR tech partners',
        recentActivity: 'Hiring for 12 engineering roles this quarter',
      ),
      const Professional(
        id: 'p-003', name: 'Arun Prasad', title: 'Industrial Designer',
        company: 'DesignCraft Studio', industry: 'Design',
        mutualConnections: 2, relevanceReason: 'Same industry',
        minutesAgo: 5,
        about: 'Product design consultant with 15 years in consumer electronics and industrial equipment.',
        skills: ['Product Design', 'CAD/CAM', 'Prototyping'],
        lookingFor: 'Manufacturing partners, new clients in medical devices',
        recentActivity: 'Showcased new ergonomic tool range at Expo',
      ),
      const Professional(
        id: 'p-004', name: 'Lakshmi Nair', title: 'Supply Chain Head',
        company: 'Ashok Leyland', industry: 'Automotive',
        mutualConnections: 5, relevanceReason: '5 mutual connections',
        minutesAgo: 8,
        about: '20+ years optimizing supply chains for one of India\'s largest commercial vehicle manufacturers.',
        skills: ['Logistics', 'Procurement', 'Warehouse Optimization'],
        lookingFor: 'Logistics tech providers, warehouse automation',
        recentActivity: 'Exploring EV supply chain partnerships',
      ),
      const Professional(
        id: 'p-005', name: 'Suresh Patel', title: 'Angel Investor',
        company: 'Patel Ventures', industry: 'Finance',
        mutualConnections: 2, relevanceReason: 'Invests in your industry',
        minutesAgo: 12,
        about: 'Early-stage investor focused on manufacturing, deep tech, and climate solutions. Portfolio includes 12 startups.',
        skills: ['Venture Capital', 'Mentoring', 'Go-to-Market Strategy'],
        lookingFor: 'Promising startups in manufacturing and climate tech',
        recentActivity: 'Closed 2 investments this quarter',
      ),
      const Professional(
        id: 'p-006', name: 'Deepa Iyer', title: 'Export Manager',
        company: 'Tata Textiles', industry: 'Textiles',
        mutualConnections: 1, relevanceReason: 'International trade',
        minutesAgo: 15,
        about: 'Managing exports to 18 countries. Specializing in sustainable textile supply chains.',
        skills: ['International Trade', 'Supply Chain', 'Sustainability'],
        lookingFor: 'European and US buyers, logistics partners',
        recentActivity: 'Secured 3 new international contracts this month',
      ),
      const Professional(
        id: 'p-007', name: 'Vikram Rathore', title: 'Robotics Engineer',
        company: 'Gridbots Technologies', industry: 'Robotics',
        mutualConnections: 3, relevanceReason: '3 mutual connections',
        minutesAgo: 18,
        about: 'Building industrial robotics solutions for SMEs. Awarded "Most Innovative Startup" at Gujarat Robotics Summit.',
        skills: ['Robotics', 'AI/ML', 'Embedded Systems'],
        lookingFor: 'Manufacturing clients, distribution partners',
        recentActivity: 'Launched new low-cost robotic arm for SMEs',
      ),
      const Professional(
        id: 'p-008', name: 'Ananya Gupta', title: 'Product Manager',
        company: 'Freshworks', industry: 'Technology',
        mutualConnections: 6, relevanceReason: '6 mutual connections',
        minutesAgo: 22,
        about: 'Product leader building B2B SaaS products used by thousands of businesses globally.',
        skills: ['Product Strategy', 'SaaS', 'User Research'],
        lookingFor: 'Design partners, product managers, tech vendors',
        recentActivity: 'Shipping major product update next quarter',
      ),
      const Professional(
        id: 'p-009', name: 'Karthik Subramanian', title: 'Manufacturing Director',
        company: 'Hyundai Motor India', industry: 'Automotive',
        mutualConnections: 0, relevanceReason: 'Senior manufacturing leader',
        minutesAgo: 25,
        about: 'Overseeing production operations at one of India\'s largest automotive plants.',
        skills: ['Operations', 'Lean Six Sigma', 'Plant Management'],
        lookingFor: 'Automation vendors, process improvement consultants',
        recentActivity: 'Implementing Industry 4.0 at Chennai plant',
      ),
      const Professional(
        id: 'p-010', name: 'Meera Joshi', title: 'Startup Consultant',
        company: 'iDatalabs', industry: 'Technology',
        mutualConnections: 2, relevanceReason: 'Works with founders',
        minutesAgo: 30,
        about: 'Helping early-stage startups find product-market fit and raise their first rounds.',
        skills: ['Go-to-Market', 'Fundraising', 'Product Strategy'],
        lookingFor: 'Founders building in B2B SaaS and deeptech',
        recentActivity: 'Advised 5 startups that raised seed rounds this year',
      ),
      const Professional(
        id: 'p-011', name: 'Ravi Deshmukh', title: 'CEO',
        company: 'SolarGrid Energy', industry: 'Energy',
        mutualConnections: 1, relevanceReason: 'Renewable energy',
        minutesAgo: 35,
        about: 'Building India\'s largest rooftop solar network for industrial and commercial buildings.',
        skills: ['Renewable Energy', 'Business Development', 'Project Finance'],
        lookingFor: 'Industrial clients, EPC partners, investors',
        recentActivity: 'Crossed 100 MW installed capacity',
      ),
      const Professional(
        id: 'p-012', name: 'Nandita Reddy', title: 'AI Research Lead',
        company: 'Microsoft India', industry: 'Technology',
        mutualConnections: 4, relevanceReason: 'AI focus',
        minutesAgo: 40,
        about: 'Leading applied AI research at Microsoft India. Focus on responsible AI and healthcare applications.',
        skills: ['Machine Learning', 'NLP', 'Computer Vision'],
        lookingFor: 'Healthcare partners, academic collaborators',
        recentActivity: 'Published research on AI diagnostics for rural healthcare',
      ),
      const Professional(
        id: 'p-013', name: 'Ganesh Rao', title: 'Logistics Director',
        company: 'DTDC Express', industry: 'Logistics',
        mutualConnections: 0, relevanceReason: 'Supply chain expertise',
        minutesAgo: 45,
        about: 'Transforming last-mile logistics with technology-driven solutions across 2,000+ pin codes.',
        skills: ['Logistics', 'Warehousing', 'Tech Integration'],
        lookingFor: 'E-commerce platforms, automation solutions',
        recentActivity: 'Launched same-day delivery in 12 new cities',
      ),
      const Professional(
        id: 'p-014', name: 'Swati Menon', title: 'Chief People Officer',
        company: 'BYJU\'s', industry: 'Education',
        mutualConnections: 2, relevanceReason: 'Hiring across roles',
        minutesAgo: 50,
        about: 'Building people strategies for one of India\'s largest edtech companies with 20,000+ employees.',
        skills: ['People Operations', 'Culture Building', 'Leadership Development'],
        lookingFor: 'HR tech vendors, talent partners, leadership coaches',
        recentActivity: 'Rolling out new L&D platform for 5000+ managers',
      ),
      const Professional(
        id: 'p-015', name: 'Aditya Shah', title: 'Founder',
        company: 'Shah Capital', industry: 'Finance',
        mutualConnections: 3, relevanceReason: 'Actively investing',
        isRecentlyArrived: true, minutesAgo: 2,
        about: 'Second-generation investor with a focus on manufacturing, logistics, and climate technology.',
        skills: ['Investment Analysis', 'Portfolio Management', 'Mentoring'],
        lookingFor: 'High-growth companies in manufacturing and climate',
        recentActivity: 'Led Series A for an industrial robotics startup',
      ),
    ];
  }

  /// Simulate a heartbeat — returns new arrivals since last check
  Future<List<Professional>> getNewArrivals() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const Professional(
        id: 'p-016', name: 'Ananya Sharma', title: 'VP Engineering',
        company: 'Razorpay', industry: 'Technology',
        mutualConnections: 2, relevanceReason: 'Fintech leader',
        isRecentlyArrived: true, minutesAgo: 0,
      ),
    ];
  }
}
