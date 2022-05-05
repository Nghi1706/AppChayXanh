part of 'datarestaurant_bloc.dart';

class DatarestaurantEvent {}

class DataCheck extends DatarestaurantEvent {}

class DataCheckValue extends DatarestaurantEvent {
  final String productId;
  final double value;
  DataCheckValue({required this.productId, required this.value});
}

class DataUpdateValue extends DatarestaurantEvent {
  final List data;
  DataUpdateValue({required this.data});
}
