import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';

class ManageGameFormBloc extends FormBloc<String, String> {
  ManageGameFormBloc({@required this.game}) {
    addFieldBloc(
      fieldBloc: InputFieldBloc<int>(
        name: 'team-one_score',
        initialValue: game.teamOne.score ?? 0,
        validators: [FieldBlocValidators.requiredInputFieldBloc],
      ),
    );
    addFieldBloc(
      fieldBloc: InputFieldBloc<int>(
        name: 'team-two_score',
        initialValue: game.teamTwo.score ?? 0,
        validators: [FieldBlocValidators.requiredInputFieldBloc],
      ),
    );
  }

  final Game game;

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    final teamOneField =
        state.fieldBlocFromPath('team-one_score').asInputFieldBloc<int>();
    final teamTwoField =
        state.fieldBlocFromPath('team-two_score').asInputFieldBloc<int>();

    if ((game.teamOne.score == teamOneField.value) ||
        (game.teamTwo.score == teamTwoField.value)) {
      yield state.toSuccess(successResponse: 'The scores were the same');
    }

    GamesRepository().updateScores(
      game.id,
      teamOneField.value,
      teamTwoField.value,
    );

    yield state.toSuccess();
  }
}
