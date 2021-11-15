import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';
import 'package:whear/screens/home_page.dart';
import 'package:whear/screens/signin_page.dart';

void main() {
  runApp(const Whear());
}

class Whear extends StatelessWidget {
  const Whear({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialBinding: Binding(),
      title: 'MoappFinal',
      initialRoute: '/',
      getPages: [
        GetPage(
            name: "/",
            middlewares: [AuthMiddleware()],
            page: () => const HomePage(),
            transition: Transition.fadeIn),
        GetPage(
            name: "/login",
            page: () => SignInPage(),
            transition: Transition.fade),
      ],
    );
  }
}
