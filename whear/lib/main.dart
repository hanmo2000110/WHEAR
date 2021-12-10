import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';
import 'package:whear/screens/home_page.dart';
import 'package:whear/screens/signin_page.dart';
import 'screens/add_page.dart';
import 'screens/notice_page.dart';
import 'screens/profile_page.dart';
import 'screens/search_page.dart';
import 'screens/navigation_page.dart';
import 'screens/detail_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  await Permission.camera.request();
  await Permission.microphone.request();
  runApp(const Whear());
}

class Whear extends StatelessWidget {
  const Whear({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // darkTheme: ThemeData.dark(),
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      initialBinding: Binding(),
      title: 'MoappFinal',
      initialRoute: '/',
      getPages: [
        GetPage(
            name: "/",
            middlewares: [AuthMiddleware()],
            page: () => NavigationPage(),
            transition: Transition.fadeIn),
        GetPage(
            name: "/home",
            page: () => HomePage(),
            transition: Transition.noTransition),
        GetPage(
            name: "/login",
            page: () => SignInPage(),
            transition: Transition.fade),
        GetPage(
            name: "/add",
            page: () => AddPage(),
            transition: Transition.noTransition),
        GetPage(
            name: "/notice",
            page: () => NoticePage(),
            transition: Transition.noTransition),
        GetPage(
            name: "/profile",
            page: () => ProfilePage(),
            transition: Transition.noTransition),
        GetPage(
            name: "/search",
            page: () => SearchPage(),
            transition: Transition.noTransition),
        GetPage(
          name: "/detail",
          page: () => DetailPage(),
          transition: Transition.noTransition,
        )
      ],
    );
  }
}
