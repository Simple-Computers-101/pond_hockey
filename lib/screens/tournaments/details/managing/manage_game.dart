import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pond_hockey/bloc/manage_game_form/manage_game_form.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/components/buttons/gradient_btn.dart';
import 'package:pond_hockey/enums/game_status.dart';
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
                  Text(
                    'Press "Submit" to save',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
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
    return FormBlocListener<ManageGameFormBloc, String, String>(
      onSubmitting: (_, __) => Center(child: CircularProgressIndicator()),
      onSuccess: (context, _) {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Score has been updated'),
        ));
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
                            onPressed: () {
                              if (state.value > 0) {
                                oneField.updateValue(state.value - 1);
                              } else {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Score can not be below 0'),
                                    duration: Duration(milliseconds: 500),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Text(
                          '${state.value}',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.1,
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
                            onPressed: () {
                              oneField.updateValue(state.value + 1);
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
                            onPressed: () {
                              if (state.value > 0) {
                                twoField.updateValue(state.value - 1);
                              } else {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Score can not be below 0'),
                                    duration: Duration(milliseconds: 500),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Text(
                          '${state.value}',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.1,
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
                            onPressed: () {
                              twoField.updateValue(state.value + 1);
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
                DropdownFieldBlocBuilder<GameStatus>(
                  selectFieldBloc: formState
                      .fieldBlocFromPath('game-state')
                      .asSelectFieldBloc(),
                  itemBuilder: (context, value) => gameStatus[value],
                  showEmptyItem: false,
                  padding: EdgeInsets.zero,
                  decoration: InputDecoration(
                    labelText: 'Game state',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                BlocBuilder<InputFieldBloc<DateTime>, InputFieldBlocState>(
                  bloc: formState
                      .fieldBlocFromPath('game-time')
                      .asInputFieldBloc<DateTime>(),
                  builder: (context, state) {
                    var lanCode = Localizations.localeOf(context).languageCode;
                    var use24Hour =
                        MediaQuery.of(context).alwaysUse24HourFormat;
                    var format = use24Hour
                        ? DateFormat('yyyy-MM-dd HH:mm', lanCode)
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
                          formState
                              .fieldBlocFromPath('game-time')
                              .asInputFieldBloc<DateTime>()
                              .updateValue(combined);
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
                  text: 'Submit',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
