import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextfieldChange extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final VoidCallback onTap;
  const TextfieldChange({
    super.key,
    required this.controller,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: text,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.numbers),
            ),
          ),
        ),
        const SizedBox(width: 8), // Khoảng cách giữa TextField và nút
        ElevatedButton(onPressed: onTap, child: Text("Change")),
      ],
    );
  }
}
