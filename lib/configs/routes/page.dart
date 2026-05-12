import 'package:agen_nusantara/configs/routes/route.dart';
import 'package:agen_nusantara/features/add_important_task/bindings/add_important_task_binding.dart';
import 'package:agen_nusantara/features/add_important_task/view/add_important_task_screen.dart';
import 'package:agen_nusantara/features/add_usual_task/bindings/add_usual_task_binding.dart';
import 'package:agen_nusantara/features/add_usual_task/view/add_usual_task_screen.dart';
import 'package:agen_nusantara/features/home/bindings/home_binding.dart';
import 'package:agen_nusantara/features/home/view/home_screen.dart';
import 'package:agen_nusantara/features/login/bindings/login_binding.dart';
import 'package:agen_nusantara/features/login/view/login_screen.dart';
import 'package:agen_nusantara/features/settings/bindings/setting_binding.dart';
import 'package:agen_nusantara/features/settings/view/setting_screen.dart';
import 'package:agen_nusantara/features/task_list/bindings/task_list_binding.dart';
import 'package:agen_nusantara/features/task_list/view/task_list_screen.dart';
import 'package:get/get.dart';

abstract class Pages {
  static final pages = [
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingScreen(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: Routes.addUsualTask,
      page: () => const AddUsualTaskScreen(),
      binding: AddUsualTaskBinding(),
    ),
    GetPage(
      name: Routes.addImportantTask,
      page: () => const AddImportantTaskScreen(),
      binding: AddImportantTaskBinding(),
    ),
    GetPage(
      name: Routes.taskList,
      page: () => const TaskListScreen(),
      binding: TaskListBinding(),
    ),
  ];
}
