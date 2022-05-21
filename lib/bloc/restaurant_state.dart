part of 'restaurant_bloc.dart';

class RestaurantState {}

class RestaurantInitial extends RestaurantState {}

class DataRestaurant extends RestaurantState {
  final data;
  final listManager;
  DataRestaurant({required this.data, required this.listManager});
}

class RestaurantCreate extends RestaurantState {
  String status;
  RestaurantCreate({required this.status});
}
