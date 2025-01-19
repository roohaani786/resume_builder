import 'package:flutter/material.dart';
import 'templates/data_science_template.dart';
import 'templates/development_template.dart';
import 'templates/marketing_template.dart';
import 'templates/qa_template.dart';
import 'templates/sales_template.dart';

class TemplateEditingScreen extends StatelessWidget {
  final String category;
  final String templateName;

  const TemplateEditingScreen({
    super.key,
    required this.category,
    required this.templateName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$category - $templateName"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "Edit $templateName",
            //   style: const TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 20),
            Expanded(
              child: _buildTemplate(category),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save the template logic
              },
              child: const Text("Save Resume"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplate(String category) {
    switch (category) {
      case "Development":
        return const GuidedDevelopmentTemplate();
      case "Marketing":
        return const MarketingTemplate();
      case "Sales":
        return const SalesTemplate();
      case "Q&A":
        return const QATemplate();
      case "Data Science":
        return const DataScienceTemplate();
      default:
        return const Text("Invalid category");
    }
  }
}