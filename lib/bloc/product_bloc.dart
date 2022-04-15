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
            log(role.toString());
            break;
          case 2:
            log(role.toString());
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
    });
  }
}
