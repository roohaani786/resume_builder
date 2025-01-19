import 'package:flutter/material.dart';

class DevSkillsSection extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final ValueChanged<Map<String, dynamic>> onSaved;

  const DevSkillsSection({
    Key? key,
    required this.initialData,
    required this.onSaved,
  }) : super(key: key);

  @override
  State<DevSkillsSection> createState() => _DevSkillsSectionState();
}

class _DevSkillsSectionState extends State<DevSkillsSection> {
  final List<String> _suggestions = [
    "Python",
    "Java",
    "Flutter",
    "Dart",
    "Kotlin",
    "Swift",
    "JavaScript",
    "React",
    "Node.js",
    "AWS"
  ];
  final TextEditingController _skillController = TextEditingController();
  bool _showSkillField = false;
  String _currentSkillPreview = "";
  bool _isSaveButtonEnabled = false;

  final List<Color> _chipColors = [
    const Color(0xFF4CAF50),
    const Color(0xFF2196F3),
    const Color(0xFFFFC107),
    const Color(0xFF9C27B0),
    const Color(0xFFFF5722),
    const Color(0xFF607D8B),
  ];

  // Skills list initialized from initialData or defaults
  List<String> _skills = [];

  @override
  void initState() {
    super.initState();
    // Load initial skills from parent data if available
    if (widget.initialData.containsKey('skills')) {
      List<dynamic> savedSkills = widget.initialData['skills'];
      _skills = savedSkills.map((skill) => skill.toString()).toList();
    }
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Technical Skills',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
            const SizedBox(height: 24.0),
        
            // Display Skills as Chips
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ..._skills.map((skill) => _buildSkillChip(skill)),
                _buildAddSkillButton(),
              ],
            ),
            const SizedBox(height: 16.0),
        
            // Animated Skill Input Field with Preview
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showSkillField ? 350 : 0,
              curve: Curves.easeInOut,
              child: _showSkillField
                  ? _buildSkillInputFieldWithPreview()
                  : const SizedBox.shrink(),
            ),
        
            // Save Skills Button
            if (_skills.isNotEmpty)
              Center(
                child: ElevatedButton(
                  onPressed: _saveSkills,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.purpleAccent,
                    elevation: 5,
                  ),
                  child: const Text(
                    'Save Skills',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    final Color chipColor = _getColorForSkill(skill);
    final Color textColor = _getPremiumTextColor(chipColor);

    return GestureDetector(
      onTap: () {
        _editSkill(skill);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [chipColor.withOpacity(0.9), chipColor.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: chipColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              skill,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _skills.remove(skill);
                });
              },
              child: Icon(
                Icons.close,
                color: textColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddSkillButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showSkillField = true;
          _skillController.clear();
          _currentSkillPreview = "";
          _isSaveButtonEnabled = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add, color: Colors.grey, size: 20),
            SizedBox(width: 8),
            Text(
              "Add Skill",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillInputFieldWithPreview() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: _skillController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Enter skill',
              prefixIcon: const Icon(Icons.edit, color: Colors.purple),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                const BorderSide(color: Colors.purple, width: 1.5),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _currentSkillPreview = value;
                _isSaveButtonEnabled = _isValidSkill(value);
              });
            },
            onSubmitted: (value) {
              if (_isValidSkill(value)) _addSkill(value);
            },
          ),
          const SizedBox(height: 12),
          if (_currentSkillPreview.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.preview, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  "Preview: $_currentSkillPreview",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          const SizedBox(height: 12),
          if (_currentSkillPreview.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                children: _suggestions
                    .where((suggestion) =>
                suggestion
                    .toLowerCase()
                    .contains(_currentSkillPreview.toLowerCase()) &&
                    !_skills.contains(suggestion))
                    .map((suggestion) => ListTile(
                  title: Text(suggestion),
                  onTap: () {
                    _addSkill(suggestion);
                  },
                ))
                    .toList(),
              ),
            ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _isSaveButtonEnabled
                  ? () {
                _addSkill(_skillController.text);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                _isSaveButtonEnabled ? Colors.purple : Colors.grey,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Save Skill",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForSkill(String skill) {
    final int index = skill.hashCode % _chipColors.length;
    return _chipColors[index];
  }

  /// Returns a premium contrast text color based on the background color.
  Color _getPremiumTextColor(Color backgroundColor) {
    final double luminance = backgroundColor.computeLuminance();
    // Use white text for dark backgrounds and black text for light backgrounds
    if (luminance > 0.6) {
      return Colors.black.withOpacity(0.85); // Darker text for better readability
    } else if (luminance > 0.4) {
      return Colors.grey.shade100; // Softer white for mid-toned backgrounds
    } else {
      return Colors.white.withOpacity(0.95); // Bright white for very dark backgrounds
    }
  }

  bool _isValidSkill(String skill) {
    return skill.isNotEmpty &&
        !_skills.any((s) => s.toLowerCase() == skill.toLowerCase());
  }

  void _addSkill(String skill) {
    if (_isValidSkill(skill)) {
      setState(() {
        _skills.add(skill.trim());
        _currentSkillPreview = "";
        _skillController.clear();
        _showSkillField = false;
        _isSaveButtonEnabled = false;
      });
    }
  }

  void _editSkill(String skill) {
    setState(() {
      _skillController.text = skill;
      _currentSkillPreview = skill;
      _skills.remove(skill);
      _showSkillField = true;
      _isSaveButtonEnabled = true;
    });
  }

  void _saveSkills() {
    // Construct the data map for the parent
    final dataToSave = {
      "skills": _skills,
    };

    widget.onSaved(dataToSave); // Send this to parent

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Skills Saved: ${_skills.join(", ")}',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}