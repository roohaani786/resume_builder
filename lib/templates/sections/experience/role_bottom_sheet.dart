// lib/templates/sections/experience/role_bottom_sheet.dart

import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showRoleBottomSheet({
  required BuildContext context,
  Map<String, dynamic>? existingRole,
}) {
  final TextEditingController titleController = TextEditingController(
    text: existingRole?['title'] ?? '',
  );
  final TextEditingController descriptionController = TextEditingController(
    text: existingRole?['description'] ?? '',
  );
  DateTime? fromDate = existingRole?['from'];
  DateTime? toDate = existingRole?['to'];
  bool isCurrentRole = existingRole?['isCurrent'] ?? false;

  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            Future<void> _selectFromDate() async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: fromDate ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != fromDate) {
                setState(() {
                  fromDate = picked;
                });
              }
            }

            Future<void> _selectToDate() async {
              if (isCurrentRole) return; // Disable if current role
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: toDate ?? DateTime.now(),
                firstDate: fromDate ?? DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != toDate) {
                setState(() {
                  toDate = picked;
                });
              }
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role Title
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Role Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Role Description
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Role Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date Pickers
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _selectFromDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'From',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(fromDate != null
                                ? "${fromDate!.month}/${fromDate!.year}"
                                : "Select Date"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: isCurrentRole ? null : _selectToDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'To',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(isCurrentRole
                                ? "Present"
                                : toDate != null
                                ? "${toDate!.month}/${toDate!.year}"
                                : "Select Date"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Is Current Role Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: isCurrentRole,
                        onChanged: (val) {
                          setState(() {
                            isCurrentRole = val ?? false;
                            if (isCurrentRole) {
                              toDate = null;
                            }
                          });
                        },
                      ),
                      const Text("Current Role"),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Save Button
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Role title is required.')),
                        );
                        return;
                      }

                      final roleData = {
                        'title': titleController.text.trim(),
                        'description': descriptionController.text.trim(),
                        'from': fromDate,
                        'to': isCurrentRole ? null : toDate,
                        'isCurrent': isCurrentRole,
                      };

                      Navigator.pop(context, roleData);
                    },
                    child: const Text('Save Role'),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}