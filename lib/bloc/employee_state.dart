part of 'employee_bloc.dart';

class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class DataEmployeeFetch extends EmployeeState {
  final List data;
  DataEmployeeFetch({required this.data});
}

class MenuEmployeeHostScreen extends EmployeeState {
  final bool status;
  MenuEmployeeHostScreen({required this.status});
}

class EmployeeCreateRes extends EmployeeState {
  final String message;
  EmployeeCreateRes({required this.message});
}

class EmployeeRunning extends EmployeeState {}

class EmployeeRunFail extends EmployeeState {}

class EmployeeRunSuccess extends EmployeeState {}
