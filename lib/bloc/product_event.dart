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

class ProductDelete extends ProductEvent {
  final params;
  ProductDelete({required this.params});
}

class ProductUpdate extends ProductEvent {
  final params;
  ProductUpdate({required this.params});
}

class ProductFetch extends ProductEvent {}

class ProductFetchMaterial extends ProductEvent {
  final String idProduct;
  ProductFetchMaterial({required this.idProduct});
}
