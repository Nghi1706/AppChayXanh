import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chayxanhapp/api/api.dart';
import 'package:chayxanhapp/api/callAPI.dart';
import 'package:chayxanhapp/const/data.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeInitial()) {
    on<EmployeeEvent>((event, emit) async {
      if (event is FetchEmployee) {
        final prefs = await SharedPreferences.getInstance();
        String restaurantID = prefs.getString(idRestaurant).toString();
        var listUser = await CallAPI().Get(getUsers, {"id": restaurantID});
        if (listUser != '') {
          listUser = json.decode(listUser);
          emit(DataEmployeeFetch(data: listUser));
        }
      }
      if (event is EmployeeHostMenu) {
        try {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(idRestaurant, event.restaurantID);
          emit(MenuEmployeeHostScreen(status: true));
        } catch (error) {
          emit(MenuEmployeeHostScreen(status: false));
        }
      }
      if (event is EmployeeCreate) {
        emit(EmployeeCreateRes(message: "Creating !"));

        final prefs = await SharedPreferences.getInstance();
        String restaurantID = prefs.getString(idRestaurant).toString();
        event.params['id_restaurant'] = restaurantID;
        var employee = await CallAPI().Post(createUser, event.params);
        if (employee != '') {
          emit(EmployeeCreateRes(message: "Created !"));
        } else {
          emit(EmployeeCreateRes(message: "Create Fail !"));
        }
      }
      if (event is EmployeeDelete) {
        emit(EmployeeRunning());
        var del = await CallAPI().Delete(deleteUser, event.params);
        if (del != '') {
          emit(EmployeeRunSuccess());
        } else {
          emit(EmployeeRunFail());
        }
      }
      if (event is EmployeeEditPass) {
        emit(EmployeeRunning());
        var del = await CallAPI().Put(updateUser, event.params);
        if (del != '') {
          emit(EmployeeRunSuccess());
        } else {
          emit(EmployeeRunFail());
        }
      }
    });
  }
}
