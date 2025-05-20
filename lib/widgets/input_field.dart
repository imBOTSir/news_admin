import 'package:flutter/material.dart';

import '../config/responsive.dart';
import '../config/size_config.dart';

class LabeledInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final BuildContext context;

  const LabeledInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(this.context);
    final double width = isDesktop ? SizeConfig.screenWidth * 0.4 : double.infinity;

    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
        ),
      ),
    );
  }
}

