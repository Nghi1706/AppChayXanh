part of 'material_bloc.dart';

class MaterialEvent {}

class MaterialCheckEvent extends MaterialEvent {
  final bool isMaterialAll;
  final bool isMaterialRestaurant;
  MaterialCheckEvent(
      {required this.isMaterialAll, required this.isMaterialRestaurant});
}

class MaterialCreate extends MaterialEvent {
  final String materialName;
  final String materialType;
  final String materialUnit;
  MaterialCreate(
      {required this.materialName,
      required this.materialType,
      required this.materialUnit});
}
