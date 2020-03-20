import 'package:flutter/material.dart';

class BigCircleButton extends StatelessWidget {
  const BigCircleButton({
    @required this.onTap,
    @required this.text,
  });

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(fontSize: 32),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: onTap,
            iconSize: 48,
            padding: const EdgeInsets.all(24),
          ),
        ),
      ],
    );
  }
}
