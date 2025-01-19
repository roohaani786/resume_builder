import 'package:flutter/material.dart';

class SalesTemplate extends StatelessWidget {
  const SalesTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _templatePlaceholder(
      title: "Sales Representative Resume",
      sections: [
        "Name and Contact Information",
        "Professional Summary",
        "Key Skills (Negotiation, CRM Tools, Sales Techniques)",
        "Work Experience (Focus on sales targets and metrics achieved)",
        "Education",
        "Awards and Recognition",
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