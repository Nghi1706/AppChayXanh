part of 'product_bloc.dart';

class ProductState {}

class ProductInitial extends ProductState {}

class ProductListScreenEmployee extends ProductState {
  final List product;
  final List material;
  ProductListScreenEmployee({required this.product, required this.material});
}

class ProductCreate extends ProductState {
  final String status;
  ProductCreate({required this.status});
}

class ProductIsCreating extends ProductState {}

class ProductCreated extends ProductState {}

class ProductCreateFail extends ProductState {}
