import 'package:flutter/material.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/router/router.gr.dart';

class FilterDivisionDialog extends StatefulWidget {
  const FilterDivisionDialog({@required this.onDivisionChanged, this.division});

  final ValueChanged<Division> onDivisionChanged;
  final Division division;

  @override
  _FilterDivisionDialogState createState() => _FilterDivisionDialogState();
}

class _FilterDivisionDialogState extends State<FilterDivisionDialog> {
  Division _selected;

  @override
  void initState() { 
    super.initState();
    _selected = widget.division;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose Division'),
      content: DropdownButton<Division>(
        items: [
          DropdownMenuItem<Division>(
            child: Text('All'),
            value: null,
          ),
          DropdownMenuItem<Division>(
            child: Text('Open'),
            value: Division.open,
          ),
          DropdownMenuItem<Division>(
            child: Text('Recreational'),
            value: Division.rec,
          ),
        ],
        value: _selected,
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            _selected = value;
          });
        },
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Router.navigator.pop();
            widget.onDivisionChanged(_selected);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
