import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pond_hockey/enums/game_status.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';

class ManageGameFormBloc extends FormBloc<String, String> {
  final Game game;

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
    addFieldBloc(
      fieldBloc: BooleanFieldBloc(
        name: 'game-complete-state',
        initialValue: game.status == GameStatus.finished,
      ),
    );
    addFieldBloc(
      fieldBloc: InputFieldBloc<DateTime>(
        name: 'game-time',
        initialValue: game.startDate,
      ),
    );
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    yield state.toLoading();

    final teamOneField =
        state.fieldBlocFromPath('team-one_score').asInputFieldBloc<int>();
    final teamTwoField =
        state.fieldBlocFromPath('team-two_score').asInputFieldBloc<int>();
    final statusField =
        state.fieldBlocFromPath('game-complete-state').asBooleanFieldBloc;
    final dateField =
        state.fieldBlocFromPath('game-time').asInputFieldBloc<DateTime>();

    if ((game.teamOne.score == teamOneField.value) ||
        (game.teamTwo.score == teamTwoField.value)) {
      yield state.toSuccess(successResponse: 'The scores were the same');
    }

    await GamesRepository().updateScores(
      game.id,
      teamOneField.value,
      teamTwoField.value,
    );

    if (dateField.value != null) {
      await GamesRepository().updateGame(
        game.id,
        {'startDate': dateField.value},
      );
    }

    await TeamsRepository().calculateDifferential(game.teamOne.id);
    await TeamsRepository().calculateDifferential(game.teamTwo.id);

    await GamesRepository().updateStatus(
      game.id,
      isComplete: statusField.value,
    );

    yield state.toSuccess(canSubmitAgain: true);
  }
}
