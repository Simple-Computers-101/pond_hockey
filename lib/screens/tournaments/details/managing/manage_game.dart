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
                    children: <Widget>[
                      Text(game.teamOne.name),
                      Text('v.'),
                      Text(game.teamTwo.name),
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
      formBloc: formBloc,
      onLoading: (_, __) => Center(child: CircularProgressIndicator()),
      onSuccess: (_, __) => Router.navigator.pop(),
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50),
            ),
          ),
          child: BlocBuilder<ManageGameFormBloc, FormBlocState>(
            builder: (context, state) {
              final teamOneField = state
                  .fieldBlocFromPath('team-one_score')
                  .asInputFieldBloc<int>();
              final teamTwoField = state
                  .fieldBlocFromPath('team-two_score')
                  .asInputFieldBloc<int>();

              return ListView(
                children: <Widget>[
                  BlocBuilder<InputFieldBloc<int>, InputFieldBlocState>(
                    bloc: teamOneField,
                    builder: (context, state) {
                      var oneValue = teamOneField.value;

                      return Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              teamOneField.updateValue(oneValue--);
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              initialValue: oneValue.toString(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              teamOneField.updateValue(oneValue++);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  BlocBuilder<InputFieldBloc<int>, InputFieldBlocState<int>>(
                    bloc: teamTwoField,
                    builder: (context, state) {
                      var twoValue = teamTwoField.value;
                      return Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              teamTwoField.updateValue(twoValue--);
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              initialValue: twoValue.toString(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              teamTwoField.updateValue(twoValue++);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  GradientButton(
                    onTap: formBloc.submit,
                    colors: [
                      Color.fromRGBO(255, 65, 109, 1),
                      Color.fromRGBO(255, 75, 43, 1),
                    ],
                    height: MediaQuery.of(context).size.height * 0.1,
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
