import 'dart:developer';

import 'package:chayxanhapp/bloc/employee_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeEdit extends StatefulWidget {
  final data;
  const EmployeeEdit({Key? key, required this.data}) : super(key: key);

  @override
  _EmployeeEditState createState() => _EmployeeEditState();
}

class _EmployeeEditState extends State<EmployeeEdit> {
  EmployeeBloc employeeBloc = EmployeeBloc();
  @override
  void initState() {
    super.initState();
    employeeBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    String newPassWord = '';
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee edit"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Phone :",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(widget.data['phone'].toString(),
                style: TextStyle(fontSize: 15)),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Name :",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(widget.data['name'], style: TextStyle(fontSize: 15)),
            const SizedBox(
              height: 10,
            ),
            Text('Change password :', style: TextStyle(fontSize: 20)),
            const SizedBox(
              height: 5,
            ),
            TextField(
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => {
                newPassWord = value,
              },
            ),
            const SizedBox(
              height: 10,
            ),
            BlocListener<EmployeeBloc, EmployeeState>(
              listener: (context, state) {
                if (state is EmployeeEditPass || state is EmployeeDelete) {
                  showLoaderDialog(context, "Running ...");
                }
                if (state is EmployeeRunSuccess) {
                  showDialogResult(context, "Success !");
                }
                if (state is EmployeeRunFail) {
                  showDialogResult(context, "Fail !");
                }
              },
              child: Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                    child: const Text("Delete"),
                    onPressed: () {
                      var params = {
                        "id": widget.data['_id'],
                      };
                      employeeBloc.add(EmployeeDelete(params: params));
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                    child: const Text("Change Password"),
                    onPressed: () {
                      var params = {
                        "_id": widget.data['_id'],
                        "password": newPassWord
                      };
                      employeeBloc.add(EmployeeEditPass(params: params));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context, String data) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7), child: Text(data)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDialogResult(BuildContext context, String data) {
    AlertDialog alert = AlertDialog(
      content: Text(data),
      actions: [
        OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("ok"))
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
