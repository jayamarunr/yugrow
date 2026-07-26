// ─── OnboardingScreen ─────────────────────────────────────────
// 3-step onboarding wizard after signup.
// Step 1: Photo + Name (mandatory)
// Step 2: Company + Role (mandatory)
// Step 3: City + Interests (optional — can skip)
//
// After completion, saves to professional identity and redirects home.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;

  // Step 1
  final _nameCtrl = TextEditingController();
  String? _photoBase64;

  // Step 2
  final _companyCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();

  // Step 3 (optional)
  final _cityCtrl = TextEditingController();
  final Set<String> _interests = {};

  bool _saving = false;

  static const _interestOptions = [
    'Technology', 'AI/ML', 'SaaS', 'Startups', 'Design',
    'Marketing', 'Finance', 'Healthcare', 'EdTech', 'E-commerce',
    'Manufacturing', 'Legal', 'HR', 'Sales',
  ];

  @override
  void initState() {
    super.initState();
    final person = ref.read(authProvider).person;
    if (person != null) {
      _nameCtrl.text = person['name'] as String? ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _companyCtrl.dispose();
    _roleCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  bool get _canProceedFromStep1 =>
      _nameCtrl.text.trim().isNotEmpty;

  bool get _canProceedFromStep2 =>
      _companyCtrl.text.trim().isNotEmpty &&
      _roleCtrl.text.trim().isNotEmpty;

  Future<void> _finish() async {
    setState(() => _saving = true);
    await ref.read(authProvider.notifier).completeOnboarding(
      headline: '${_roleCtrl.text.trim()} at ${_companyCtrl.text.trim()}',
      company: _companyCtrl.text.trim(),
      designation: _roleCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
    );
    if (mounted) context.go('/');
  }

  void _next() {
    if (_step == 0 && !_canProceedFromStep1) return;
    if (_step == 1 && !_canProceedFromStep2) return;
    setState(() => _step++);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastStep = _step == 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_step + 1} of 3'),
        leading: _step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _step--),
              )
            : null,
        actions: isLastStep
            ? [
                TextButton(
                  onPressed: _saving ? null : _finish,
                  child: const Text('Skip'),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_step + 1) / 3,
                  minHeight: 6,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 32),

              // Step content
              Expanded(child: _buildStep(theme)),

              // Bottom button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _saving
                      ? null
                      : isLastStep
                          ? _finish
                          : _next,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          isLastStep ? 'Done' : 'Continue',
                          style: const TextStyle(fontSize: 15),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(ThemeData theme) {
    switch (_step) {
      case 0:
        return _buildStep1(theme);
      case 1:
        return _buildStep2(theme);
      case 2:
        return _buildStep3(theme);
      default:
        return const SizedBox();
    }
  }

  // ── Step 1: Photo + Name (mandatory) ─────────────────────────
  Widget _buildStep1(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What should we call you?',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 24),
        Center(
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Photo picker coming soon'),
                    duration: Duration(seconds: 1)),
              );
            },
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Colors.grey[200],
              child: _photoBase64 != null
                  ? ClipOval(
                      child: Image.network(_photoBase64!, fit: BoxFit.cover,
                          width: 96, height: 96,
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.person, size: 40, color: Colors.grey[400])))
                  : Icon(Icons.person_add, size: 36, color: Colors.grey[400]),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text('Add photo (optional)',
              style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _nameCtrl,
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Full Name *',
            prefixIcon: const Icon(Icons.person_outlined, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        if (!_canProceedFromStep1)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('Name is required to continue',
                style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          ),
      ],
    );
  }

  // ── Step 2: Company + Role (mandatory) ────────────────────────
  Widget _buildStep2(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Where do you work?',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text('This helps people know who you are at events.',
            style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        const SizedBox(height: 24),
        TextFormField(
          controller: _companyCtrl,
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Company *',
            hintText: 'e.g. Yugrow',
            prefixIcon: const Icon(Icons.business_outlined, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _roleCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Designation *',
            hintText: 'e.g. Founder',
            prefixIcon: const Icon(Icons.work_outlined, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        if (!_canProceedFromStep2)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('Company and designation are required to continue',
                style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          ),
      ],
    );
  }

  // ── Step 3: City + Interests (optional — skip available) ────
  Widget _buildStep3(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Anything else?',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text('These are optional. You can always update them later.',
            style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        const SizedBox(height: 24),
        TextFormField(
          controller: _cityCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'City (optional)',
            hintText: 'e.g. Chennai',
            prefixIcon: const Icon(Icons.location_city, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 20),
        Text('Interests (optional)',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[700])),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _interestOptions.map((interest) {
                final selected = _interests.contains(interest);
                return FilterChip(
                  label: Text(interest, style: const TextStyle(fontSize: 13)),
                  selected: selected,
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        _interests.add(interest);
                      } else {
                        _interests.remove(interest);
                      }
                    });
                  },
                  selectedColor: const Color(0xFF0F766E).withValues(alpha: 0.15),
                  checkmarkColor: const Color(0xFF0F766E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(
                    color: selected ? const Color(0xFF0F766E) : Colors.grey[300]!,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
