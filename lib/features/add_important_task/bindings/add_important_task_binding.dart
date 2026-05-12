import 'package:agen_nusantara/features/add_important_task/controllers/add_important_task_controller.dart';
import 'package:get/get.dart';

class AddImportantTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddImportantTaskController>(() => AddImportantTaskController());
  }
}
