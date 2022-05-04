part of 'menu_bloc.dart';

class MenuEvent {}

class MenuOnScreen extends MenuEvent {}

class MenuMaterialHost extends MenuEvent {
  final String RestaurantID;
  MenuMaterialHost({required this.RestaurantID});
}
