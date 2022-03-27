import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final icon;
  final String text;
  const ButtonCustom({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Card(
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 2,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                height: 55,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 119, 212, 122),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //         <--- border radius here
                      ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              )),
              Expanded(
                  flex: 3,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ))),
            ],
          )),
    );
  }
}
