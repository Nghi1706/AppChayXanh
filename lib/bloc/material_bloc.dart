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
        emit(MaterialLoading());
        final prefs = await SharedPreferences.getInstance();
        String roleSaved = prefs.getString(role).toString();
        int role_use = int.parse(roleSaved);
        if (event.isMaterialAll) {
          type = await CallAPI().Get(getTypeMaterial, '');
          type = jsonDecode(type);
          unit = await CallAPI().Get(units, '');
          unit = jsonDecode(unit);
          material = await CallAPI().Get(getMaterials, '');
          material = jsonDecode(material);
          emit(AllMaterialScreen(
              isMaterialAll: event.isMaterialAll,
              isMaterialRestaurant: event.isMaterialRestaurant,
              type: type,
              unit: unit,
              material: material));
        } else if (event.isMaterialRestaurant) {
          type = await CallAPI().Get(getTypeMaterial, '');
          type = jsonDecode(type);
          unit = await CallAPI().Get(units, '');
          unit = jsonDecode(unit);
          final prefs = await SharedPreferences.getInstance();
          String restaurantID = prefs.getString(idRestaurant).toString();
          var paramsMaterials = {"Restaurants": restaurantID};
          material =
              await CallAPI().Get(getMaterialsRestaurant, paramsMaterials);
          material = jsonDecode(material);
          emit(RestaurantMaterialScreen(
              type: type, unit: unit, material: material, role: role_use));
        }
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
        var paramsAdd = {
          "Materials": event.materialId,
          "Restaurants": restaurantID
        };
        var resADD = await CallAPI().Post(createMaterialsRestaurant, paramsAdd);
        if (resADD != '') {
          resADD = json.decode(resADD);
          emit(MaterialAddToRestaurantState(message: "Added !"));
        } else {
          emit(MaterialAddToRestaurantState(message: "Add fail !"));
        }
      }
      if (event is RestaurantMaterialUpdate) {
        emit(RestaurantMaterialUpdateToRestaurantState(message: "Updating !"));
        var paramsUpdate = {
          "id": event.restaurantMaterialId,
          "available_old": event.restaurantMaterialOldAvailable.toString(),
          "available_new": event.restaurantMaterialNewAvailable.toString()
        };
        var resUpdate =
            await CallAPI().Put(updateMaterialsRestaurant, paramsUpdate);
        if (resUpdate != '') {
          resUpdate = json.decode(resUpdate);
          emit(RestaurantMaterialUpdateToRestaurantState(message: "Updated !"));
        } else {
          emit(RestaurantMaterialUpdateToRestaurantState(
              message: "Update fail !"));
        }
      }
      if (event is RestaurantMaterialDelete) {
        log(event.materialId);
        emit(RestaurantMaterialDeleteState(message: "Deleting !"));
        var paramsDelete = {"id": event.materialId};
        var resDelete =
            await CallAPI().Delete(deleteMaterialsRestaurant, paramsDelete);
        if (resDelete != '') {
          resDelete = json.decode(resDelete);
          emit(RestaurantMaterialDeleteState(message: "Deleted !"));
        } else {
          emit(RestaurantMaterialDeleteState(message: "Delete fail !"));
        }
      }
      if (event is FetchRestaurant) {
        emit(Fetching());
        log(event.materialId);
        var listRestaurant = await CallAPI().Get(
            getMaterialRestaurantByMaterialId, {"Materials": event.materialId});
        log(listRestaurant.toString());
        listRestaurant = json.decode(listRestaurant);
        emit(ListData(data: listRestaurant));
      }
      if (event is RestaurantMaterialTransfer) {
        emit(Fetching());
        try {
          await CallAPI().Put(updateMaterialsRestaurant, event.dataOld);
          await CallAPI().Put(updateMaterialsRestaurant, event.dataNew);
          emit(Fetched());
        } catch (error) {
          emit(Fail());
        }
      }
    });
  }
}
