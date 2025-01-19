import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ExperienceForm extends StatefulWidget {
  final TextEditingController companyController;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool isCurrentCompany;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<Map<String, dynamic>> roles;
  final ValueChanged<Map<String, dynamic>> onSave;
  final void Function(DateTime?, DateTime?, bool) onUpdateDates;

  const ExperienceForm({
    Key? key,
    required this.companyController,
    required this.titleController,
    required this.descriptionController,
    required this.isCurrentCompany,
    this.fromDate,
    this.toDate,
    this.roles = const [],
    required this.onSave,
    required this.onUpdateDates,
  }) : super(key: key);

  @override
  ExperienceFormState createState() => ExperienceFormState();
}

class ExperienceFormState extends State<ExperienceForm> {
  // Local state for dates and current company toggle
  DateTime? _localFromDate;
  DateTime? _localToDate;
  bool _isCurrentCompany = false;

  // Local state for roles
  List<Map<String, dynamic>> _roles = [];

  // Local controllers for Autocomplete
  late TextEditingController _companyAutoCompleteController;
  late TextEditingController _titleAutoCompleteController;

  // Suggestions for autocomplete fields
  final List<String> _companySuggestions = [
    "Google",
    "Microsoft",
    "Amazon",
    "Apple",
    "Meta",
    "Tesla",
    "Oracle",
    "IBM",
    "Salesforce",
    "Adobe"
  ];

  final List<String> _jobProfileSuggestions = [
    "Software Developer",
    "Backend Developer",
    "App Developer",
    "Cloud Engineer",
    "Data Scientist",
    "Cybersecurity Analyst"
  ];

  final Map<String, List<String>> _jobDescriptions = {
    "Software Developer": [
      "Developed scalable applications, ensuring high performance and availability.",
      "Collaborated with cross-functional teams to design and deliver innovative software solutions.",
    ],
    "Backend Developer": [
      "Designed and maintained RESTful APIs to support frontend applications.",
      "Integrated third-party services and optimized backend processes.",
    ],
    "App Developer": [
      "Developed and deployed mobile applications for Android and iOS platforms.",
      "Collaborated with UI/UX teams to ensure seamless user experiences.",
    ],
    "Cloud Engineer": [
      "Managed cloud infrastructure, ensuring scalability and security.",
      "Implemented CI/CD pipelines to streamline development processes.",
    ],
    "Data Scientist": [
      "Analyzed large datasets to derive actionable insights.",
      "Developed machine learning models to predict key business metrics.",
    ],
    "Cybersecurity Analyst": [
      "Monitored network traffic to detect and respond to security threats.",
      "Implemented security protocols to safeguard sensitive information.",
    ],
  };

  @override
  void initState() {
    super.initState();
    _localFromDate = widget.fromDate;
    _localToDate = widget.toDate;
    _isCurrentCompany = widget.isCurrentCompany;
    _roles = List<Map<String, dynamic>>.from(widget.roles);

    // Initialize local controllers and synchronize with widget controllers
    _companyAutoCompleteController = TextEditingController(text: widget.companyController.text);
    _companyAutoCompleteController.addListener(() {
      if (widget.companyController.text != _companyAutoCompleteController.text) {
        widget.companyController.text = _companyAutoCompleteController.text;
      }
    });

    _titleAutoCompleteController = TextEditingController(text: widget.titleController.text);
    _titleAutoCompleteController.addListener(() {
      if (widget.titleController.text != _titleAutoCompleteController.text) {
        widget.titleController.text = _titleAutoCompleteController.text;
      }
    });
  }

  @override
  void dispose() {
    _companyAutoCompleteController.dispose();
    _titleAutoCompleteController.dispose();
    super.dispose();
  }

  // Method to submit the form
  void submitForm() {
    // Debugging logs to verify values
    print("Company: '${widget.companyController.text}'");
    print("Title: '${widget.titleController.text}'");
    print("Description: '${widget.descriptionController.text}'");
    print("FromDate: $_localFromDate");
    print("ToDate: $_localToDate");
    print("isCurrentCompany: $_isCurrentCompany");

    if (widget.companyController.text.trim().isEmpty ||
        widget.titleController.text.trim().isEmpty ||
        _localFromDate == null ||
        (!_isCurrentCompany && _localToDate == null)) {
      _showSnackBar('Please fill all required fields.');
      return;
    }

    final experienceData = {
      'companyName': widget.companyController.text.trim(),
      'jobTitle': widget.titleController.text.trim(),
      'description': widget.descriptionController.text.trim(),
      'isCurrent': _isCurrentCompany,
      'from': _localFromDate,
      'to': _isCurrentCompany ? null : _localToDate,
      'roles': _roles,
      'timestamp': DateTime.now(), // For sorting purposes
    };

    widget.onSave(experienceData);
  }

  // Method to show SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Method to generate a random job description
  void _generateRandomDescription() {
    String title = widget.titleController.text.trim();
    List<String>? descriptions = _jobDescriptions[title];
    if (descriptions != null && descriptions.isNotEmpty) {
      Random random = Random();
      String randomDescription =
      descriptions[random.nextInt(descriptions.length)];
      widget.descriptionController.text = randomDescription;
      setState(() {});
    } else {
      _showSnackBar("No descriptions available for the selected job title.");
    }
  }

