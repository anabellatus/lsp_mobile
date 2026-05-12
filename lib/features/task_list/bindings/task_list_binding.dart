import 'package:agen_nusantara/features/task_list/controllers/task_list_controller.dart';
import 'package:get/get.dart';

class TaskListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskListController>(() => TaskListController());
  }
}
