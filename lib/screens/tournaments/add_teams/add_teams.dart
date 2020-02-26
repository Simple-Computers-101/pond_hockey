import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pond_hockey/bloc/add_teams_form/add_teams_form.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/models/tournament.dart';

class AddTeamsScreen extends StatelessWidget {
  const AddTeamsScreen({@required this.tournament});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddTeamsFormBloc>(
      create: (_) => AddTeamsFormBloc(tournament: tournament),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Add Teams',
              transparentBackground: true,
            ),
            extendBodyBehindAppBar: true,
            body: OrientationBuilder(builder: (context, orientation) {
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
                    child: _AddTeamsForm(orientation: orientation),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _AddTeamsForm extends StatelessWidget {
  const _AddTeamsForm({
    Key key,
    this.orientation,
  }) : super(key: key);

  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    final formBloc = context.bloc<AddTeamsFormBloc>();
    return SizedBox(
      width: orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width * 0.75
          : null,
      height: orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.8
          : null,
      child: FormBlocListener<AddTeamsFormBloc, String, String>(
        onSuccess: (_, __) {},
        onSubmitting: (_, __) => Center(
          child: CircularProgressIndicator(),
        ),
        child: BlocBuilder<AddTeamsFormBloc, FormBlocState>(
          builder: (context, state) {
            final fields = state.fieldBlocFromPath('teams').asFieldBlocList;
            return ListView.builder(
              itemCount: fields.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, indx) {
                final field = fields[indx];
                return TeamField(
                  index: indx,
                  fieldBloc: field,
                  formBloc: formBloc,
                );
              },
            );
          },
        ),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFieldBlocBuilder(
              textFieldBloc: fieldBloc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle),
            onPressed: () => formBloc.removeTeamField(index),
          ),
        ],
      ),
    );
  }
}
