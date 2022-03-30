import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chayxanhapp/api/api.dart';
import 'package:chayxanhapp/api/callAPI.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const/data.dart';

part 'material_event.dart';
part 'material_state.dart';

class MaterialBloc extends Bloc<MaterialEvent, MaterialsState> {
  dynamic type = [];
  dynamic unit = [];
  dynamic material = [];
  MaterialBloc() : super(MaterialInitial()) {
    on<MaterialEvent>((event, emit) async {
      if (event is MaterialCheckEvent) {
        if (event.isMaterialAll) {
          type = await CallAPI().Get(getTypeMaterial, '');
          type = jsonDecode(type);
          unit = await CallAPI().Get(units, '');
          unit = jsonDecode(unit);
          material = await CallAPI().Get(getMaterials, '');
          material = jsonDecode(material);
        }
        emit(MaterialScreen(
            isMaterialAll: event.isMaterialAll,
            isMaterialRestaurant: event.isMaterialRestaurant,
            type: type,
            unit: unit,
            material: material));
      }
      if (event is MaterialCreate) {
        emit(MaterialCreateState(message: 'is creating ....'));
        var params = {
          "name": event.materialName,
          "type": event.materialType,
          "unit": event.materialUnit
        };
        var res = await CallAPI().Post(createMaterial, params);
        if (res != '') {
          res = json.decode(res);
          emit(MaterialCreateState(message: 'Created'));
        } else {
          emit(MaterialCreateState(message: 'Create fail'));
        }
      }
      if (event is MaterialEdit) {
        emit(MaterialEditState(message: "Editing !"));
        var paramsEdit = {
          "id": event.materialId,
          "name": event.materialName,
          "type": event.materialType,
          "unit": event.materialUnit
        };
        var resEdit = await CallAPI().Put(updateMaterial, paramsEdit);
        if (resEdit != '') {
          resEdit = json.decode(resEdit);
          emit(MaterialEditState(message: 'Edited'));
        } else {
          emit(MaterialEditState(message: 'Edit fail'));
        }
      }
      if (event is MaterialDelete) {
        emit(MaterialDeleteState(message: "Deleting !"));
        var paramsDelete = {"id": event.materialId};
        var resEdit = await CallAPI().Delete(deleteMaterial, paramsDelete);
        if (resEdit != '') {
          resEdit = json.decode(resEdit);
          emit(MaterialDeleteState(message: 'Deleted'));
        } else {
          emit(MaterialDeleteState(message: 'Delete fail'));
        }
      }
      if (event is MaterialAdd) {
        emit(MaterialAddToRestaurantState(message: "Adding !"));
        final prefs = await SharedPreferences.getInstance();
        String restaurantID = prefs.getString(idRestaurant).toString();
        log(restaurantID);
        log(event.materialId);
        // var paramsAdd = {"id": event.materialId};
      }
    });
  }
}
