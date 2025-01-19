// lib/templates/sections/experience/experience_section.dart

import 'package:flutter/material.dart';
import 'experience_form.dart';
import 'experience_card.dart';
import 'role_bottom_sheet.dart';

class ExperienceSection extends StatefulWidget {
  final List<Map<String, dynamic>> initialData;
  final ValueChanged<List<Map<String, dynamic>>> onSaved;

  const ExperienceSection({
    Key? key,
    required this.initialData,
    required this.onSaved,
  }) : super(key: key);

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  // Initialize experiences from initialData or as empty
  List<Map<String, dynamic>> _experiences = [];

  bool _showExperienceForm = false;
  bool _isEditingExperience = false;
  int? _editingExperienceIndex;

  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ScrollController _scrollController =
      ScrollController(); // Added ScrollController

  @override
  void initState() {
    super.initState();
    // Load initial experiences if available
    if (widget.initialData.isNotEmpty) {
      _experiences = List<Map<String, dynamic>>.from(widget.initialData);
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose(); // Dispose ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController, // Assign ScrollController
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Work Experience',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Display Experiences
          if (_experiences.isNotEmpty)
            ListView.builder(
              itemCount: _experiences.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final exp = _experiences[index];
                return ExperienceCard(
                  experience: exp,
                  onEditExperience: () => _editExperience(index),
                  onDeleteExperience: () => _deleteExperience(index),
                  onAddRole: () => _showAddRoleBottomSheet(index),
                  onEditRole: (roleIndex) =>
                      _showEditRoleBottomSheet(index, roleIndex),
                  onDeleteRole: (roleIndex) => _deleteRole(index, roleIndex),
                );
              },
            )
          else
            const Text(
              "No experience added yet. Start by adding your first experience.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),

          const SizedBox(height: 16),

          // Experience Form
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showExperienceForm ? null : 0,
            curve: Curves.easeInOut,
            child: _showExperienceForm
                ? ExperienceForm(
                    companyController: _companyController,
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                    isCurrentCompany: _isEditingExperience
                        ? _experiences[_editingExperienceIndex!]['isCurrent'] ??
                            false
                        : false,
                    fromDate: _isEditingExperience
                        ? _experiences[_editingExperienceIndex!]['from']
                            as DateTime?
                        : null,
                    toDate: _isEditingExperience
                        ? _experiences[_editingExperienceIndex!]['to']
                            as DateTime?
                        : null,
                    roles: _isEditingExperience
                        ? List<Map<String, dynamic>>.from(
                            _experiences[_editingExperienceIndex!]['roles'] ??
                                [])
                        : [],
                    onUpdateDates: (from, to, isCurrent) {
                      print("Updated fromDate: $from, toDate: $to, isCurrent: $isCurrent");
                      print("Updated experiences: $_experiences");

                      setState(() {
                        if (_isEditingExperience &&
                            _editingExperienceIndex != null) {
                          // Ensure proper updates in _experiences
                          _experiences[_editingExperienceIndex!] = {
                            ..._experiences[_editingExperienceIndex!],
                            'from': from,
                            'to': to,
                            'isCurrent': isCurrent,
                          };
                        }
                      });
                    },
                    onSave: (updatedExperience) {
                      setState(() {
                        if (_isEditingExperience &&
                            _editingExperienceIndex != null) {
                          _experiences[_editingExperienceIndex!] =
                              updatedExperience;
                        } else {
                          _experiences.add(updatedExperience);
                        }
                        _showExperienceForm =
                            false; // Close the form after saving
                      });
                    },
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 16),

          // Add Experience Button
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showExperienceForm = !_showExperienceForm;
                if (!_showExperienceForm) {
                  _isEditingExperience = false;
                  _editingExperienceIndex = null;
                  _companyController.clear();
                  _titleController.clear();
                  _descriptionController.clear();
                }
              });
              if (_showExperienceForm) {
                _scrollToForm(); // Scroll to form when it's shown
              }
            },
            icon: Icon(_showExperienceForm ? Icons.cancel : Icons.add,
                color: Colors.white),
            label: Text(
              _showExperienceForm ? 'Cancel' : 'Add Experience',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 100), // To provide space at the bottom
        ],
      ),
    );
  }

  void _saveExperience(Map<String, dynamic> experienceData) {
    if (_isEditingExperience && _editingExperienceIndex != null) {
      setState(() {
        _experiences[_editingExperienceIndex!] = experienceData;
      });
    } else {
      setState(() {
        _experiences.add(experienceData);
      });
    }

    // Sort experiences: current first, then by start date descending
    _experiences.sort((a, b) {
      final aCurrent = a['isCurrent'] == true;
      final bCurrent = b['isCurrent'] == true;
      if (aCurrent && !bCurrent) return -1;
      if (!aCurrent && bCurrent) return 1;

      final aFrom = a['from'] as DateTime;
      final bFrom = b['from'] as DateTime;
      return bFrom.compareTo(aFrom);
    });

    // Notify parent of the updated experiences
    widget.onSaved(_experiences);

    // Automatically hide the form and reset editing state
    setState(() {
      _showExperienceForm = false;
      _isEditingExperience = false;
      _editingExperienceIndex = null;
      _companyController.clear();
      _titleController.clear();
      _descriptionController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditingExperience
              ? 'Experience updated successfully!'
              : 'Experience added successfully!',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _editExperience(int index) {
    final exp = _experiences[index];
    setState(() {
      _companyController.text = exp['companyName'] ?? "";
      _titleController.text = exp['jobTitle'] ?? "";
      _descriptionController.text = exp['description'] ?? "";
      _showExperienceForm = true;
      _isEditingExperience = true;
      _editingExperienceIndex = index;
    });

    _scrollToForm();
  }

  void _deleteExperience(int index) {
    setState(() {
      _experiences.removeAt(index);
    });
    // Notify parent of the updated experiences
    widget.onSaved(_experiences);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Experience deleted successfully! 🗑️"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showAddRoleBottomSheet(int experienceIndex) async {
    final roleData = await showRoleBottomSheet(
      context: context,
      existingRole: null,
    );

    if (roleData != null) {
      setState(() {
        _experiences[experienceIndex]['roles'] =
            List<Map<String, dynamic>>.from(
                _experiences[experienceIndex]['roles'] ?? []);
        _experiences[experienceIndex]['roles'].add(roleData);
        widget.onSaved(_experiences);
      });
    }
  }

  void _showEditRoleBottomSheet(int experienceIndex, int roleIndex) async {
    final existingRole = _experiences[experienceIndex]['roles'][roleIndex];
    final updatedRole = await showRoleBottomSheet(
      context: context,
      existingRole: existingRole,
    );

    if (updatedRole != null) {
      setState(() {
        _experiences[experienceIndex]['roles'][roleIndex] = updatedRole;
        widget.onSaved(_experiences);
      });
    }
  }

  void _deleteRole(int experienceIndex, int roleIndex) {
    setState(() {
      _experiences[experienceIndex]['roles'].removeAt(roleIndex);
      widget.onSaved(_experiences);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Role deleted successfully!"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _scrollToForm() {
    // Scroll to the bottom where the form is located
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
}
