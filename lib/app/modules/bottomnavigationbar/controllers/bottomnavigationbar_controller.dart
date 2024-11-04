import 'package:get/get.dart';

class BottomNavigationBarController extends GetxController {
  var currentIndex = 0.obs;

  void updateIndex(int index) {
    currentIndex.value = index;
  }
}
