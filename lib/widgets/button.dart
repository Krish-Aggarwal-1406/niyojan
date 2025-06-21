import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function? onTap;
  final String? label;

  Button({
    this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xFF4169E1);

    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        height: 50,
        width: 130,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label ?? "",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
