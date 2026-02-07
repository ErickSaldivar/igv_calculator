import 'package:flutter/material.dart';

class TextFieldModelo extends StatelessWidget {
  const TextFieldModelo({
    super.key,
    required this.w,
    required this.label,
    required this.textController,
    required this.isEnabled,
    required this.onChanged,
    this.focusNode,
  });

  final double w;
  final String label;
  final TextEditingController textController;
  final bool isEnabled;
  final FocusNode? focusNode;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w * 0.8,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 242, 245, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: textController,
        enabled: isEnabled,
        onChanged: onChanged,
        focusNode: focusNode,

        decoration: InputDecoration(
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          label: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(124, 141, 159, 1),
            ),
          ),
        ),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
