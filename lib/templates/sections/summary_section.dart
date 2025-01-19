import 'package:flutter/material.dart';

class SummarySection extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final ValueChanged<Map<String, dynamic>> onSaved;

  const SummarySection({
    Key? key,
    required this.initialData,
    required this.onSaved,
  }) : super(key: key);

  @override
  State<SummarySection> createState() => _SummarySectionState();
}

class _SummarySectionState extends State<SummarySection> {
  final _formKey = GlobalKey<FormState>();

  String _selectedSummary = ""; // To track the selected summary
  final TextEditingController _summaryController = TextEditingController();

  final Map<String, List<String>> _suggestedSummaries = {
    "Development": [
      "Experienced software developer skilled in Python, Java, and Flutter. Proficient in building scalable web and mobile applications with a focus on clean code and performance optimization.",
      "Full-stack developer with expertise in designing and implementing RESTful APIs, front-end frameworks, and cloud-based solutions.",
      "Innovative developer with a track record of delivering high-quality applications, improving system performance by 30% in previous projects."
    ],
    // "Sales": [
    //   "Dynamic sales professional with a proven ability to exceed sales targets by 20% consistently. Skilled in negotiation and CRM tools.",
    //   "Results-driven sales executive with experience in identifying growth opportunities and implementing strategies that boost revenue.",
    //   "Customer-focused sales representative with excellent interpersonal skills and a knack for building long-lasting client relationships."
    // ],
    // "Marketing": [
    //   "Creative marketing specialist with expertise in digital marketing, SEO, and content creation. Increased organic traffic by 40% through data-driven strategies.",
    //   "Performance-oriented marketing professional adept at crafting engaging campaigns that drive brand awareness and ROI.",
    //   "Innovative marketer skilled in leveraging social media and analytics to enhance brand positioning and customer engagement."
    // ],
    // "QA": [
    //   "Detail-oriented QA analyst with expertise in automated and manual testing. Ensures the delivery of error-free, high-quality software.",
    //   "QA engineer experienced in identifying, reporting, and resolving software defects to maintain product excellence.",
    //   "Proficient in using testing tools like Selenium and JIRA to streamline the QA process and improve software reliability."
    // ],
    // "Data Science": [
    //   "Data scientist skilled in machine learning, data visualization, and big data tools. Improved predictive model accuracy by 25%.",
    //   "Analytical data scientist with a passion for uncovering insights and providing actionable recommendations.",
    //   "Experienced in developing and deploying data-driven solutions, resulting in optimized decision-making and business growth."
    // ],
  };

  @override
  void initState() {
    super.initState();

    // Load initial data if available
    if (widget.initialData.isNotEmpty) {
      _summaryController.text = widget.initialData['summaryText'] ?? "";
      _selectedSummary = widget.initialData['summaryText'] ?? "";
    }
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Professional Summary',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),

                // Summary Text Field
                TextFormField(
                  controller: _summaryController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Write a brief summary about yourself...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.purple, width: 1.5),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedSummary = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your professional summary';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Suggested Summaries Expansion Tiles
                const Text(
                  'Suggested Summaries:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._suggestedSummaries.entries.map((entry) => ExpansionTile(
                  title: Text(
                    entry.key,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  children: entry.value.map((summary) {
                    return ListTile(
                      title: Text(summary),
                      trailing: IconButton(
                        icon: const Icon(Icons.add, color: Colors.green),
                        onPressed: () {
                          setState(() {
                            _summaryController.text = summary;
                            _selectedSummary = summary;
                          });
                        },
                      ),
                    );
                  }).toList(),
                )),
                const SizedBox(height: 16),

                // Preview Section
                if (_summaryController.text.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preview:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _summaryController.text,
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:
      // Save Button
      ElevatedButton(
        onPressed: _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          padding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.purpleAccent,
          elevation: 5,
        ),
        child: const Text(
          'Save Summary',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // Handle Save Button Press
  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // Construct the data map for the parent
      final dataToSave = {
        "summaryText": _summaryController.text.trim(),
      };

      widget.onSaved(dataToSave); // Send this to parent

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              _selectedSummary.isNotEmpty
                  ? 'Summary Saved: $_selectedSummary'
                  : 'Custom Summary Saved: ${_summaryController.text}',
              style: const TextStyle(fontSize: 16)),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}