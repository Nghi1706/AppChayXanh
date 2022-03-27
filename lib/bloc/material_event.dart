part of 'material_bloc.dart';

class MaterialEvent {}

class MaterialCheckEvent extends MaterialEvent {
  final bool isMaterialAll;
  final bool isMaterialRestaurant;
  MaterialCheckEvent(
      {required this.isMaterialAll, required this.isMaterialRestaurant});
}
