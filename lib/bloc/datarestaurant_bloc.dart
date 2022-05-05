import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chayxanhapp/api/api.dart';
import 'package:chayxanhapp/api/callAPI.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const/data.dart';

part 'datarestaurant_event.dart';
part 'datarestaurant_state.dart';

class DatarestaurantBloc
    extends Bloc<DatarestaurantEvent, DatarestaurantState> {
  DatarestaurantBloc() : super(DatarestaurantInitial()) {
    dynamic products;
    bool canCook = true;
    String restaurantID = '';
    bool success = true;
    on<DatarestaurantEvent>((event, emit) async {
      if (event is DataCheck) {
        final prefs = await SharedPreferences.getInstance();
        restaurantID = prefs.getString(idRestaurant).toString();

        // get all product
        products = await CallAPI()
            .Get(getProductsRestaurant, {"Restaurants": restaurantID});
        log(products);
        products = json.decode(products);
        emit(DataRes(data: products));
      }
      if (event is DataCheckValue) {
        final prefs = await SharedPreferences.getInstance();
        restaurantID = prefs.getString(idRestaurant).toString();
        var productMaterial = await CallAPI()
            .Get(getProductsMaterials, {"Products": event.productId});
        productMaterial = json.decode(productMaterial);
        for (var i = 0; i < productMaterial.length; i++) {
          var material = await CallAPI().Get(getMaterialRestaurant, {
            "Materials": productMaterial[i]['Materials']['_id'],
            "Restaurants": restaurantID
          });
          material = json.decode(material);
          productMaterial[i]['Materials']['valueRes'] =
              material[0]['available_new'];
          productMaterial[i]['Materials']['total'] =
              productMaterial[i]['value'] * event.value;
          material[0]['available_new'];
          if (productMaterial[i]['Materials']['valueRes'] <
              productMaterial[i]['Materials']['total']) {
            canCook = false;
          }
        }
        emit(DataResValue(
            data: productMaterial, canCook: canCook, number: event.value));
      }
      if (event is DataUpdateValue) {
        final prefs = await SharedPreferences.getInstance();
        restaurantID = prefs.getString(idRestaurant).toString();
        var mR = await CallAPI()
            .Get(getMaterialsRestaurant, {'Restaurants': restaurantID});
        if (mR != '') {
          log(mR.toString());
          log(event.data.toString());
          mR = json.decode(mR);
          for (var i = 0; i < event.data.length; i++) {
            String id = '';
            for (var k = 0; k < mR.length; k++) {
              if (mR[k]['Materials']['_id'] ==
                  event.data[i]['Materials']['_id']) {
                id = mR[k]['_id'];
                break;
              }
            }
            var paramsUpdate = {
              "id": id,
              "available_old":
                  event.data[i]['Materials']['valueRes'].toString(),
              "available_new": (event.data[i]['Materials']['valueRes'] -
                      event.data[i]['Materials']['total'])
                  .toString()
            };
            var resUpdate =
                await CallAPI().Put(updateMaterialsRestaurant, paramsUpdate);
            log(resUpdate);
            if (resUpdate == '') {
              success = false;
            }
          }
        }
        if (success) {
          emit(DataUpdated());
        } else {
          emit(DataUpdateFail());
        }
      }
    });
  }
}
