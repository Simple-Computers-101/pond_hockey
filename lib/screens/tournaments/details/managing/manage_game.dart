import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pond_hockey/bloc/manage_game_form/manage_game_form.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/components/buttons/gradient_btn.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/router/router.gr.dart';

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
            body: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(game.teamOne.name, style: teamNameStyle),
                      Text(
                        'vs',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.1,
                          fontFamily: 'CircularStd',
                        ),
                      ),
                      Text(game.teamTwo.name, style: teamNameStyle),
                    ],
                  ),
                ),
                _ManageGameForm(formBloc: formBloc),
              ],
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
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50),
            ),
          ),
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
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                children: <Widget>[
                  BlocBuilder<InputFieldBloc<int>, InputFieldBlocState<int>>(
                    bloc: oneField,
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              oneField.updateValue(state.value - 1);
                            },
                          ),
                          Text(state.value.toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              oneField.updateValue(state.value + 1);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  BlocBuilder<InputFieldBloc<int>, InputFieldBlocState<int>>(
                    bloc: twoField,
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              twoField.updateValue(state.value - 1);
                            },
                          ),
                          Text(state.value.toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              twoField.updateValue(state.value + 1);
                            },
                          ),
                        ],
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
                    height: MediaQuery.of(context).size.height * 0.08,
                    text: 'Submit',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
