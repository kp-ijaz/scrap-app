import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrap_app/app/routes/app_pages.dart';
import 'package:scrap_app/app/utils/db_keys.dart';
import 'package:scrap_app/services/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkUserStatus();
  }

  Future<void> checkUserStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userModelString = prefs.getString("user_model");
    log("{$userModelString}");

    if (userModelString != null) {
      Get.offAllNamed(Routes.BOTTOMNAVIGATIONBAR);
    } else {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.offAndToNamed(Routes.LANGUAGESCREEN);
      } else {
        String userType = LocalStorage().read(DBKeys.userType) ?? '';

        if (userType == 'user') {
          bool isProfileCompleted = await checkProfileCompletion(user.uid);
          if (isProfileCompleted) {
            Get.offAllNamed(Routes.BOTTOMNAVIGATIONBAR);
          } else {
            Get.offAndToNamed(Routes.LANGUAGESCREEN);
          }
        } else {
          Get.offAndToNamed(Routes.LANGUAGESCREEN);
        }
      }
    }
  }

  Future<bool> checkProfileCompletion(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        if (userData != null &&
            userData.containsKey('displayName') &&
            userData.containsKey('phoneNumber')) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      log('Error checking profile completion: $e');
      return false;
    }
  }
}
