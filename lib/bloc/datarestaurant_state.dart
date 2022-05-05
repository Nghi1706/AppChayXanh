part of 'datarestaurant_bloc.dart';

class DatarestaurantState {}

class DatarestaurantInitial extends DatarestaurantState {}

class DataRes extends DatarestaurantState {
  final data;
  DataRes({required this.data});
}

class DataResValue extends DatarestaurantState {
  final bool canCook;
  final data;
  final double number;
  DataResValue(
      {required this.data, required this.canCook, required this.number});
}

class DataUpdating extends DatarestaurantState {
  DataUpdating();
}

class DataUpdated extends DatarestaurantState {
  DataUpdated();
}

class DataUpdateFail extends DatarestaurantState {
  DataUpdateFail();
}
