import 'package:get/get.dart';

class AdminSidebarController extends GetxController {
  var selectedRoute = '/'.obs;

  void select(String route) {
    if (Get.currentRoute != route) {
      Get.offAllNamed(route);
    }
    selectedRoute.value = route;
  }

  @override
  void onInit() {
    selectedRoute.value = Get.currentRoute;
    super.onInit();
  }
}
