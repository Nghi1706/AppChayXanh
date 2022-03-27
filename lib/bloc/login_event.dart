part of 'login_bloc.dart';

class LoginEvent {
  final String phoneNumber;
  final String passWord;
  const LoginEvent({required this.phoneNumber, required this.passWord});
}
