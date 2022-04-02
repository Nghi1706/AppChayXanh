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

class MaterialEdit extends MaterialEvent {
  final String materialId;
  final String materialName;
  final String materialType;
  final String materialUnit;
  MaterialEdit(
      {required this.materialId,
      required this.materialName,
      required this.materialType,
      required this.materialUnit});
}

class MaterialDelete extends MaterialEvent {
  final String materialId;

  MaterialDelete({required this.materialId});
}

class MaterialAdd extends MaterialEvent {
  final String materialId;

  MaterialAdd({required this.materialId});
}

class RestaurantMaterialUpdate extends MaterialEvent {
  final String restaurantMaterialId;
  final double restaurantMaterialOldAvailable;
  final double restaurantMaterialNewAvailable;
  RestaurantMaterialUpdate(
      {required this.restaurantMaterialId,
      required this.restaurantMaterialOldAvailable,
      required this.restaurantMaterialNewAvailable});
}

class RestaurantMaterialDelete extends MaterialEvent {
  final String materialId;

  RestaurantMaterialDelete({required this.materialId});
}
