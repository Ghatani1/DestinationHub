import 'package:get/get.dart';

class StateController extends GetxController {
  @override
  void onInit() {
    checkUser();
    super.onInit();
  }

  checkUser() {
    Future.delayed(const Duration(seconds: 4)).then((value) {
      Get.offAllNamed('/HomePage');
    });
  }
}
