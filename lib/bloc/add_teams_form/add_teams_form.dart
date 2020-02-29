import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';
import 'package:uuid/uuid.dart';

class AddTeamsFormBloc extends FormBloc<String, String> {
  AddTeamsFormBloc({this.tournament}) {
    addFieldBloc(
      fieldBloc:
          SelectFieldBloc<Map<String, dynamic>>(name: 'division', items: [
        {'name': 'Open', 'value': Division.open},
        {'name': 'Recreational', 'value': Division.rec},
      ], validators: [
        FieldBlocValidators.requiredSelectFieldBloc
      ]),
    );
    addFieldBloc(fieldBloc: FieldBlocList(name: 'teams', fieldBlocs: []));
  }

  final Tournament tournament;

  void addTeamField({String name}) {
    addFieldBloc(
      path: 'teams',
      fieldBloc: TextFieldBloc(
        name: 'teamName',
        initialValue: name,
        validators: [FieldBlocValidators.requiredTextFieldBloc],
      ),
    );
  }

  void removeTeamField(int index) {
    removeFieldBloc(path: 'teams/[$index]');
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    final division = state
        .fieldBlocFromPath('division')
        .asSelectFieldBloc<Map<String, dynamic>>()
        .value['value'] as Division;
    final teams = state
        .fieldBlocFromPath('teams')
        .asFieldBlocList
        .map((e) => e.asTextFieldBloc)
        .where((element) => element.value.isNotEmpty)
        .map((e) {
      return Team(
        currentTournament: tournament.id,
        division: division,
        id: Uuid().v4(),
        name: e.value.trim(),
        pointDifferential: 0,
        gamesLost: 0,
        gamesPlayed: 0,
        gamesWon: 0,
      );
    }).toList(growable: false);

    await TeamsRepository().addTeamsToTournament(teams);

    yield state.toSuccess();
  }
}
