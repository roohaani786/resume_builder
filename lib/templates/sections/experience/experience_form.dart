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

  DateTime? _localFromDate;
  DateTime? _localToDate;

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
    ]
  };

  void submitForm() {
    if (widget.companyController.text.isEmpty ||
        widget.titleController.text.isEmpty ||
        widget.fromDate == null ||
        (!widget.isCurrentCompany && widget.toDate == null)) {
      _showSnackBar('Please fill all required fields.');
      return;
    }


    final experienceData = {
      'companyName': widget.companyController.text.trim(),
      'jobTitle': widget.titleController.text.trim(),
      'description': widget.descriptionController.text.trim(),
      'isCurrent': widget.isCurrentCompany,
      'from': widget.fromDate,
      'to': widget.isCurrentCompany ? null : widget.toDate,
      'roles': widget.roles,
    };

    widget.onSave(experienceData);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
              initialSelectedDate: widget.fromDate,
              selectionMode: DateRangePickerSelectionMode.single,
              minDate: DateTime(1900),
              maxDate: DateTime.now(),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is DateTime) {
                  widget.onUpdateDates(
                    args.value as DateTime,
                    widget.toDate,
                    widget.isCurrentCompany,
                  );
                  print("Updated From Date: ${args.value}"); // Debug log
                  _localFromDate = args.value;
                  setState(() {});
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }


  void _showToDatePicker() {
    if (!widget.isCurrentCompany) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Select To Date"),
            content: SizedBox(
              width: 300, // Set a fixed width
              height: 400, // Set a fixed height
              child: SfDateRangePicker(
                initialSelectedDate: widget.toDate,
                selectionMode: DateRangePickerSelectionMode.single,
                minDate: widget.fromDate ?? DateTime(1900),
                maxDate: DateTime.now(),
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is DateTime) {
                    widget.onUpdateDates(
                      widget.fromDate, // Keep fromDate
                      args.value as DateTime, // Update toDate
                      widget.isCurrentCompany,
                    );
                    _localToDate = args.value;
                    setState(() {});
                  }
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _localFromDate = widget.fromDate;
    _localToDate = widget.toDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            widget.companyController.text = controller.text;
            return TextField(
              controller: controller,
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
            widget.titleController.text = controller.text;
            return TextField(
              controller: controller,
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
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // To Date
            Expanded(
              child: InkWell(
                onTap: _showToDatePicker,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'To',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    widget.isCurrentCompany
                        ? "Present"
                        : _localToDate != null
                        ? "${_localToDate!.day}/${_localToDate!.month}/${_localToDate!.year}"
                        : "Select Date",
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Save Button
        ElevatedButton(
          onPressed: submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Save Experience',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
