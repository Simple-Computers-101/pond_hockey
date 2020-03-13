import 'package:flutter/material.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/screens/tournaments/widgets/filter_division_dialog.dart';
import 'package:pond_hockey/screens/tournaments/widgets/filter_gametype_dialog.dart';
import 'package:pond_hockey/screens/tournaments/widgets/seeding_settings_dialog.dart';

class FilterGamesButtons extends StatelessWidget {
  const FilterGamesButtons({
    @required Division selectedDivision,
    @required GameType selectedGameType,
    @required bool isSeeding,
    @required SeedingSubmit onSeedingSubmitted,
    @required ValueChanged<Division> onDivisionChanged,
    @required ValueChanged<GameType> onGameTypeChanged,
  })  : _selectedDivision = selectedDivision,
        _selectedGameType = selectedGameType,
        _isSeeding = isSeeding,
        _onSeedingSubmitted = onSeedingSubmitted,
        _onDivisionChanged = onDivisionChanged,
        _onGameTypeChanged = onGameTypeChanged;

  final Division _selectedDivision;
  final GameType _selectedGameType;
  final bool _isSeeding;
  final SeedingSubmit _onSeedingSubmitted;
  final ValueChanged<Division> _onDivisionChanged;
  final ValueChanged<GameType> _onGameTypeChanged;

  @override
  Widget build(BuildContext context) {
    void _showSeedingSettingsDialog() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SeedingSettingsDialog(
            onSubmit: _onSeedingSubmitted,
          );
        },
      );
    }

    void _showFilterDivisionDialog() {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return FilterDivisionDialog(
            division: _selectedDivision,
            onDivisionChanged: _onDivisionChanged,
          );
        },
      );
    }

    void _showFilterGameTypeDialog() {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return FilterGameTypeDialog(
            gameType: _selectedGameType,
            onGameTypeChanged: _onGameTypeChanged,
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton.icon(
          onPressed: _showFilterDivisionDialog,
          padding: EdgeInsets.zero,
          icon: Icon(Icons.filter_list),
          label: Text(
            'Division: ${divisionMap[_selectedDivision] ?? 'All'}',
          ),
        ),
        FlatButton.icon(
          onPressed: _showFilterGameTypeDialog,
          padding: EdgeInsets.zero,
          icon: Icon(Icons.filter_list),
          label: Text(
            'Type: ${gameType[_selectedGameType] ?? 'All'}',
          ),
        ),
        if (_isSeeding)
          FlatButton.icon(
            onPressed: _showSeedingSettingsDialog,
            padding: EdgeInsets.zero,
            icon: Icon(Icons.refresh),
            label: Text('Re-seed'),
          ),
      ],
    );
  }
}
