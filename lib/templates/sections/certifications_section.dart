import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CertificationsSection extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final ValueChanged<Map<String, dynamic>> onSaved;

  const CertificationsSection({
    Key? key,
    required this.initialData,
    required this.onSaved,
  }) : super(key: key);

  @override
  _CertificationsSectionState createState() => _CertificationsSectionState();
}

class _CertificationsSectionState extends State<CertificationsSection> {
  // Text controllers for certification inputs
  final TextEditingController _certNameController = TextEditingController();
  final TextEditingController _certLinkController = TextEditingController();

  // Text controllers for project inputs
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectLinkController = TextEditingController();

  // Text controller for portfolio link
  final TextEditingController _portfolioLinkController = TextEditingController();

  // Lists to hold data
  List<Map<String, String>> _certifications = [];
  List<Map<String, String>> _projects = [];
  List<String> _portfolioLinks = [];

  @override
  void initState() {
    super.initState();

    // If there's initial data from the parent, populate our lists
    if (widget.initialData.isNotEmpty) {
      // For example, if we stored them as:
      // "certifications": [ {name:..., link:...}, ... ]
      // "projects": [ {name:..., link:...}, ... ]
      // "portfolioLinks": [ "url1", "url2" ]

      if (widget.initialData['certifications'] != null) {
        _certifications = List<Map<String, String>>.from(
          widget.initialData['certifications'] as List,
        );
      }
      if (widget.initialData['projects'] != null) {
        _projects = List<Map<String, String>>.from(
          widget.initialData['projects'] as List,
        );
      }
      if (widget.initialData['portfolioLinks'] != null) {
        _portfolioLinks = List<String>.from(
          widget.initialData['portfolioLinks'] as List,
        );
      }
    }
  }

