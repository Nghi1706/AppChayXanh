import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chayxanhapp/api/api.dart';
import 'package:chayxanhapp/api/callAPI.dart';
import 'package:chayxanhapp/bloc/material_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chayxanhapp/const/data.dart';
part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  String restaurantName = '';
  String restaurantAddress = '';
  MenuBloc() : super(MenuInitial()) {
    on<MenuEvent>((event, emit) async {
      if (event is MenuOnScreen) {
        final prefs = await SharedPreferences.getInstance();
        String userName = prefs.getString(nameUser).toString();
        String restaurantID = prefs.getString(idRestaurant).toString();
        String roleLoged = prefs.getString(role).toString();
        if (roleLoged == "2") {
          restaurantName = "Host is using this app";
          restaurantAddress = "";
        } else if (roleLoged == "1" || roleLoged == "0") {
          var params = {"id": restaurantID};
          var res = await CallAPI().Get(findRestaurant, params);
          var data = jsonDecode(res);
          restaurantName = data['name'];
          restaurantAddress = data['address'];
        } else {
          restaurantName = '';
          restaurantAddress = '';
        }
        emit(MenuScreen(
            restaurantName: restaurantName,
            restaurantAddress: restaurantAddress,
            userName: userName,
            role: roleLoged));
      }
    });
  }
}