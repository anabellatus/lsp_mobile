import 'package:agen_nusantara/configs/routes/page.dart';
import 'package:agen_nusantara/configs/routes/route.dart';
import 'package:agen_nusantara/shared/services/database_service.dart';
import 'package:agen_nusantara/shared/services/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService();

  final userSessionService = UserSessionService();
  await userSessionService.initialize();
  Get.put<UserSessionService>(userSessionService);

  String initialRoute = userSessionService.isLoggedIn
      ? Routes.home
      : Routes.login;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Agenda Nusantara',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: initialRoute,
      getPages: Pages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
