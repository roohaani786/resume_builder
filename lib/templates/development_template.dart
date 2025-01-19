import 'package:flutter/material.dart';

// Import your sections:
import '../exported_resume.dart';
import 'sections/name_section.dart';
import 'sections/summary_section.dart';
import 'sections/dev_skills_section.dart';
import 'sections/experience/experience_section.dart';
import 'sections/education_section.dart';
import 'sections/certifications_section.dart';

class GuidedDevelopmentTemplate extends StatefulWidget {
  const GuidedDevelopmentTemplate({Key? key}) : super(key: key);

  @override
  State<GuidedDevelopmentTemplate> createState() =>
      _GuidedDevelopmentTemplateState();
}

class _GuidedDevelopmentTemplateState extends State<GuidedDevelopmentTemplate> {
  // This map holds *all* the user’s resume data across all sections.
  // We'll nest sub-maps keyed by section name if we like.
  Map<String, dynamic> userData = {
    "nameSection": <String, dynamic>{},
    "summarySection": <String, dynamic>{},
    "devSkillsSection": <String, dynamic>{},
    "experienceSection": [],
    "educationSection": [<String, dynamic>{}],
    "certificationsSection": <String, dynamic>{},
  };

  int currentStep = 0;
  late final List<Widget> steps;

  @override
  void initState() {
    super.initState();

    // Build the steps list once we’re in initState
    steps = [
      // 1) NameSection
      NameSection(
        // Pass existing userData for NameSection if available
        initialData: userData["nameSection"],
        // The section calls this when user saves
        onSaved: (sectionData) {
          setState(() {
            userData["nameSection"] = sectionData;
          });
        },
      ),

      // 2) SummarySection
      SummarySection(
        initialData: userData["summarySection"],
        onSaved: (sectionData) {
          setState(() {
            userData["summarySection"] = sectionData;
          });
        },
      ),

      // 3) DevSkillsSection
      DevSkillsSection(
        initialData: userData["devSkillsSection"],
        onSaved: (sectionData) {
          setState(() {
            userData["devSkillsSection"] = sectionData;
          });
        },
      ),

      // 4) ExperienceSection
      ExperienceSection(
        initialData: _getExperienceSectionData(userData["experienceSection"]),
        onSaved: (sectionData) {
          setState(() {
            userData["experienceSection"] = sectionData;
          });
        },
      ),

      // 5) EducationSection
      EducationSection(
        initialData: userData["educationSection"] ?? [],
        onSaved: (sectionData) {
          setState(() {
            userData["educationSection"] = sectionData;
          });
        },
      ),

      // 6) CertificationsSection
      CertificationsSection(
        initialData: userData["certificationsSection"] ?? {},
        onSaved: (sectionData) {
          setState(() {
            userData["certificationsSection"] = sectionData;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _buildGuidedFlow();
  }

  Widget _buildGuidedFlow() {
    return Scaffold(
      body: Column(
        children: [
          // The current step widget:
          Expanded(child: steps[currentStep]),

          // The progress/motivational message at bottom:
          _buildStatus(),

          // The navigation buttons:
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  // Display current progress or motivational message
  Widget _buildStatus() {
    final List<String> progressMessages = [
      "You're starting strong! 💪 Let's get that name right!",
      "Great job! Now, let's work on that summary! 📝",
      "You're doing awesome! Time to show those dev skills! 💻",
      "Almost there! Let's dive into your experiences! 💼",
      "You're on fire! Time to talk about your education! 🎓",
      "Just one more thing! Let's wrap up your certifications! 🏅"
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        progressMessages[currentStep],
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green[700],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Map<String, dynamic>> _getExperienceSectionData(dynamic experienceData) {
    if (experienceData is List) {
      // Ensure each item in the list is a Map<String, dynamic>
      return experienceData
          .map((item) => item is Map<String, dynamic> ? item : {})
          .toList()
          .cast<Map<String, dynamic>>();
    } else if (experienceData is Map<String, dynamic>) {
      // If it's a single map, wrap it in a list
      return [experienceData];
    } else {
      // If it's neither, return an empty list
      return [];
    }
  }

  bool _isCurrentStepValid() {
    switch (currentStep) {
      case 0: // NameSection
        return userData["nameSection"] != null &&
            userData["nameSection"].isNotEmpty;
      case 1: // SummarySection
        return userData["summarySection"] != null &&
            userData["summarySection"].isNotEmpty;
      case 2: // DevSkillsSection
        return userData["devSkillsSection"] != null &&
            userData["devSkillsSection"].isNotEmpty;
      case 3: // ExperienceSection
        return userData["experienceSection"] != null &&
            (userData["experienceSection"] as List).isNotEmpty;
      case 4: // EducationSection
        return userData["educationSection"] != null &&
            (userData["educationSection"] as List).isNotEmpty;
      case 5: // CertificationsSection
        return userData["certificationsSection"] != null &&
            userData["certificationsSection"].isNotEmpty;
      default:
        return false;
    }
  }


  bool _isAllDataValid() {
    return userData["nameSection"].isNotEmpty &&
        userData["summarySection"].isNotEmpty &&
        userData["devSkillsSection"].isNotEmpty &&
        (userData["experienceSection"] as List).isNotEmpty &&
        (userData["educationSection"] as List).isNotEmpty &&
        userData["certificationsSection"].isNotEmpty;
  }


  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Show a "Back" button if we’re not on the first step
          if (currentStep > 0)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentStep--;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Oops, Take Me Back! 😅',
                style: TextStyle(color: Colors.white),
              ),
            ),

          ElevatedButton(
            onPressed: () {
              if (!_isCurrentStepValid()) {
                // Show validation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please complete the required fields before proceeding.',
                      style: TextStyle(fontSize: 16),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              if (currentStep < steps.length - 1) {
                setState(() {
                  currentStep++;
                });
              } else {
                if (_isAllDataValid()) {
                  // Navigate to the ExportedResume screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ExportedResume(userData: userData),
                    ),
                  );
                } else {
                  // Show validation message for incomplete data
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please complete all sections before finishing.',
                        style: TextStyle(fontSize: 16),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              currentStep == steps.length - 1 ? 'Finish 🎉' : 'Let\'s Go! 🚀',
              style: const TextStyle(color: Colors.white),
            ),
          ),

          //
          // ElevatedButton(
          //   onPressed: () {
          //     if (currentStep < steps.length - 1) {
          //       setState(() {
          //         currentStep++;
          //       });
          //     } else {
          //       // Instead of showing a completion dialog, let's navigate
          //       Navigator.of(context).push(
          //         MaterialPageRoute(
          //           builder: (_) => ExportedResume(userData: userData),
          //         ),
          //       );
          //     }
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.green.shade600,
          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //   ),
          //   child: Text(
          //     currentStep == steps.length - 1 ? 'Finish 🎉' : 'Let\'s Go! 🚀',
          //     style: const TextStyle(color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue[50],
          title: const Text(
            '🚀 You Did It!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          content: const Text(
            'Your Development resume is all set and ready to rock! 💼🔥\n\nNow, go ahead and download it! 😎',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cool, let me grab it! 🏃‍♂️',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}