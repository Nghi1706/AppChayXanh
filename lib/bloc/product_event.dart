part of 'product_bloc.dart';

class ProductEvent {}

class ProductCheck extends ProductEvent {
  final int role;
  ProductCheck({required this.role});
}

class ProductAdd extends ProductEvent {
  final params;
  ProductAdd({required this.params});
}
