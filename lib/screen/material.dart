import 'dart:convert';
import 'dart:developer';

import 'package:chayxanhapp/api/callAPI.dart';
import 'package:chayxanhapp/widget/button_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api.dart';
import '../bloc/material_bloc.dart';

class MaterialCED extends StatefulWidget {
  final bool isMaterialAll;
  final bool isMaterialRestaurant;
  const MaterialCED(
      {Key? key,
      required this.isMaterialAll,
      required this.isMaterialRestaurant})
      : super(key: key);

  @override
  _MaterialCEDState createState() => _MaterialCEDState();
}

class _MaterialCEDState extends State<MaterialCED> {
  MaterialBloc materialBloc = MaterialBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    materialBloc = BlocProvider.of(context);
    materialBloc.add(MaterialCheckEvent(
      isMaterialAll: widget.isMaterialAll,
      isMaterialRestaurant: widget.isMaterialRestaurant,
    ));
  }

  @override
  Widget build(BuildContext context) {
    bool isMaterialAll = false;
    List type = [];
    List unit = [];
    String typeName = 'gia vị';
    String unitName = 'kg';
    String materialName = '';
    return BlocBuilder<MaterialBloc, MaterialsState>(
        bloc: materialBloc,
        builder: (context, state) {
          if (state is MaterialScreen) {
            isMaterialAll = state.isMaterialAll;
            type = state.type;
            unit = state.unit;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("Material"),
              centerTitle: true,
            ),
            body: isMaterialAll
                ? Container(
                    child: Column(children: [
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              "data",
                              style: TextStyle(fontSize: 50),
                            ),
                          ],
                        ),
                      )),
                      Container(
                          height: 50,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  margin: EdgeInsets.only(right: 20),
                                  child: Text(
                                    "New Material",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        title: Text("Create new material"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextField(
                                                decoration:
                                                    const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        label: Text(
                                                            "Material name")),
                                                onChanged: (value) => {
                                                  materialName = value,
                                                },
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Chọn loại nguyên liệu"),
                                              DropdownButtonFormField(
                                                items: type.map((items_type) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: items_type['type'],
                                                    child: Text(
                                                      items_type['type'],
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    typeName = value.toString();
                                                  });
                                                },
                                                value: typeName,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Chọn đơn vị tính"),
                                              DropdownButtonFormField(
                                                items: unit.map((unit) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: unit['unit'],
                                                    child: Text(
                                                      unit['unit'],
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    unitName = value.toString();
                                                  });
                                                },
                                                value: unitName,
                                              ),
                                            ],
                                          ),
                                        ),
                                        actionsOverflowButtonSpacing: 20,
                                        actions: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)))),
                                            ),
                                            child: Text("Create"),
                                            onPressed: () {
                                              log(materialName);
                                              log(typeName);
                                              log(unitName);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }),
                          )),
                    ]),
                  )
                : Container(
                    child: Text("CED Res material here !"),
                  ),
          );
        });
  }
}
