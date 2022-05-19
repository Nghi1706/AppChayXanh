import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chayxanhapp/api/api.dart';
import 'package:chayxanhapp/api/callAPI.dart';
import 'package:chayxanhapp/const/data.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is ProductCheck) {
        switch (event.role) {
          case 0:
            var material = await CallAPI().Get(getMaterials, "");
            if (material != '') {
              material = json.decode(material);
              emit(ProductListScreenEmployee(product: [], material: material));
            }
            break;
          case 1:
            var material = await CallAPI().Get(getMaterials, "");
            if (material != '') {
              material = json.decode(material);
              emit(ProductListScreenEmployee(product: [], material: material));
            }
            break;
          case 2:
            var material = await CallAPI().Get(getMaterials, "");
            if (material != '') {
              material = json.decode(material);
              emit(ProductListScreenEmployee(product: [], material: material));
            }
            break;
          default:
            log("waiting !");
        }
      }
      if (event is ProductAdd) {
        emit(ProductIsCreating());
        log(event.params['product'].toString());
        log(event.params['materials'].toString());
        var res = await CallAPI().Post(createProduct, event.params['product']);
        if (res != '') {
          res = json.decode(res);
          log(res.toString());
          for (var i = 0; i < event.params['materials'].length; i++) {
            var params = {
              "Products": res["getProductNew"]["_id"],
              "Materials": event.params['materials'][i]["name"],
              "value": event.params['materials'][i]["value"].toString()
            };
            var resProduct =
                await CallAPI().Post(createProductsMaterials, params);
            if (resProduct != '') {
              resProduct = json.decode(resProduct);
              log(resProduct.toString());
            }
          }
          emit(ProductCreated());
        } else {
          emit(ProductCreateFail());
        }
      }
      if (event is ProductFetch) {
        var product = await CallAPI().Get(getProducts, "");
        product = json.decode(product);
        var material = await CallAPI().Get(getMaterials, "");
        material = json.decode(material);
        emit(ProductFetchState(product: product, material: material));
      }
      if (event is ProductFetchMaterial) {
        var params = {"Products": event.idProduct};
        var res = await CallAPI().Get(getProductsMaterials, params);
        res = json.decode(res);
        var material = [];
        var productMaterial = {
          "_id": res[0]['_id'],
        };
        var product = {
          "Products": res[0]["Products"]['_id'],
          "name": res[0]["Products"]['name'],
          "cost": res[0]["Products"]['cost'].toString(),
          "status": res[0]["Products"]['status'].toString(),
          "comment": res[0]["Products"]['comment'],
        };
        for (var i = 0; i < res.length; i++) {
          material.add({
            "Materials": res[i]['Materials']['_id'],
            "name": res[i]["Materials"]['name'],
            "unit": res[i]["Materials"]['unit'],
            "value": res[i]['value'].toString()
          });
        }
        var data = {
          "_id": res[0]['_id'],
          "Products": product,
          "Materials": material
        };
        emit(ProductFetchMaterialState(data: data));
      }
      if (event is ProductUpdate) {
        log(event.params.toString());
        emit(ProductIsUpdating());
        log("is updating!");
        var res = await CallAPI().Put(updateProduct, event.params);
        if (res != '') {
          emit(ProductUpdated());
        } else {
          emit(ProductUpdateFail());
        }
      }
      if (event is ProductDelete) {
        log(event.params.toString());
        emit(ProductIsDeleting());
        log("is deleting!");
        var res2 = await CallAPI().Delete(deleteProduct, event.params);
        var res3 =
            await CallAPI().Delete(deleteProductsRestaurant, event.params);
        if (res2 != '' && res3 != '') {
          emit(ProductDeleted());
          log("is deleted!");
        } else {
          emit(ProductDeleteFail());
          log("is delete fail!");
        }
      }
    });
  }
}
