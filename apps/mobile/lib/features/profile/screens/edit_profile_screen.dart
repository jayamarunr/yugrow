// ─── EditProfileScreen ─────────────────────────────────────────
// Full professional identity editor.
// Required: photo, name, headline, company, designation
// Optional: about, website, LinkedIn, skills, industries
//
// Shows a live preview of how others will see this profile.
// Saves via PATCH /identity/professional/:workspaceId

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../core/api/api_client.dart';
import '../widgets/profile_card.dart';

class EditProfileScreen extends StatefulWidget {
  final ApiClient api;
  final Map<String, dynamic>? existingIdentity;

  const EditProfileScreen({
    super.key,
    required this.api,
    this.existingIdentity,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Required
  final _nameCtrl = TextEditingController();
  final _headlineCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();

  // Optional
  final _aboutCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _linkedInCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  List<String> _skills = [];
  List<String> _industries = [];
  bool _saving = false;
  bool _showPreview = false;

  static const _industryOptions = [
    'Technology', 'AI/ML', 'SaaS', 'Fintech', 'Healthcare',
    'E-commerce', 'EdTech', 'Manufacturing', 'Startups',
    'Design', 'Marketing', 'Sales', 'Legal', 'Finance',
  ];

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  void _loadExisting() {
    final data = widget.existingIdentity;
    if (data == null) return;

    _nameCtrl.text = data['name'] as String? ?? '';
    _headlineCtrl.text = data['title'] as String? ?? '';
    _companyCtrl.text = data['company'] as String? ?? '';
    _aboutCtrl.text = data['bio'] as String? ?? '';
    _websiteCtrl.text = data['website'] as String? ?? '';
    _skills = List<String>.from(data['skills'] as List? ?? []);
    _industries = List<String>.from(data['industries'] as List? ?? []);

    // Extract location from data if available
    _locationCtrl.text = data['city'] as String? ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _headlineCtrl.dispose();
    _companyCtrl.dispose();
    _aboutCtrl.dispose();
    _websiteCtrl.dispose();
    _linkedInCtrl.dispose();
    _skillsCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _addSkill() {
    final text = _skillsCtrl.text.trim();
    if (text.isNotEmpty && !_skills.contains(text)) {
      setState(() {
        _skills.add(text);
        _skillsCtrl.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() => _skills.remove(skill));
  }

  void _toggleIndustry(String industry) {
    setState(() {
      if (_industries.contains(industry)) {
        _industries.remove(industry);
      } else {
        _industries.add(industry);
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final data = <String, dynamic>{
        'name': _nameCtrl.text.trim(),
        'title': _headlineCtrl.text.trim(),
        'company': _companyCtrl.text.trim(),
        'bio': _aboutCtrl.text.trim(),
        'website': _websiteCtrl.text.trim(),
        'skills': _skills,
        'industries': _industries,
      };

      // Extract LinkedIn handle if entered as URL
      final linkedIn = _linkedInCtrl.text.trim();
      if (linkedIn.isNotEmpty) {
        data['socialLinks'] = {'linkedin': linkedIn};
      }

      await widget.api.updateProfessionalIdentity('personal', data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile saved'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[700],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () => setState(() => _showPreview = !_showPreview),
            child: Text(_showPreview ? 'Edit' : 'Preview'),
          ),
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
        ],
      ),
      body: _showPreview ? _buildPreview() : _buildForm(theme),
    );
  }

  Widget _buildPreview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 40),
      child: ProfileCard(
        name: _nameCtrl.text.trim().isNotEmpty
            ? _nameCtrl.text.trim()
            : 'Your Name',
        headline: _headlineCtrl.text.trim().isNotEmpty
            ? _headlineCtrl.text.trim()
            : null,
        company: _companyCtrl.text.trim().isNotEmpty
            ? _companyCtrl.text.trim()
            : null,
        about: _aboutCtrl.text.trim().isNotEmpty
            ? _aboutCtrl.text.trim()
            : null,
        location: _locationCtrl.text.trim().isNotEmpty
            ? _locationCtrl.text.trim()
            : null,
        website: _websiteCtrl.text.trim().isNotEmpty
            ? _websiteCtrl.text.trim()
            : null,
        skills: _skills,
        industries: _industries,
        onTap: () => setState(() => _showPreview = false),
      ),
    );
  }

  Widget _buildForm(ThemeData theme) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Section: Basic Info
          _sectionHeader('Basic Information', theme),
          const SizedBox(height: 12),

          TextFormField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: _inputDecoration('Full Name *', Icons.person_outlined),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _headlineCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration('Professional Headline *', Icons.title_outlined,
                hint: 'e.g. Founder & CEO'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _companyCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: _inputDecoration('Company *', Icons.business_outlined,
                hint: 'e.g. Yugrow'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _locationCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: _inputDecoration('Location', Icons.location_city_outlined,
                hint: 'e.g. Chennai'),
          ),
          const SizedBox(height: 24),

          // Section: About
          _sectionHeader('About', theme),
          const SizedBox(height: 12),
          TextFormField(
            controller: _aboutCtrl,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration('About you', Icons.article_outlined,
                hint: 'Tell people what you do...'),
          ),
          const SizedBox(height: 24),

          // Section: Skills
          _sectionHeader('Skills', theme),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _skillsCtrl,
                  decoration: _inputDecoration('Add a skill', LucideIcons.wand,
                      hint: 'e.g. Product Management'),
                  onSubmitted: (_) => _addSkill(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _addSkill,
                icon: const Icon(Icons.add, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          if (_skills.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _skills.map((skill) => Chip(
                label: Text(skill, style: const TextStyle(fontSize: 12)),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _removeSkill(skill),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              )).toList(),
            ),
          ],
          const SizedBox(height: 24),

          // Section: Industries
          _sectionHeader('Industries', theme),
          const SizedBox(height: 8),
          Text('Select all that apply',
              style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _industryOptions.map((industry) {
              final selected = _industries.contains(industry);
              return FilterChip(
                label: Text(industry, style: const TextStyle(fontSize: 12)),
                selected: selected,
                onSelected: (_) => _toggleIndustry(industry),
                selectedColor: const Color(0xFF0F766E).withValues(alpha: 0.15),
                checkmarkColor: const Color(0xFF0F766E),
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Section: Links
          _sectionHeader('Links', theme),
          const SizedBox(height: 12),
          TextFormField(
            controller: _websiteCtrl,
            keyboardType: TextInputType.url,
            decoration: _inputDecoration('Website', Icons.language_outlined,
                hint: 'https://yugrow.app'),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _linkedInCtrl,
            keyboardType: TextInputType.url,
            decoration: _inputDecoration('LinkedIn', LucideIcons.briefcase,
                hint: 'https://linkedin.com/in/...'),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, ThemeData theme) {
    return Text(title,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.primaryColor));
  }

  InputDecoration _inputDecoration(String label, IconData icon,
      {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}
