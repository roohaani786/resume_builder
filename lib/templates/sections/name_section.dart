import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class NameSection extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final ValueChanged<Map<String, dynamic>> onSaved;

  const NameSection({
    Key? key,
    required this.initialData,
    required this.onSaved,
  }) : super(key: key);

  @override
  State<NameSection> createState() => _NameSectionState();
}

class _NameSectionState extends State<NameSection> {
  final _formKey = GlobalKey<FormState>();

  String _countryCode = "+1"; // Default country code
  String _countryFlag = "🇺🇸"; // Default country flag
  String _fullName = "";
  String _email = "";
  String _phone = "";

  bool _showPreview = false; // Toggle live preview visibility

  @override
  void initState() {
    super.initState();

    // If we have saved data from parent, populate the fields:
    if (widget.initialData.isNotEmpty) {
      _fullName = widget.initialData["fullName"] ?? "";
      _email = widget.initialData["email"] ?? "";
      _phone = widget.initialData["phone"] ?? "";
      _countryCode = widget.initialData["countryCode"] ?? "+1";
      _countryFlag = widget.initialData["countryFlag"] ?? "🇺🇸";
    }

    // Decide whether preview should show
    _showPreview =
        _fullName.isNotEmpty || _email.isNotEmpty || _phone.isNotEmpty;
  }

  bool _isFormValid = false; // Track if the form is valid

  void _validateForm() {
    // Check if the form is valid and all fields are filled
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false &&
          _fullName.isNotEmpty &&
          _email.isNotEmpty &&
          _phone.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Name and Contact Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Full Name Field
              _buildSmoothInputField(
                labelText: "Full Name",
                icon: Icons.person,
                initialValue: _fullName,
                onChanged: (value) {
                  setState(() {
                    _fullName = value;
                    _validateForm();
                    _togglePreview();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Address Field
              _buildSmoothInputField(
                labelText: "Email Address",
                icon: Icons.email,
                initialValue: _email,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                    _validateForm();
                    _togglePreview();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Number Field with Country Picker
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        onSelect: (Country country) {
                          setState(() {
                            _countryCode = "+${country.phoneCode}";
                            _countryFlag = country.flagEmoji;
                            _validateForm();
                            _togglePreview();
                          });
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 16.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade100,
                      ),
                      child: Row(
                        children: [
                          Text(_countryFlag, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Text(_countryCode, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSmoothInputField(
                      labelText: "Phone Number",
                      icon: Icons.phone,
                      initialValue: _phone,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          _phone = value;
                          _validateForm();
                          _togglePreview();
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Real-time Preview with Animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _showPreview ? _buildPreview() : const SizedBox.shrink(),
              ),

              const SizedBox(height: 20),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _isFormValid ? _handleSave : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    backgroundColor:
                    _isFormValid ? Colors.purple : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadowColor: Colors.purpleAccent,
                    elevation: _isFormValid ? 5 : 0,
                  ),
                  child: const Text(
                    'Save Information',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSmoothInputField({
    required String labelText,
    required IconData icon,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      initialValue: initialValue ?? '',
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.purple),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.purple, width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Preview:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (_fullName.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.person, color: Colors.purple),
                const SizedBox(width: 8),
                Text("Name: $_fullName", style: const TextStyle(fontSize: 16)),
              ],
            ),
          if (_email.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.email, color: Colors.purple),
                const SizedBox(width: 8),
                Text("Email: $_email", style: const TextStyle(fontSize: 16)),
              ],
            ),
          if (_phone.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  "Phone: $_countryFlag $_countryCode $_phone",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _togglePreview() {
    setState(() {
      _showPreview = _fullName.isNotEmpty ||
          _email.isNotEmpty ||
          _phone.isNotEmpty;
    });
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // Construct the data map for the parent
      final dataToSave = {
        "fullName": _fullName,
        "email": _email,
        "phone": _phone,
        "countryCode": _countryCode,
        "countryFlag": _countryFlag,
      };

      widget.onSaved(dataToSave); // Send this to parent

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Saved successfully!',
            style: TextStyle(fontSize: 16),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}