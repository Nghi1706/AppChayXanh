import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chayxanhapp/api/api.dart';
import 'package:chayxanhapp/api/callAPI.dart';
import 'package:meta/meta.dart';

part 'material_event.dart';
part 'material_state.dart';

class MaterialBloc extends Bloc<MaterialEvent, MaterialsState> {
  dynamic type = [];
  dynamic unit = [];
  MaterialBloc() : super(MaterialInitial()) {
    on<MaterialEvent>((event, emit) async {
      if (event is MaterialCheckEvent) {
        if (event.isMaterialAll) {
          type = await CallAPI().Get(getTypeMaterial, '');
          type = jsonDecode(type);
          unit = await CallAPI().Get(units, '');
          unit = jsonDecode(unit);
        }
        emit(MaterialScreen(
            isMaterialAll: event.isMaterialAll,
            isMaterialRestaurant: event.isMaterialRestaurant,
            type: type,
            unit: unit));
      }
    });
  }
}
