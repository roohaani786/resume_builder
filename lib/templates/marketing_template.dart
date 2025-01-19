import 'package:flutter/material.dart';

class MarketingTemplate extends StatelessWidget {
  const MarketingTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _templatePlaceholder(
      title: "Marketing Specialist Resume",
      sections: [
        "Name and Contact Information",
        "Professional Summary",
        "Marketing Skills (SEO, Content Creation, Campaign Management)",
        "Work Experience (Highlight measurable achievements: e.g., increased ROI by X%)",
        "Education",
        "Certifications (Google Analytics, HubSpot, etc.)",
      ],
    );
  }

  Widget _templatePlaceholder({
    required String title,
    required List<String> sections,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...sections.map(
                (section) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  section,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}