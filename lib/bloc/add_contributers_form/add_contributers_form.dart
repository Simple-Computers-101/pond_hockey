import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pond_hockey/enums/access_levels.dart';

class AddContributersFormBloc extends FormBloc<String, String> {
  AddContributersFormBloc() {
    addFieldBloc(
      fieldBloc: FieldBlocList(
        name: 'contributers',
        fieldBlocs: [],
      ),
    );
    addFieldBloc(
      fieldBloc: SelectFieldBloc<Map<String, dynamic>>(
        name: 'access',
        items: [
          {'name': 'Editor', 'value': AccessLevels.editor},
          {'name': 'Scorer', 'value': AccessLevels.scorer},
        ],
        validators: [FieldBlocValidators.requiredSelectFieldBloc]
      ),
    );
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // TODO: implement onSubmitting
    throw UnimplementedError();
  }
}
