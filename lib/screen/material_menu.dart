import 'package:chayxanhapp/screen/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/material_bloc.dart';
import '../widget/button_manager.dart';

class MaterialMenu extends StatelessWidget {
  const MaterialMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Material",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => BlocProvider(
                        create: (context) => MaterialBloc(),
                        child: const MaterialCED(
                          isMaterialAll: true,
                          isMaterialRestaurant: false,
                        ),
                      ),
                    ));
              },
              child: const ButtonCustom(
                icon: Icons.other_houses_outlined,
                text: "Quản lý nguyên liệu chung",
              )),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => BlocProvider(
                        create: (context) => MaterialBloc(),
                        child: const MaterialCED(
                          isMaterialAll: false,
                          isMaterialRestaurant: true,
                        ),
                      ),
                    ));
              },
              child: const ButtonCustom(
                icon: Icons.other_houses,
                text: "Nguyên liệu nhà hàng",
              )),
        ],
      ),
    );
  }
}
