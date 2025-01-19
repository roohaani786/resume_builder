import 'package:flutter/material.dart';

class CreateResumeScreen extends StatelessWidget {
  const CreateResumeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Resume'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Select Your Field',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...List.generate(6, (index) => _buildFieldCard('Field $index')),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Continue'),
          )
        ],
      ),
    );
  }

  Widget _buildFieldCard(String title) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Logic for selecting the field
        },
      ),
    );
  }
}