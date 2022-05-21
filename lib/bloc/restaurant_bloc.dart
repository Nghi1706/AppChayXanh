import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chayxanhapp/api/api.dart';
import 'package:chayxanhapp/api/callAPI.dart';
import 'package:meta/meta.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc() : super(RestaurantInitial()) {
    on<RestaurantEvent>((event, emit) async {
      if (event is FetchRestaurant) {
        var data = await CallAPI().Get(getListRestaurant, "");
        data = json.decode(data);
        // var listManager = await CallAPI().Get(getManager, "");
        // listManager = json.decode(listManager);
        emit(DataRestaurant(data: data, listManager: []));
      }
      if (event is CreateRestaurant) {
        emit(RestaurantCreate(status: "Creating!"));
        var data = await CallAPI().Post(createRestaurant, event.data);
        if (data != '') {
          emit(RestaurantCreate(status: "Success!"));
        } else {
          emit(RestaurantCreate(status: "Fail !"));
        }
      }
    });
  }
}
