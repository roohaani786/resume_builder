import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart'; // For date formatting

class ExportedResume extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ExportedResume({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parsing and ensuring type safety
    final experienceSection = _sanitizeExperienceSection(userData["experienceSection"]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ATS Resume Preview',
        style: TextStyle(
          color: Colors.white
        ),),
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
        label: const Text('Download PDF',
        style: TextStyle(
          color: Colors.white
        ),),
        icon: const Icon(Icons.download,

            color: Colors.white),
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

  // Helper method to format dates
  String formatDate(DateTime? date) {
    if (date == null) return "Present";
    try {
      return DateFormat('MMMM yyyy').format(date);
    } catch (e) {
      return "Invalid Date";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define common text styles
    TextStyle sectionHeaderStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey.shade700,
    );

    TextStyle subsectionHeaderStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.blueGrey.shade600,
    );

    TextStyle normalTextStyle = TextStyle(
      fontSize: 14,
      color: Colors.black87,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------
          // Name & Contact Information
          // ---------------------------
          Center(
            child: Column(
              children: [
                Text(
                  nameSection["fullName"] ?? "No Name Provided",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  nameSection["email"] ?? "Email not provided",
                  style: normalTextStyle.copyWith(color: Colors.blue),
                ),
                const SizedBox(height: 4),
                Text(
                  nameSection["phone"] ?? "Phone not provided",
                  style: normalTextStyle,
                ),
                const SizedBox(height: 4),
                if (portfolioLinks.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: portfolioLinks.map((link) {
                      return GestureDetector(
                        onTap: () {
                          // Implement URL launch if needed
                        },
                        child: Text(
                          link,
                          style: normalTextStyle.copyWith(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          const Divider(height: 32, thickness: 1.2),

          // ---------------------------
          // Professional Summary Section
          // ---------------------------
          Text(
            "Professional Summary",
            style: sectionHeaderStyle,
          ),
          const SizedBox(height: 8),
          Text(
            summarySection["summaryText"] ?? "Summary not provided.",
            style: normalTextStyle,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 24),

          // ---------------------------
          // Technical Skills Section
          // ---------------------------
          Text(
            "Technical Skills",
            style: sectionHeaderStyle,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: List<Widget>.from(
              (devSkillsSection["skills"] as List<dynamic>? ?? [])
                  .map(
                    (skill) => Chip(
                  label: Text(
                    skill,
                    style: TextStyle(color: Colors.blueGrey.shade800),
                  ),
                  backgroundColor: Colors.blueGrey.shade100,
                ),
              )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),

          // ---------------------------
          // Work Experience Section
          // ---------------------------
          Text(
            "Work Experience",
            style: sectionHeaderStyle,
          ),
          const SizedBox(height: 8),
          ...experienceSection.map((exp) {
            List<dynamic> roles = exp["roles"] as List<dynamic>? ?? [];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company and Job Title with Dates
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          exp["jobTitle"] ?? "Job Title",
                          style: subsectionHeaderStyle,
                        ),
                      ),
                      Text(
                        "${formatDate(exp["from"])} – ${exp["isCurrent"] == true ? 'Present' : formatDate(exp["to"])}",
                        style: normalTextStyle.copyWith(
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exp["companyName"] ?? "Company Name",
                    style: normalTextStyle.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exp["description"] ?? "",
                    style: normalTextStyle,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 8),
                  if (roles.isNotEmpty)
                    Text(
                      "Key Responsibilities:",
                      style: subsectionHeaderStyle,
                    ),
                  if (roles.isNotEmpty)
                    ...roles.map((role) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("• "),
                            Expanded(
                              child: Text(
                                "${role["title"]} - ${role["description"]}",
                                style: normalTextStyle,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 24),

          // ---------------------------
          // Education Section
          // ---------------------------
          Text(
            "Education",
            style: sectionHeaderStyle,
          ),
          const SizedBox(height: 8),
          ...educationSection.map((edu) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Degree and Institution
                  Text(
                    "${edu["degree"] ?? "Degree"} in ${edu["field"] ?? "Field of Study"}",
                    style: subsectionHeaderStyle,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    edu["institution"] ?? "Institution Name",
                    style: normalTextStyle.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Graduated: ${formatDate(edu["graduationDate"])}",
                    style: normalTextStyle.copyWith(
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (edu["gpa"] != null && edu["gpa"].toString().isNotEmpty)
                    Text(
                      "GPA: ${edu["gpa"]}",
                      style: normalTextStyle,
                    ),
                  if (edu["insights"] != null &&
                      edu["insights"].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        "Highlights: ${edu["insights"]}",
                        style: normalTextStyle,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 24),

          // ---------------------------
          // Certifications Section
          // ---------------------------
          Text(
            "Certifications",
            style: sectionHeaderStyle,
          ),
          const SizedBox(height: 8),
          ...certList.map((cert) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• "),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cert["name"] ?? "Certification Name",
                          style: normalTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (cert["link"] != null && cert["link"]!.isNotEmpty)
                          Text(
                            "Link: ${cert["link"]}",
                            style: normalTextStyle.copyWith(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 24),

          // ---------------------------
          // Projects Section
          // ---------------------------
          Text(
            "Projects",
            style: sectionHeaderStyle,
          ),
          const SizedBox(height: 8),
          ...projectsList.map((proj) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• "),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          proj["name"] ?? "Project Name",
                          style: normalTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (proj["description"] != null &&
                            proj["description"]!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              proj["description"]!,
                              style: normalTextStyle,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        if (proj["link"] != null && proj["link"]!.isNotEmpty)
                          Text(
                            "Link: ${proj["link"]}",
                            style: normalTextStyle.copyWith(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 24),

          // ---------------------------
          // Portfolio Links Section
          // ---------------------------
          if (portfolioLinks.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Portfolio & Links",
                  style: sectionHeaderStyle,
                ),
                const SizedBox(height: 8),
                ...portfolioLinks.map((link) {
                  return Row(
                    children: [
                      const Icon(
                        Icons.link,
                        size: 16,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          // Implement URL launch if needed
                        },
                        child: Text(
                          link,
                          style: normalTextStyle.copyWith(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }
}

