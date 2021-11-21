import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  static BottomNavigationController get to => Get.find();
  RxInt _tabIndex = 0.obs;

  void changeTabIndex(int index) {
    _tabIndex(index);
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }
  RxInt get curPage => _tabIndex;

}