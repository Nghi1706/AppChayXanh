part of 'material_bloc.dart';

class MaterialsState {}

class MaterialInitial extends MaterialsState {}

class MaterialScreen extends MaterialsState {
  final bool isMaterialAll;
  final bool isMaterialRestaurant;
  dynamic type;
  dynamic unit;
  MaterialScreen(
      {required this.isMaterialAll,
      required this.isMaterialRestaurant,
      this.type,
      this.unit});
}

class MaterialCreateState extends MaterialsState {
  final String message;
  MaterialCreateState({required this.message});
}
