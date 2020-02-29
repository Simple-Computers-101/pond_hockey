import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pond_hockey/bloc/add_teams_form/add_teams_form.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/router/router.gr.dart';

class AddTeamsScreen extends StatelessWidget {
  const AddTeamsScreen({@required this.tournament});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddTeamsFormBloc>(
      create: (_) => AddTeamsFormBloc(tournament: tournament),
      child: Builder(
        builder: (context) {
          final formBloc = context.bloc<AddTeamsFormBloc>();
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Add Teams',
              transparentBackground: true,
            ),
            extendBodyBehindAppBar: true,
            body: _AddTeamsForm(formBloc: formBloc),
          );
        },
      ),
    );
  }
}

class _AddTeamsForm extends StatelessWidget {
  const _AddTeamsForm({
    Key key,
    @required this.formBloc,
  }) : super(key: key);

  final AddTeamsFormBloc formBloc;

  @override
  Widget build(BuildContext context) {
    return FormBlocListener<AddTeamsFormBloc, String, String>(
      onSuccess: (_, __) {
        Router.navigator.pop();
      },
      onSubmitting: (_, __) => Center(
        child: CircularProgressIndicator(),
      ),
      child: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB993D6), Color(0xFF8CA6DB)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                primary: false,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: BlocBuilder<AddTeamsFormBloc, FormBlocState>(
                    builder: (context, state) {
                      print(state.fieldBlocs);
                      final fields =
                          state.fieldBlocFromPath('teams')?.asFieldBlocList;
                      if (fields != null && fields.isNotEmpty) {
                        return Column(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                itemCount: fields.length,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, indx) {
                                  final field = fields[indx];
                                  return TeamField(
                                    index: indx,
                                    fieldBloc: field,
                                    formBloc: formBloc,
                                  );
                                },
                              ),
                            ),
                            DropdownFieldBlocBuilder(
                              selectFieldBloc:
                                  state.fieldBlocFromPath('division'),
                              itemBuilder: (context, items) => items['name'],
                              showEmptyItem: false,
                              decoration: InputDecoration(
                                filled: true,
                                labelText: 'Division',
                                fillColor: Colors.white,
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              buttonMinWidth: 100,
                              children: <Widget>[
                                MaterialButton(
                                  color: Colors.white,
                                  onPressed: formBloc.addTeamField,
                                  child: Icon(Icons.add, size: 24),
                                  padding: const EdgeInsets.all(16),
                                  shape: CircleBorder(),
                                ),
                                MaterialButton(
                                  color: Colors.white,
                                  onPressed: formBloc.submit,
                                  child: Text('Submit'),
                                  padding: const EdgeInsets.all(16),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            Text(
                              'Click below to add a team field.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: MaterialButton(
                                  color: Colors.white,
                                  onPressed: formBloc.addTeamField,
                                  child: Icon(Icons.add, size: 24),
                                  padding: const EdgeInsets.all(16),
                                  shape: CircleBorder(),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TeamField extends StatelessWidget {
  const TeamField({
    Key key,
    this.index,
    this.fieldBloc,
    this.formBloc,
  }) : super(key: key);

  final int index;
  final TextFieldBloc fieldBloc;
  final AddTeamsFormBloc formBloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFieldBlocBuilder(
            textFieldBloc: fieldBloc,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white, 
              labelStyle: TextStyle(
                color: Colors.grey,
              ),
              focusedBorder: OutlineInputBorder(),
              labelText: 'Team name',
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.remove_circle),
          onPressed: () => formBloc.removeTeamField(index),
        ),
      ],
    );
  }
}
