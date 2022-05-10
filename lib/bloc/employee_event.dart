part of 'employee_bloc.dart';

class EmployeeEvent {}

class FetchEmployee extends EmployeeEvent {}

class EmployeeHostMenu extends EmployeeEvent {
  final String restaurantID;
  EmployeeHostMenu({required this.restaurantID});
}

class EmployeeCreate extends EmployeeEvent {
  final params;
  EmployeeCreate({required this.params});
}

class EmployeeEditPass extends EmployeeEvent {
  final params;
  EmployeeEditPass({required this.params});
}

class EmployeeDelete extends EmployeeEvent {
  final params;
  EmployeeDelete({required this.params});
}
