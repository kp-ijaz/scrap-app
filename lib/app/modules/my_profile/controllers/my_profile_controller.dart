import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrap_app/app/routes/app_pages.dart';
import 'package:scrap_app/app/widget/custom_loader_dialog.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:scrap_app/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  UserModel? users;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  bool readOnly = true;
  File? selectedImage;
  String privacyPolicy = "";
  String termsAndConditions = "";
  String contactEmail = "";
  String contactPhone = "";

  @override
  void onInit() {
    super.onInit();
    fetchUserDetailsFromSP();
    fetchTermsAndConditions();
    fetchPrivacyPolicy();
  }

  Future<void> selectImageFromCamera(ImageSource source) async {
    final returnImage = await ImagePicker().pickImage(source: source);
    if (returnImage == null) return;
    Get.back();
    Get.snackbar(translation(Get.context!).selectedimageisnolonger, '');
  }

  updateProfile() async {
    String? userId = await getUserIdFromSP();

    if (userId != null) {
      DocumentSnapshot userSnapshot =
          await _firebaseFirestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        UserModel userModel =
            UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

        userModel.name = nameController.text;
        userModel.phoneNumber = numberController.text;

        await updateUserData(userModel);

        await saveUserDataToSP(userModel);

        Get.snackbar(translation(Get.context!).profileupdated, '');
        Get.offAllNamed(Routes.BOTTOMNAVIGATIONBAR);

        users = userModel;
        update();
      } else {
        Get.snackbar(translation(Get.context!).userdatanotfound, '');
      }
    } else {
      Get.snackbar(translation(Get.context!).error,
          translation(Get.context!).usernotloggedin);
    }
  }

  updateUserData(UserModel userModel) async {
    AppLoader().showLoader(Get.context!);
    await _firebaseFirestore
        .collection('users')
        .doc(userModel.uid)
        .set(userModel.toMap(), SetOptions(merge: true));
    Get.back();
  }

  Future<void> saveUserDataToSP(UserModel userModel) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userData = jsonEncode(userModel.toMap());
      await prefs.setString("user_model", userData);
      log("User data updated in SharedPreferences.");
    } catch (e) {
      log('Error saving user data to SharedPreferences: $e');
    }
  }

  Future<String?> getUserIdFromSP() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString("user_model");

      if (userData != null) {
        Map<String, dynamic> userMap = jsonDecode(userData);
        UserModel userModel = UserModel.fromMap(userMap);

        return userModel.uid;
      } else {
        log("No user data found in SharedPreferences.");
        return null;
      }
    } catch (e) {
      log('Error fetching user ID from SharedPreferences: $e');
      return null;
    }
  }

  fetchAdminDetails() async {
    await _firebaseFirestore
        .collection('Admin')
        .doc('utIKt5YAdxG7SmACG8ZT')
        .get()
        .then((value) {
      if (value.data() != null) {
        privacyPolicy = value.data()!['privacyPolicy'];
        termsAndConditions = value.data()!['termsAndconditions'];
        contactEmail = value.data()!['contactEmail'];
        contactPhone = value.data()!['contactPhone'];
        update();
      }
    });
  }

  Future<void> fetchTermsAndConditions() async {
    try {
      final doc = await _firebaseFirestore
          .collection('app_info')
          .doc('terms_and_conditions')
          .get();

      if (doc.exists) {
        termsAndConditions = doc.data()?['termsAndConditions'] ??
            'No terms and conditions available';
        update();
      } else {
        Get.snackbar(translation(Get.context!).tandcnotexist, '');
      }
    } catch (e) {
      Get.snackbar(translation(Get.context!).errorontandc, '');
    }
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('app_info')
          .doc('privacy_policy')
          .get();

      if (doc.exists) {
        privacyPolicy =
            doc.data()?['privacyPolicy'] ?? 'No privacy policy available';
        update();
      } else {
        Get.snackbar(translation(Get.context!).privcypolicynotexist, '');
      }
    } catch (e) {
      log('Error fetching privacy policy: $e');
      Get.snackbar(translation(Get.context!).erroronprivacypolicy, '');
    }
  }

  deleteUserAccount() async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .delete();
    await _firebaseAuth.currentUser!.delete();
    Get.snackbar(translation(Get.context!).successaccounttdeleted, '');
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> logout() async {
    try {
      SharedPreferences s = await SharedPreferences.getInstance();
      await s.clear();
      log("User logged out and SharedPreferences cleared.");
      Get.offAllNamed(Routes.ONBOARDING);
    } catch (e) {
      log("Error during logout: $e");
    }
  }

  Future<void> fetchUserDetailsFromSP() async {
    try {
      SharedPreferences s = await SharedPreferences.getInstance();
      String? userData = s.getString("user_model");

      if (userData != null) {
        Map<String, dynamic> userMap = jsonDecode(userData);
        users = UserModel.fromMap(userMap);
        update();
      } else {
        log("No user data found in SharedPreferences.");
      }
    } catch (e) {
      log("Error fetching user data from SharedPreferences: $e");
    }
  }
}
