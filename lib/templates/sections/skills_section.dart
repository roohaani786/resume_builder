import 'package:flutter/material.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  final List<String> _skills = ["Python", "Java", "Flutter"];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Technical Skills',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Skills Chips
              Wrap(
                spacing: 8,
                runSpacing: 8, // To handle smaller screens gracefully
                children: [
                  ..._skills.map((skill) => _buildSkillChip(skill)).toList(),
                  _buildAddSkillButton(),
                ],
              ),

              // Add Skill Input Field with Live Preview and Suggestions
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _showSkillField ? 160 : 0, // Enough height for mobile
                curve: Curves.easeInOut,
                child:
                _showSkillField ? _buildSkillInputFieldWithPreview() : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildSkillChip(String skill) {
    return InkWell(
      onTap: () {
        debugPrint('Skill chip tapped: $skill');
        _editSkill(skill);
      },
      child: Chip(
        label: Text(skill),
        backgroundColor: Colors.purple[50],
        labelStyle: const TextStyle(color: Colors.purple),
        deleteIcon: const Icon(Icons.close, color: Colors.purple),
        onDeleted: () {
          debugPrint('Deleting skill: $skill');
          setState(() {
            _skills.remove(skill);
          });
        },
      ),
    );
  }

  Widget _buildAddSkillButton() {
    return InkWell(
      onTap: () {
        debugPrint('Add skill button tapped');
        setState(() {
          _showSkillField = true;
        });
      },
      child: Chip(
        label: const Text("Add Skill"),
        backgroundColor: Colors.green[50],
        labelStyle: const TextStyle(color: Colors.green),
        avatar: const Icon(Icons.add, color: Colors.green),
      ),
    );
  }

  Widget _buildSkillInputFieldWithPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _skillController,
          decoration: InputDecoration(
            labelText: 'Enter skill',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.purple, width: 1.5),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _currentSkillPreview = value;
            });
          },
          onSubmitted: (value) {
            _addSkill(value);
          },
        ),
        const SizedBox(height: 8),

        // Suggestions Dropdown
        if (_currentSkillPreview.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              children: _suggestions
                  .where((suggestion) => suggestion
                  .toLowerCase()
                  .contains(_currentSkillPreview.toLowerCase()))
                  .map((suggestion) => ListTile(
                title: Text(suggestion),
                onTap: () {
                  _addSkill(suggestion);
                },
              ))
                  .toList(),
            ),
          ),

        const SizedBox(height: 8),

        // Save Skill Button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                _addSkill(_skillController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Save Skill",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Live Preview Section
        if (_currentSkillPreview.isNotEmpty)
          Row(
            children: [
              const Icon(Icons.preview, color: Colors.purple),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Preview: $_currentSkillPreview",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _addSkill(String skill) {
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      debugPrint('Adding skill: $skill');
      setState(() {
        _skills.add(skill);
        _currentSkillPreview = "";
        _skillController.clear();
        _showSkillField = false;
      });
    }
  }

  void _editSkill(String skill) {
    debugPrint('Editing skill: $skill');
    setState(() {
      _skillController.text = skill;
      _currentSkillPreview = skill;
      _skills.remove(skill);
      _showSkillField = true;
    });
  }
}