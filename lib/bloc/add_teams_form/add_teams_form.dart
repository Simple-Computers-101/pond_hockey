import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';

class AddTeamsFormBloc extends FormBloc<String, String> {
  AddTeamsFormBloc({this.tournament}) : super(isLoading: true);

  final Tournament tournament;

  @override
  Stream<FormBlocState<String, String>> onLoading() async* {
    await addPreExistingTeamFields();
    yield state.toLoaded();
  }

  Future<void> addPreExistingTeamFields() async {
    var teams = await TeamsRepository().getTeamsFromTournamentId(tournament.id);
    for (var team in teams) {
      addTeamField(name: team.name);
    }
  }

  void addTeamField({String name}) {
    addFieldBloc(
      path: 'teams',
      fieldBloc: TextFieldBloc(
        name: 'teamName',
        initialValue: name ?? '',
        validators: [FieldBlocValidators.requiredTextFieldBloc],
      ),
    );
  }

  void removeTeamField(int index) {
    removeFieldBloc(path: 'teams/[$index]');
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    yield state.toSuccess();
  }
}
