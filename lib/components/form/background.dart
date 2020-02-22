import 'package:flutter/material.dart';

class FormBackground extends StatelessWidget {
  const FormBackground({
    @required this.fields,
    @required this.bottom,
  });

  final List<Widget> fields;
  final List<Widget> bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20.0,
                offset: Offset(10, 10),
              ),
            ],
          ),
          child: Column(
            children: fields,
          ),
        ),
        ...bottom
      ],
    );
  }
}

class FormFieldBackground extends StatelessWidget {
  const FormFieldBackground({
    Key key,
    @required this.field,
    this.height,
    this.bottom = false,
  }) : super(key: key);

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
              border: Border(
                bottom: BorderSide(color: Colors.grey[100]),
              ),
            )
          : BoxDecoration(),
      child: field,
    );
  }
}
