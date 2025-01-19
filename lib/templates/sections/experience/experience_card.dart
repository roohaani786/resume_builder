// lib/templates/sections/experience/experience_card.dart

import 'package:flutter/material.dart';

class ExperienceCard extends StatelessWidget {
  final Map<String, dynamic> experience;
  final VoidCallback onEditExperience;
  final VoidCallback onDeleteExperience;
  final VoidCallback onAddRole;
  final Function(int) onEditRole;
  final Function(int) onDeleteRole;

  const ExperienceCard({
    Key? key,
    required this.experience,
    required this.onEditExperience,
    required this.onDeleteExperience,
    required this.onAddRole,
    required this.onEditRole,
    required this.onDeleteRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roles = experience['roles'] as List<dynamic>? ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Experience Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${experience['companyName']} - ${experience['jobTitle']}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEditExperience,
                      tooltip: 'Edit Experience',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDeleteExperience,
                      tooltip: 'Delete Experience',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "From: ${_formatDate(experience['from'])} To: ${experience['isCurrent'] == true ? 'Present' : _formatDate(experience['to'])}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              experience['description'] ?? "",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            // Roles
            if (roles.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Roles:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    itemCount: roles.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final role = roles[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(role['title'] ?? ""),
                        subtitle: Text(role['description'] ?? ""),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => onEditRole(index),
                              tooltip: 'Edit Role',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => onDeleteRole(index),
                              tooltip: 'Delete Role',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            // Add Role Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onAddRole,
                icon: const Icon(Icons.add),
                label: const Text("Add Role"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic dt) {
    if (dt == null) return "";
    if (dt is String) return dt;
    if (dt is DateTime) {
      return "${dt.month}/${dt.year}";
    }
    return dt.toString();
  }
}