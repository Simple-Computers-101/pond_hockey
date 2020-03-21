import 'package:flutter/material.dart';
import 'package:pond_hockey/theme/dialog.dart';

class PrimaryDialogButton extends StatelessWidget {
  const PrimaryDialogButton({@required this.onPressed, @required this.text});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text),
      onPressed: onPressed,
      shape: DialogStyles.shape,
      textColor: DialogStyles.primaryTextColor,
      color: DialogStyles.primaryButtonColor,
    );
  }
}

class SecondaryDialogButton extends StatelessWidget {
  const SecondaryDialogButton({@required this.onPressed, @required this.text});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text),
      onPressed: onPressed,
      textColor: DialogStyles.secondaryTextColor,
    );
  }
}
