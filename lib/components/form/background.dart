import 'package:flutter/material.dart';

class FormFieldBackground extends StatelessWidget {
  const FormFieldBackground({
    @required this.field,
    this.height,
    this.bottom = false,
  });

  final double height;
  final Widget field;
  final bool bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: height,
      decoration: !bottom
          ? BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[100]),
              ),
            )
          : BoxDecoration(
              color: Colors.white,
            ),
      child: field,
    );
  }
}
