import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormBackground extends StatelessWidget {
  const FormBackground({
    @required Key key,
    @required this.fields,
    @required this.bottom,
  });

  final List<Widget> fields;
  final List<Widget> bottom;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: key,
      autovalidate: true,
      child: Column(
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
      ),
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
          : InputDecoration(),
      child: field,
    );
  }
}
