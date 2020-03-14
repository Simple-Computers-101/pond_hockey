import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pond_hockey/bloc/manage_game_form/manage_game_form.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/components/buttons/gradient_btn.dart';
import 'package:pond_hockey/models/game.dart';

class ManageGame extends StatelessWidget {
  const ManageGame({this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    var teamNameStyle = TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.05,
      fontFamily: 'CircularStd',
    );

    return BlocProvider<ManageGameFormBloc>(
      create: (_) => ManageGameFormBloc(game: game),
      child: Builder(
        builder: (context) {
          final formBloc = context.bloc<ManageGameFormBloc>();
          return Scaffold(
            appBar: CustomAppBar(title: 'Manage Game'),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  Text(game.teamOne.name, style: teamNameStyle),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE9E9E9),
                    ),
                    child: Text(
                      'vs',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.05,
                        fontFamily: 'CircularStd',
                      ),
                    ),
                  ),
                  Text(game.teamTwo.name, style: teamNameStyle),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  _ManageGameForm(formBloc: formBloc),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ManageGameForm extends StatelessWidget {
  const _ManageGameForm({@required this.formBloc});

  final ManageGameFormBloc formBloc;

  @override
  Widget build(BuildContext context) {
    void _showSnackbar(String message) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(message),
      ));
    }

    return FormBlocListener<ManageGameFormBloc, String, String>(
      onSubmitting: (_, __) => Center(child: CircularProgressIndicator()),
      onSuccess: (context, _) {
        _showSnackbar('Score has been updated');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: BlocBuilder<ManageGameFormBloc, FormBlocState>(
          builder: (context, formState) {
            if (formState.fieldBlocs.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            var oneField = formState
                .fieldBlocFromPath('team-one_score')
                .asInputFieldBloc<int>();
            var twoField = formState
                .fieldBlocFromPath('team-two_score')
                .asInputFieldBloc<int>();
            var gameState = formState
                .fieldBlocFromPath('game-complete-state')
                .asBooleanFieldBloc;
            var gameTime = formState
                .fieldBlocFromPath('game-time')
                .asInputFieldBloc<DateTime>();
            return Column(
              children: <Widget>[
                BlocBuilder<InputFieldBloc<int>, InputFieldBlocState<int>>(
                  bloc: oneField,
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE9E9E9),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.remove),
                            padding: const EdgeInsets.all(48),
                            color: gameState.value
                                ? Color(0xFFadadad)
                                : Colors.black,
                            onPressed: () {
                              if (gameState.value == false) {
                                if (state.value > 0) {
                                  oneField.updateValue(state.value - 1);
                                } else {
                                  _showSnackbar('Score can not be below 0');
                                }
                              } else {
                                _showSnackbar('Game is complete');
                              }
                            },
                          ),
                        ),
                        Text(
                          '${state.value}',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.1,
                            color: gameState.value
                                ? Color(0xFFadadad)
                                : Colors.black,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE9E9E9),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(48),
                            icon: Icon(Icons.add),
                            color: gameState.value
                                ? Color(0xFFadadad)
                                : Colors.black,
                            onPressed: () {
                              if (gameState.value == false) {
                                oneField.updateValue(state.value + 1);
                              } else {
                                _showSnackbar('Game is complete');
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                BlocBuilder<InputFieldBloc<int>, InputFieldBlocState<int>>(
                  bloc: twoField,
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE9E9E9),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(48),
                            icon: Icon(Icons.remove),
                            color: gameState.value
                                ? Color(0xFFadadad)
                                : Colors.black,
                            onPressed: () {
                              if (gameState.value == false) {
                                if (state.value > 0) {
                                  twoField.updateValue(state.value - 1);
                                } else {
                                  _showSnackbar('Score can not be below 0');
                                }
                              } else {
                                _showSnackbar('Game is complete');
                              }
                            },
                          ),
                        ),
                        Text(
                          '${state.value}',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.1,
                            color: gameState.value
                                ? Color(0xFFadadad)
                                : Colors.black,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE9E9E9),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(48),
                            color: gameState.value
                                ? Color(0xFFadadad)
                                : Colors.black,
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (gameState.value == false) {
                                twoField.updateValue(state.value + 1);
                              } else {
                                _showSnackbar('Game is complete');
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                BlocBuilder<BooleanFieldBloc, BooleanFieldBlocState>(
                  bloc: gameState,
                  builder: (context, state) {
                    return RaisedButton(
                      onPressed: () {
                        if (state.value == true) {
                          gameState.updateValue(false);
                        } else {
                          gameState.updateValue(true);
                        }
                      },
                      child: Text(
                        'Mark as ${state.value ? 'not complete' : 'complete'}',
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                BlocBuilder<InputFieldBloc<DateTime>,
                    InputFieldBlocState<DateTime>>(
                  bloc: gameTime,
                  builder: (context, state) {
                    var lanCode = Localizations.localeOf(context).languageCode;
                    var use24Hour =
                        MediaQuery.of(context).alwaysUse24HourFormat;
                    var format = use24Hour
                        ? DateFormat('yyyy-MM-dd', lanCode).add_Hm()
                        : DateFormat('yyyy-MM-dd', lanCode).add_jm();
                    var now = DateTime.now();
                    return DateTimeField(
                      format: format,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Start date',
                        errorText: state.error,
                      ),
                      initialValue: state.value,
                      onShowPicker: (context, value) async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: value ?? now,
                          firstDate: now,
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              value ?? now,
                            ),
                          );
                          final combined = DateTimeField.combine(date, time);
                          gameTime.updateValue(combined);
                          return combined;
                        } else {
                          formState
                              .fieldBlocFromPath('game-time')
                              .asInputFieldBloc<DateTime>()
                              .updateValue(value);
                          return value;
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 40),
                GradientButton(
                  onTap: formBloc.submit,
                  colors: [
                    Color.fromRGBO(255, 65, 109, 1),
                    Color.fromRGBO(255, 75, 43, 1),
                  ],
                  height: MediaQuery.of(context).size.height * 0.15,
                  text: 'Save',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
