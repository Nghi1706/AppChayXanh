part of 'login_bloc.dart';

class LoginState {}

class LoginInitial extends LoginState {}

class LoginStatus extends LoginState {
  bool status;
  String message;
  dynamic data;
  LoginStatus({required this.status, required this.message, this.data});
}

class Logging extends LoginState {}

class LogFail extends LoginState {}

class LogSuccess extends LoginState {}

class PleaseAddUNorPASS extends LoginState {}
