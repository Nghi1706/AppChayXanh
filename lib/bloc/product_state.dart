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

class ProductFetchState extends ProductState {
  final List product;
  final List material;
  ProductFetchState({required this.product, required this.material});
}

class ProductFetchMaterialState extends ProductState {
  final data;
  ProductFetchMaterialState({required this.data});
}

class ProductIsUpdating extends ProductState {}

class ProductUpdated extends ProductState {}

class ProductUpdateFail extends ProductState {}

class ProductIsCreating extends ProductState {}

class ProductCreated extends ProductState {}

class ProductCreateFail extends ProductState {}

class ProductIsDeleting extends ProductState {}

class ProductDeleted extends ProductState {}

class ProductDeleteFail extends ProductState {}
