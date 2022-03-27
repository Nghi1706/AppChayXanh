import 'package:chayxanhapp/bloc/menu_bloc.dart';
import 'package:chayxanhapp/screen/login.dart';
import 'package:chayxanhapp/widget/menuEmployee.dart';
import 'package:chayxanhapp/widget/menuHost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';
import '../widget/menuManager.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  MenuBloc menuBloc = MenuBloc();
  @override
  void initState() {
    super.initState();
    menuBloc = BlocProvider.of(context);
    menuBloc.add(MenuOnScreen());
  }

  @override
  Widget build(BuildContext context) {
    String restaurantName;
    String restaurantAddress;
    String restaurantActor;
    String role = '-1';
    Widget widget = Scaffold();
    return BlocBuilder<MenuBloc, MenuState>(
        bloc: menuBloc,
        builder: (context, state) {
          if (state is MenuScreen) {
            restaurantName = state.restaurantName;
            restaurantActor = state.userName;
            restaurantAddress = state.restaurantAddress;
            role = state.role;
            switch (role) {
              case '0':
                widget = MenuEmployee(
                    restaurantAddress: restaurantAddress,
                    restaurantUser: restaurantActor,
                    restaurantName: restaurantName);
                break;
              case '1':
                widget = MenuManager(
                  restaurantAddress: restaurantAddress,
                  restaurantUser: restaurantActor,
                  restaurantName: restaurantName,
                );
                break;
              case '2':
                widget = MenuHost(
                    restaurantAddress: restaurantAddress,
                    restaurantUser: restaurantActor,
                    restaurantName: restaurantName);
                break;
              default:
                widget = Scaffold(
                    appBar: AppBar(
                      title: Center(
                        child: Text(restaurantName),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () => {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          BlocProvider(
                                        create: (context) => LoginBloc(),
                                        child: const LoginScreen(),
                                      ),
                                    ),
                                  )
                                },
                            icon: Icon(Icons.logout))
                      ],
                    ),
                    body: Container(
                      child: Text("something when wrong !"),
                    ));
            }
          }
          return widget;
        });
  }
}
