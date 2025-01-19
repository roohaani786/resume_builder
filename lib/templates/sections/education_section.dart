import 'package:flutter/material.dart';

class EducationSection extends StatefulWidget {
  final List<Map<String, dynamic>> initialData;
  final ValueChanged<List<Map<String, dynamic>>> onSaved;

  const EducationSection({
    Key? key,
    required this.initialData,
    required this.onSaved,
  }) : super(key: key);

  @override
  _EducationSectionState createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection> {
  // Initialize education entries from initialData or as empty
  List<Map<String, dynamic>> _educationEntries = [];

  // Text controllers for input fields
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _insightsController = TextEditingController();
  final TextEditingController _gpaController = TextEditingController();

  // List of degrees and universities for suggestions
  final List<String> degrees = [
    'Bachelor of Science',
    'Bachelor of Arts',
    'Master’s in Computer Science',
    'MBA',
    'PhD',
    'Associate Degree'
  ];
  final List<String> universities = [
    'Harvard University',
    'MIT',
    'Stanford University',
    'Oxford University',
    'University of California, Berkeley',
    'University of Cambridge'
  ];

  // Dropdown options for GPA/CGPA/Percentage
  final List<String> gradingSystems = ['CGPA', 'GPA', 'Percentage'];

  String? selectedGradingSystem = 'GPA';

  @override
  void initState() {
    super.initState();
    // Load initial education entries if available
    if (widget.initialData.isNotEmpty) {
      _educationEntries = List<Map<String, dynamic>>.from(widget.initialData);
    }
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _institutionController.dispose();
    _insightsController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Removed nested Scaffold; using Padding instead
      padding: const EdgeInsets.all(20.0),
      // SingleChildScrollView to prevent overflow
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Education 🧑‍🎓',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 20),

            // Degree Input Field with Suggestions
            _buildTextFieldWithSuggestions(
              'Degree 🎓',
              _degreeController,
              degrees,
            ),
            const SizedBox(height: 16),

            // Institution Input Field with Suggestions
            _buildTextFieldWithSuggestions(
              'University/Institution 🏫',
              _institutionController,
              universities,
            ),
            const SizedBox(height: 16),

            // Insights Input Field
            _buildTextField('Add Insights 📝', _insightsController, maxLines: 3),
            const SizedBox(height: 16),

            // GPA/CGPA/Percentage Selection
            DropdownButtonFormField<String>(
              value: selectedGradingSystem,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGradingSystem = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Grading System',
                border: OutlineInputBorder(),
              ),
              items: gradingSystems
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // GPA/CGPA/Percentage Value Input
            _buildTextField('${selectedGradingSystem} Value', _gpaController),
            const SizedBox(height: 20),

            // Add Education Button with rounded effect
            ElevatedButton(
              onPressed: _addEducationEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Add Education Entry',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Display added education entries
            const Text(
              'Your Education Entries 🔥',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 10),

            // Use a ListView with shrinkWrap to avoid unbounded height issue
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _educationEntries.length,
              itemBuilder: (context, index) {
                final entry = _educationEntries[index];
                return _buildEducationCard(entry, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Builds a text input field with suggestions (for degree and institution)
  Widget _buildTextFieldWithSuggestions(
      String label,
      TextEditingController controller,
      List<String> suggestions,
      ) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return suggestions.where((suggestion) => suggestion
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (String selected) {
        controller.text = selected;
      },
      fieldViewBuilder: (context, autoController, focusNode, onEditingComplete) {
        return TextField(
          controller: autoController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.purple, width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  // Builds a text input field
  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
      }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.purple.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.purple.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.purple),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // Adds the education entry to the list
  void _addEducationEntry() {
    if (_degreeController.text.isEmpty || _institutionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields to add education.")),
      );
      return;
    }

    setState(() {
      _educationEntries.add({
        'degree': _degreeController.text.trim(),
        'institution': _institutionController.text.trim(),
        'insights': _insightsController.text.trim(),
        'gradingSystem': selectedGradingSystem,
        'gpa': _gpaController.text.trim(),
      });
    });

    // Notify parent of the updated education entries
    widget.onSaved(_educationEntries);

    // Clear the input fields after adding
    _clearControllers();
  }

  // Clear all text fields
  void _clearControllers() {
    _degreeController.clear();
    _institutionController.clear();
    _insightsController.clear();
    _gpaController.clear();
    // Optionally reset dropdown
    setState(() {
      selectedGradingSystem = 'GPA';
    });
  }

  // Builds the education card UI
  Widget _buildEducationCard(Map<String, dynamic> entry, int index) {
    return (entry['degree'] == null)?
        const SizedBox():
    Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry['degree']??"",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              entry['institution']??"",
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            if ((entry['insights']??"").isNotEmpty)
              Text(
                '🔎 Insights: ${entry['insights']}',
                style: const TextStyle(fontSize: 14, color: Colors.purple),
              ),
            const SizedBox(height: 8),
            Text(
              'Grading System: ${entry['gradingSystem']??""} - ${entry['gpa']??""}',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.purple),
                  onPressed: () => _showEditDialog(index),
                  tooltip: 'Edit Education Entry',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteEducationEntry(index),
                  tooltip: 'Delete Education Entry',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Delete the education entry
  void _deleteEducationEntry(int index) {
    setState(() {
      _educationEntries.removeAt(index);
    });

    // Notify parent of the updated education entries
    widget.onSaved(_educationEntries);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Education entry deleted! 🗑️")),
    );
  }

  // Show a dialog to edit an existing entry
  void _showEditDialog(int index) {
    // Grab the existing entry data
    final entry = _educationEntries[index];

    // Pre-fill our controllers
    _degreeController.text = entry['degree'];
    _institutionController.text = entry['institution'];
    _insightsController.text = entry['insights'] ?? '';
    selectedGradingSystem = entry['gradingSystem'];
    _gpaController.text = entry['gpa'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Education'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextFieldWithSuggestions(
                  'Degree 🎓',
                  _degreeController,
                  degrees,
                ),
                const SizedBox(height: 16),
                _buildTextFieldWithSuggestions(
                  'University/Institution 🏫',
                  _institutionController,
                  universities,
                ),
                const SizedBox(height: 16),
                _buildTextField('Add Insights 📝', _insightsController, maxLines: 3),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGradingSystem,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGradingSystem = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Grading System',
                    border: OutlineInputBorder(),
                  ),
                  items: gradingSystems
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                _buildTextField('${selectedGradingSystem} Value', _gpaController),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
                _clearControllers(); // optional
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              onPressed: () {
                _saveEditedEntry(index);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Save the edited entry back into the list
  void _saveEditedEntry(int index) {
    if (_degreeController.text.isEmpty || _institutionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields to save education.")),
      );
      return;
    }

    setState(() {
      _educationEntries[index] = {
        'degree': _degreeController.text.trim(),
        'institution': _institutionController.text.trim(),
        'insights': _insightsController.text.trim(),
        'gradingSystem': selectedGradingSystem,
        'gpa': _gpaController.text.trim(),
      };
    });

    // Notify parent of the updated education entries
    widget.onSaved(_educationEntries);

    // Clear the controllers so they're blank next time
    _clearControllers();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Education entry updated! ✅")),
    );
  }
}