  // Method to show From Date Picker
  void _showFromDatePicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select From Date"),
          content: SizedBox(
            width: 300,
            height: 400,
            child: SfDateRangePicker(
              initialSelectedDate: _localFromDate,
              selectionMode: DateRangePickerSelectionMode.single,
              minDate: DateTime(1900),
              maxDate: DateTime.now(),
              onSelectionChanged:
                  (DateRangePickerSelectionChangedArgs args) {
                if (args.value is DateTime) {
                  setState(() {
                    _localFromDate = args.value as DateTime;
                    if (_isCurrentCompany) {
                      _localToDate = null;
                    }
                  });
                  widget.onUpdateDates(
                      _localFromDate, _localToDate, _isCurrentCompany);
                  print("Updated From Date: ${args.value}"); // Debug log
                  Navigator.pop(context); // Close the dialog after selection
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Method to show To Date Picker
  void _showToDatePicker() {
    if (_isCurrentCompany) return; // Do not show if current company is selected

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select To Date"),
          content: SizedBox(
            width: 300,
            height: 400,
            child: SfDateRangePicker(
              initialSelectedDate: _localToDate,
              selectionMode: DateRangePickerSelectionMode.single,
              minDate: _localFromDate ?? DateTime(1900),
              maxDate: DateTime.now(),
              onSelectionChanged:
                  (DateRangePickerSelectionChangedArgs args) {
                if (args.value is DateTime) {
                  setState(() {
                    _localToDate = args.value as DateTime;
                  });
                  widget.onUpdateDates(
                      _localFromDate, _localToDate, _isCurrentCompany);
                  print("Updated To Date: ${args.value}"); // Debug log
                  Navigator.pop(context); // Close the dialog after selection
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Method to add a new role
  void _addRole() {
    final roleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Role"),
          content: TextField(
            controller: roleController,
            decoration: const InputDecoration(
              labelText: "Role",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (roleController.text.trim().isNotEmpty) {
                  setState(() {
                    _roles.add({'role': roleController.text.trim()});
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Method to remove a role by index
  void _removeRole(int index) {
    setState(() {
      _roles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // To prevent overflow when keyboard appears
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Name Autocomplete
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              return _companySuggestions.where((String option) {
                return option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              widget.companyController.text = selection;
            },
            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
              // Use the local controller
              return TextField(
                controller: _companyAutoCompleteController,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                  hintText: 'Type or select a company name',
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Job Title Autocomplete
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              return _jobProfileSuggestions.where((String option) {
                return option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              widget.titleController.text = selection;
              widget.descriptionController.clear(); // Clear description for new job title
            },
            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
              // Use the local controller
              return TextField(
                controller: _titleAutoCompleteController,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: 'Job Title',
                  border: OutlineInputBorder(),
                  hintText: 'Type or select a job title',
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Description Field
          TextField(
            controller: widget.descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Job Description',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.auto_fix_high),
                onPressed: _generateRandomDescription,
                tooltip: "Generate Description",
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Current Company Toggle
          CheckboxListTile(
            value: _isCurrentCompany,
            onChanged: (value) {
              setState(() {
                _isCurrentCompany = value ?? false;
                if (_isCurrentCompany) {
                  _localToDate = null; // Clear toDate if current company is selected
                }
                widget.onUpdateDates(
                    _localFromDate, _localToDate, _isCurrentCompany);
              });
            },
            title: const Text("This is my current company"),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 16),

          // Date Pickers
          Row(
            children: [
              // From Date
              Expanded(
                child: InkWell(
                  onTap: _showFromDatePicker,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _localFromDate != null
                          ? "${_localFromDate!.day}/${_localFromDate!.month}/${_localFromDate!.year}"
                          : "Select Date",
                      style: TextStyle(
                        color: _localFromDate != null
                            ? Colors.black
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // To Date
              Expanded(
                child: InkWell(
                  onTap: _isCurrentCompany ? null : _showToDatePicker,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _isCurrentCompany
                          ? "Present"
                          : _localToDate != null
                          ? "${_localToDate!.day}/${_localToDate!.month}/${_localToDate!.year}"
                          : "Select Date",
                      style: TextStyle(
                        color: _isCurrentCompany
                            ? Colors.green
                            : (_localToDate != null
                            ? Colors.black
                            : Colors.grey[600]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Roles Management
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Roles",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (_roles.isEmpty)
                const Text(
                  "No roles added.",
                  style: TextStyle(color: Colors.grey),
                ),
              ..._roles.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> role = entry.value;
                return Card(
                  color: index == 0 ? Colors.amber[100] : Colors.white,
                  child: ListTile(
                    leading: Icon(
                      index == 0 ? Icons.star : Icons.work_outline,
                      color: index == 0 ? Colors.amber : Colors.grey,
                    ),
                    title: Text(role['role']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeRole(index),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _addRole,
                icon: const Icon(Icons.add, color: Colors.white,),
                label: const Text("Add Role",
                  style: TextStyle(
                      color: Colors.white
                  ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Save Button
          Center(
            child: ElevatedButton(
              onPressed: submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Experience',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
