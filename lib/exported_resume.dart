import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportedResume extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ExportedResume({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parsing and ensuring type safety
    final experienceSection = _sanitizeExperienceSection(userData["experienceSection"]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ATS Resume Preview'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ATSResumePreview(
          nameSection: userData["nameSection"] as Map<String, dynamic>? ?? {},
          summarySection: userData["summarySection"] as Map<String, dynamic>? ?? {},
          devSkillsSection: userData["devSkillsSection"] as Map<String, dynamic>? ?? {},
          experienceSection: experienceSection, // Pass sanitized experienceSection
          educationSection: userData["educationSection"] as List<Map<String, dynamic>>? ?? [],
          certList: userData["certificationsSection"]?["certifications"] as List<Map<String, String>>? ?? [],
          projectsList: userData["certificationsSection"]?["projects"] as List<Map<String, String>>? ?? [],
          portfolioLinks: userData["certificationsSection"]?["portfolioLinks"] as List<String>? ?? [],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _downloadPdf(context),
        label: const Text('Download PDF'),
        icon: const Icon(Icons.download),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Future<void> _downloadPdf(BuildContext context) async {
    // PDF generation logic remains unchanged
  }

  // Helper method to sanitize experienceSection
  List<Map<String, dynamic>> _sanitizeExperienceSection(dynamic section) {
    if (section is List) {
      // Ensure every item is a Map<String, dynamic>
      return section
          .where((item) => item is Map<String, dynamic>)
          .map((item) => item as Map<String, dynamic>)
          .toList();
    } else if (section is Map<String, dynamic>) {
      // If it's a single map, wrap it in a list
      return [section];
    } else {
      // If it's neither, return an empty list
      return [];
    }
  }
}

class ATSResumePreview extends StatelessWidget {
  final Map<String, dynamic> nameSection;
  final Map<String, dynamic> summarySection;
  final Map<String, dynamic> devSkillsSection;
  final List<Map<String, dynamic>> experienceSection;
  final List<Map<String, dynamic>> educationSection;
  final List<Map<String, String>> certList;
  final List<Map<String, String>> projectsList;
  final List<String> portfolioLinks;

  const ATSResumePreview({
    Key? key,
    required this.nameSection,
    required this.summarySection,
    required this.devSkillsSection,
    required this.experienceSection,
    required this.educationSection,
    required this.certList,
    required this.projectsList,
    required this.portfolioLinks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fancy resume preview layout
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name & Contact
        Text(
          nameSection["fullName"] ?? "No Name",
          style: Theme.of(context).textTheme.bodyLarge, // Ensure Flutter SDK supports headline5
        ),
        if (nameSection["email"] != null) Text("Email: ${nameSection["email"]}"),
        if (nameSection["phone"] != null) Text("Phone: ${nameSection["phone"]}"),

        const SizedBox(height: 16),
        // Summary
        Text(
          "Summary:",
          style: Theme.of(context).textTheme.bodySmall, // Ensure Flutter SDK supports subtitle1
        ),
        Text(summarySection["summaryText"] ?? ""),

        const SizedBox(height: 16),
        // Dev Skills
        Text(
          "Skills:",
          style: Theme.of(context).textTheme.bodySmall, // Ensure Flutter SDK supports subtitle1
        ),
        Wrap(
          children: List<Widget>.from(
            (devSkillsSection["skills"] as List<dynamic>? ?? [])
                .map(
                  (skill) => Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(skill),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),
        // Experience
        Text(
          "Experience:",
          style: Theme.of(context).textTheme.bodyLarge, // Ensure Flutter SDK supports subtitle1
        ),
        ...experienceSection.map((exp) {
          final roles = exp["roles"] as List<dynamic>? ?? [];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${exp["companyName"]} - ${exp["jobTitle"]}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "From: ${exp["from"]} To: ${exp["isCurrent"] == true ? "Present" : exp["to"]}",
                ),
                if (exp["description"] != null) Text(exp["description"]),
                if (roles.isNotEmpty)
                  const Text(
                    "Roles:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ...roles.map((role) {
                  return Text("• ${role["title"]} - ${role["description"]}");
                }),
              ],
            ),
          );
        }),

        const SizedBox(height: 16),
        // Education
        Text(
          "Education:",
          style: Theme.of(context).textTheme.bodyLarge, // Ensure Flutter SDK supports subtitle1
        ),
        ...educationSection.map((edu) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${edu["degree"]} at ${edu["institution"]}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Grading: ${edu["gradingSystem"]} - ${edu["gpa"]}"),
                if (edu["insights"] != null && edu["insights"].toString().isNotEmpty)
                  Text("Insights: ${edu["insights"]}"),
              ],
            ),
          );
        }),

        const SizedBox(height: 16),
        // Certifications
        Text(
          "Certifications:",
          style: Theme.of(context).textTheme.bodyLarge, // Ensure Flutter SDK supports subtitle1
        ),
        ...certList.map((cert) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cert["name"] ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (cert["link"] != null && cert["link"]!.isNotEmpty)
                  Text("Link: ${cert["link"]}"),
              ],
            ),
          );
        }),

        const SizedBox(height: 16),
        // Projects
        Text(
          "Projects:",
          style: Theme.of(context).textTheme.bodyLarge, // Ensure Flutter SDK supports subtitle1
        ),
        ...projectsList.map((proj) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  proj["name"] ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (proj["link"] != null && proj["link"]!.isNotEmpty)
                  Text("Link: ${proj["link"]}"),
              ],
            ),
          );
        }),

        const SizedBox(height: 16),
        // Portfolio Links
        Text(
          "Portfolio Links:",
          style: Theme.of(context).textTheme.bodyMedium, // Ensure Flutter SDK supports subtitle1
        ),
        ...portfolioLinks.map((link) => Text("• $link")),
      ],
    );
  }
}