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
    dynamic material_restaurant;
    dynamic material_productAll;
    List groupProductMaterials = [];
    dynamic products;
    List data_material = [];
    dynamic restaurant;
    String restaurantID = '';
    on<DatarestaurantEvent>((event, emit) async {
      if (event is DataCheck) {
        final prefs = await SharedPreferences.getInstance();
        restaurantID = prefs.getString(idRestaurant).toString();
        // get data material
        material_restaurant = await CallAPI()
            .Get(getMaterialsRestaurant, {"Restaurants": restaurantID});
        material_restaurant = json.decode(material_restaurant);
        for (var i = 0; i < material_restaurant.length; i++) {
          data_material.add({
            "_id": material_restaurant[i]['_id'],
            "MaterialID": material_restaurant[i]['Materials']['_id'],
            "unit": material_restaurant[i]['Materials']['unit'],
            "value": material_restaurant[i]['available_new']
          });
        }
        // get all product
        products = await CallAPI().Get(getProducts, "");
        products = json.decode(products);
        // get all material in product
        material_productAll = await CallAPI().Get(fetchProductMaterials, "");
        material_productAll = json.decode(material_productAll);
        // get information product
        for (var i = 0; i < products.length; i++) {
          dynamic productMaterial;
          List data = [];
          productMaterial = await CallAPI()
              .Get(getProductsMaterials, {"Products": products[i]['_id']});
          productMaterial = json.decode(productMaterial);
          for (var k = 0; k < productMaterial.length; k++) {
            int count = 0;
            // dynamic material_product;
            double value_material_restaurant = 0.0;
            double value_materialProduct = 0.0;
            double total_value_material = 0.0;
            for (var c = 0; c < data_material.length; c++) {
              if (productMaterial[k]['Materials']['_id'] ==
                  data_material[c]['MaterialID']) {
                value_material_restaurant = data_material[c]['value'] / 1.0;
              }
            }
            for (var d = 0; d < material_productAll.length; d++) {
              if (productMaterial[k]['Materials']['_id'] ==
                  material_productAll[d]['Materials']["_id"]) {
                total_value_material += material_productAll[d]['value'] / 1.0;
                count++;
              }
            }
            value_materialProduct = productMaterial[k]['value'] / 1.0;
            data.add(
                (value_material_restaurant / (total_value_material / count)) /
                    count);
          }
          var smallestData = data[0];

          for (var z = 0; z < data.length; z++) {
            // Checking for smallest value in the list
            if (data[z] < smallestData) {
              smallestData = data[z];
            }
          }
          //  add data to products[i]
          products[i]['available'] = smallestData;
        }
        emit(DataRes(data: products));
      }
    });
  }
}
