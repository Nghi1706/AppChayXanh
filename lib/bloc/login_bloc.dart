import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:chayxanhapp/api/api.dart';
import 'package:chayxanhapp/api/callAPI.dart';
import 'package:chayxanhapp/const/data.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  bool status = false;
  String message = '';
  dynamic data;
  late String id_restaurant;
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      //call API
      if (event.phoneNumber.length == 0 || event.passWord.length == 0) {
        status = false;
        message = "Vui lòng điền đủ thông tin";
      } else {
        message = 'Đang kiểm tra đăng nhập !';
        emit(LoginStatus(status: status, message: message));
        var params = {
          "phoneNumber": event.phoneNumber,
          "password": event.passWord
        };
        var res = await CallAPI().Post(login, params);
        if (res != '') {
          var loginInfo = jsonDecode(res);
          if (loginInfo['loginStatus']) {
            status = loginInfo['loginStatus'];
            data = loginInfo;
            final prefs = await SharedPreferences.getInstance();
            if (data['id_restaurant'] is Null) {
              id_restaurant = "01";
            } else {
              id_restaurant = data['id_restaurant'];
            }
            await prefs.setString(idRestaurant, id_restaurant);
            await prefs.setString(idUser, data['id_user']);
            await prefs.setString(nameUser, data['name']);
            await prefs.setString(role, data['role'].toString());
            message = "Đăng nhập thành công";
          } else {
            status = false;
            message = "Đăng nhập thất bại";
          }
        } else {
          status = false;
          message = "Đăng nhập thất bại";
        }
      }
      emit(LoginStatus(status: status, message: message));
    });
  }
}
