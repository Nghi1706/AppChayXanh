part of 'menu_bloc.dart';

class MenuState {}

class MenuInitial extends MenuState {}

class MenuScreen extends MenuState {
  final String restaurantName;
  final String restaurantAddress;
  final String userName;
  final String role;
  final List listRestaurant;
  MenuScreen(
      {required this.restaurantName,
      required this.restaurantAddress,
      required this.userName,
      required this.role,
      required this.listRestaurant});
}

class MenuMaterialHostScreen extends MenuState {
  final bool status;
  MenuMaterialHostScreen({required this.status});
}
