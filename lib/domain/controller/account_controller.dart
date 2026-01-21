import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hourlynotes/data/auth_service.dart';
import 'package:hourlynotes/data/hive_service.dart';

import '../models/user_models.dart';


class AccountController extends GetxController {

  late AuthService _auth;
  late HiveService _db;



  RxBool isButtonLoading = false.obs;
  RxBool isAppLinkLoading = false.obs;
  final GlobalKey<FormState> usernameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> phoneKey = GlobalKey<FormState>();
  var firstNameController = TextEditingController(text: '').obs;
  var emailController = TextEditingController(text: '').obs;



  var user = User().obs;

  int onboardCount = 0;

  @override
  void onInit() {
    _auth = AuthService();
    super.onInit();
  }


  getUser() async {

    final box = await _db.getBox<Map<dynamic, dynamic>>(HiveService.userSettingsBox);
    final userCached = box.get(USER_KEY);
    if(userCached != null) {
      debugPrint(userCached.toString());
      user.value = User.fromJson(userCached as Map<String, dynamic>);
    }
  }




}