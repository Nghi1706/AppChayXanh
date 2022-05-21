part of 'restaurant_bloc.dart';

class RestaurantEvent {}

class FetchRestaurant extends RestaurantEvent {}

class CreateRestaurant extends RestaurantEvent {
  final data;
  final String idManager;
  CreateRestaurant({required this.data, required this.idManager});
}
