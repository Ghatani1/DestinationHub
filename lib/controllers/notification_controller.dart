import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notificationCount = 0.obs;

  void updateNotificationCount(int newCount) {
    notificationCount.value = newCount;
  }
}