  @override
  void dispose() {
    _certNameController.dispose();
    _certLinkController.dispose();
    _projectNameController.dispose();
    _projectLinkController.dispose();
    _portfolioLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // So the content doesn’t overflow if items get long
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------
          // CERTIFICATIONS
          // ---------------------------------------------
          const Text(
            'Certifications',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // "Golden" card or label to add a bit of vibe
          Card(
            color: Colors.amber.shade50,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Add your relevant certifications here. Think of these like your golden trophy shelf!',
                style: TextStyle(color: Colors.brown.shade700),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Certification Name Field
          TextFormField(
            controller: _certNameController,
            decoration: const InputDecoration(
              labelText: 'Certification Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),

          // Certification Link Field
          TextFormField(
            controller: _certLinkController,
            decoration: const InputDecoration(
              labelText: 'Certification Link (URL)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),

          // Add Certification Button
          ElevatedButton.icon(
            onPressed: _addCertification,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700),
            icon: const Icon(Icons.card_membership, color: Colors.white),
            label: const Text(
              'Add Certification',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),

          // Show certifications
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _certifications.length,
            itemBuilder: (context, index) {
              final cert = _certifications[index];
              return _buildCertificateCard(cert['name']!, cert['link']!, index);
            },
          ),

          // ---------------------------------------------
          // PROJECTS
          // ---------------------------------------------
          const SizedBox(height: 32),
          const Text(
            'Projects',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.lightBlue.shade50,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'List your awesome coding or design projects, show off your portfolio!',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Project Name Field
          TextFormField(
            controller: _projectNameController,
            decoration: const InputDecoration(
              labelText: 'Project Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),

          // Project Link Field
          TextFormField(
            controller: _projectLinkController,
            decoration: const InputDecoration(
              labelText: 'Project Link (URL)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),

          // Add Project Button
          ElevatedButton.icon(
            onPressed: _addProject,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue.shade600),
            icon: const Icon(Icons.build, color: Colors.white),
            label: const Text('Add Project', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 16),

          // Show projects
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _projects.length,
            itemBuilder: (context, index) {
              final project = _projects[index];
              return _buildProjectCard(project['name']!, project['link']!, index);
            },
          ),

          // ---------------------------------------------
          // PORTFOLIO LINKS
          // ---------------------------------------------
          const SizedBox(height: 32),
          const Text(
            'Portfolio Links',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.purple.shade50,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Add any personal website, GitHub, Dribbble, or LinkedIn links here!',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Portfolio Link Field
          TextFormField(
            controller: _portfolioLinkController,
            decoration: const InputDecoration(
              labelText: 'Portfolio Link (URL)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),

          // Add Portfolio Link Button
          ElevatedButton.icon(
            onPressed: _addPortfolioLink,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            icon: const Icon(Icons.link, color: Colors.white),
            label: const Text('Add Portfolio Link', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 16),

          // Show Portfolio Links
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _portfolioLinks.length,
            itemBuilder: (context, index) {
              final link = _portfolioLinks[index];
              return _buildPortfolioLinkCard(link, index);
            },
          ),
        ],
      ),
    );
  }

  // --------------------------
  // CERTIFICATION METHODS
  // --------------------------
  void _addCertification() {
    final name = _certNameController.text.trim();
    final link = _certLinkController.text.trim();

    if (name.isEmpty) {
      _showSnackBar('Please enter a certification name.');
      return;
    }

    setState(() {
      _certifications.add({'name': name, 'link': link});
    });
    _certNameController.clear();
    _certLinkController.clear();

    // Save data to parent
    _saveAllData();
  }

  Widget _buildCertificateCard(String name, String link, int index) {
    return Card(
      color: Colors.amber.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.workspace_premium, color: Colors.brown),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(link.isEmpty ? 'No link provided' : link),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteCertification(index),
        ),
        onTap: link.isNotEmpty ? () => _openLink(link) : null,
      ),
    );
  }

  void _deleteCertification(int index) {
    setState(() {
      _certifications.removeAt(index);
    });
    _showSnackBar('Certification removed.');
    _saveAllData();
  }

  // --------------------------
  // PROJECT METHODS
  // --------------------------
  void _addProject() {
    final name = _projectNameController.text.trim();
    final link = _projectLinkController.text.trim();

    if (name.isEmpty) {
      _showSnackBar('Please enter a project name.');
      return;
    }

    setState(() {
      _projects.add({'name': name, 'link': link});
    });
    _projectNameController.clear();
    _projectLinkController.clear();

    // Save data to parent
    _saveAllData();
  }

  Widget _buildProjectCard(String name, String link, int index) {
    return Card(
      color: Colors.lightBlue.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.code, color: Colors.blueGrey),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(link.isEmpty ? 'No link provided' : link),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteProject(index),
        ),
        onTap: link.isNotEmpty ? () => _openLink(link) : null,
      ),
    );
  }

  void _deleteProject(int index) {
    setState(() {
      _projects.removeAt(index);
    });
    _showSnackBar('Project removed.');
    _saveAllData();
  }

  // --------------------------
  // PORTFOLIO LINK METHODS
  // --------------------------
  void _addPortfolioLink() {
    final link = _portfolioLinkController.text.trim();

    if (link.isEmpty) {
      _showSnackBar('Please enter a portfolio URL.');
      return;
    }

    setState(() {
      _portfolioLinks.add(link);
    });
    _portfolioLinkController.clear();

    // Save data to parent
    _saveAllData();
  }

  Widget _buildPortfolioLinkCard(String link, int index) {
    return Card(
      color: Colors.purple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.web, color: Colors.deepPurple),
        title: Text(link, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deletePortfolioLink(index),
        ),
        onTap: () => _openLink(link),
      ),
    );
  }

  void _deletePortfolioLink(int index) {
    setState(() {
      _portfolioLinks.removeAt(index);
    });
    _showSnackBar('Portfolio link removed.');
    _saveAllData();
  }

  // --------------------------
  // HELPER METHODS
  // --------------------------
  void _saveAllData() {
    // Construct the entire data map for this section
    final dataToSave = {
      'certifications': _certifications,
      'projects': _projects,
      'portfolioLinks': _portfolioLinks,
    };

    widget.onSaved(dataToSave);
  }

  void _openLink(String url) async {
    // Attempt to open link in browser; needs `url_launcher` package
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar('Could not open the link.');
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}