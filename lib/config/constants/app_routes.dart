
import 'package:get/get.dart';
import 'package:hourlynotes/domain/controller/account_controller.dart';
import 'package:hourlynotes/presentation/login_screen.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.LOGIN, page: () => LoginScreen()),
  ];
}

abstract class AppRoutes {
  static Future<String> get initialRoute async {
    int count = Get.find<AccountController>().onboardCount;
    return count == 0 ? ONBOARD : INITIAL;
  }

  static const ALL_CHAT = '/note-detail';
  static const INITIAL = '/';
  static const NOINTERNET = '/no-internet';
  static const HOME = '/home';
  static const ONBOARD = '/';
  static const LOGIN = '/login';}
