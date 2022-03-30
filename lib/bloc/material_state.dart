part of 'material_bloc.dart';

class MaterialsState {}

class MaterialInitial extends MaterialsState {}

class MaterialScreen extends MaterialsState {
  final bool isMaterialAll;
  final bool isMaterialRestaurant;
  List type;
  List unit;
  List material;
  MaterialScreen(
      {required this.isMaterialAll,
      required this.isMaterialRestaurant,
      required this.type,
      required this.unit,
      required this.material});
}

class MaterialCreateState extends MaterialsState {
  final String message;
  MaterialCreateState({required this.message});
}

class MaterialEditState extends MaterialsState {
  final String message;
  MaterialEditState({required this.message});
}

class MaterialDeleteState extends MaterialsState {
  final String message;
  MaterialDeleteState({required this.message});
}

class MaterialAddToRestaurantState extends MaterialsState {
  final String message;
  MaterialAddToRestaurantState({required this.message});
}
