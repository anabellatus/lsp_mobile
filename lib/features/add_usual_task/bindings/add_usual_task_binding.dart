import 'package:agen_nusantara/features/add_usual_task/controllers/add_usual_task_controller.dart';
import 'package:get/get.dart';

class AddUsualTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddUsualTaskController>(() => AddUsualTaskController());
  }
}
