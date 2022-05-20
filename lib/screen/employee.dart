import 'dart:developer';

import 'package:chayxanhapp/bloc/employee_bloc.dart';
import 'package:chayxanhapp/screen/employee_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeCED extends StatefulWidget {
  final int role;
  const EmployeeCED({Key? key, required this.role}) : super(key: key);

  @override
  _EmployeeCEDState createState() => _EmployeeCEDState();
}

class _EmployeeCEDState extends State<EmployeeCED> {
  EmployeeBloc employeeBloc = EmployeeBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    employeeBloc = BlocProvider.of(context);
    employeeBloc.add(FetchEmployee());
  }

  @override
  Widget build(BuildContext context) {
    role(int number) {
      if (number == 0) {
        return "nhân viên";
      } else if (number == 1) {
        return "quản lí";
      }
    }

    List data = [];
    String name = '';
    String phone = '';
    String role_user = '';
    var data_role = [
      {"role": "0", "name": "employee"},
      {"role": "1", "name": "manager"},
    ];
    String statusCreateEmployee;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  log("ok");
                  employeeBloc.add(FetchEmployee());
                });
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
                child: BlocBuilder<EmployeeBloc, EmployeeState>(
                    bloc: employeeBloc,
                    builder: (context, state) {
                      if (state is DataEmployeeFetch) {
                        data = state.data;
                      }
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Card(
                                child: ListTile(
                                  title: Text(data[index]['name']),
                                  subtitle:
                                      Text(data[index]['phone'].toString()),
                                  trailing: Text(
                                      role(data[index]['role']).toString()),
                                ),
                              ),
                              onTap: () {
                                log(data[index].toString());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        BlocProvider(
                                            create: (context) => EmployeeBloc(),
                                            child: EmployeeEdit(
                                              data: data[index],
                                            )),
                                  ),
                                );
                              },
                            );
                          });
                    })),
            Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                      flex: 3,
                    ),
                    InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          margin: const EdgeInsets.only(right: 10),
                          child: const Text(
                            "New Employee",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          statusCreateEmployee = 'Create Employee';
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BlocBuilder<EmployeeBloc, EmployeeState>(
                                  bloc: employeeBloc,
                                  builder: (context, state) {
                                    if (state is EmployeeCreateRes) {
                                      statusCreateEmployee = state.message;
                                    }
                                    return AlertDialog(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      title: Text(statusCreateEmployee),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            TextField(
                                              decoration: const InputDecoration(
                                                  labelStyle: TextStyle(
                                                      color: Colors.green),
                                                  border: OutlineInputBorder(),
                                                  label: Text("Name")),
                                              onChanged: (value) => {
                                                name = value,
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextField(
                                              decoration: const InputDecoration(
                                                  labelStyle: TextStyle(
                                                      color: Colors.green),
                                                  border: OutlineInputBorder(),
                                                  label: Text("Phone")),
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              onChanged: (value) => {
                                                phone = value,
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            widget.role == 2
                                                ? const Text("Role")
                                                : const Text(''),
                                            widget.role == 2
                                                ? DropdownButtonFormField(
                                                    items: data_role
                                                        .map((roleData) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: roleData['role'],
                                                        child: Text(
                                                          roleData['name']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      role_user =
                                                          value.toString();
                                                    },
                                                  )
                                                : const Text(""),
                                          ],
                                        ),
                                      ),
                                      actionsOverflowButtonSpacing: 20,
                                      actions: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)))),
                                          ),
                                          child: const Text("Create"),
                                          onPressed: () {
                                            var params = {
                                              "phone": phone,
                                              "name": name,
                                              "role": widget.role != 2
                                                  ? "0"
                                                  : role_user
                                            };
                                            employeeBloc.add(
                                                EmployeeCreate(params: params));
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                          );
                        }),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
