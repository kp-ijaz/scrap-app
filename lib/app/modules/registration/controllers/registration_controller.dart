import 'dart:convert';
import 'dart:developer';
// import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:scrap_app/app/modules/bottomnavigationbar/views/bottomnavigationbar_view.dart';
// import 'package:scrap_app/app/modules/login/views/otp_verify_view.dart';
import 'package:scrap_app/app/utils/snackbar.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:scrap_app/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  var isSignedIn = false.obs;
  var isLoading = false.obs;
  String? uid;
  UserModel? userModel;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    checkSign();
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    isSignedIn.value = s.getBool("is_signedin") ?? false;
  }

  Future<void> setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    isSignedIn.value = true;
    print("Signed in: ${s.getBool('is_signedin')}");
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {},
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    isLoading.value = true;
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOtp,
      );

      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        uid = user.uid;
        onSuccess();
      } else {
        showSnackBar(context, translation(context).userisnull);
      }

      isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      showSnackBar(context, e.message.toString());
    }
  }

  Future<bool> checkExistingUser() async {
    if (uid == null) {
      throw Exception("UID is null");
    }

    DocumentSnapshot snap =
        await _firebaseFirestore.collection("users").doc(uid).get();
    print("User exists: ${snap.exists}");
    return snap.exists;
  }

  Future<void> saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModal,
    required Function onSuccess,
  }) async {
    isLoading.value = true;
    try {
      String uid = userModal.uid;
      userModel = userModal;
      if (uid.isEmpty) {
        log("uid is empty");
        showSnackBar(context, translation(context).emptyuserid);
        isLoading.value = false;
        return;
      }

      userModal.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
      userModal.phoneNumber = _firebaseAuth.currentUser?.phoneNumber ?? "";
      userModal.uid = uid;

      await _firebaseFirestore
          .collection("users")
          .doc(uid)
          .set(userModal.toMap());

      onSuccess();

      isLoading.value = false;

      Get.to(() => const BottomnavigationbarView());
    } catch (e) {
      isLoading.value = false;

      showSnackBar(context, translation(context).errorsavingdata);
    }
  }

  Future<void> getDataFromFirestore() async {
    final uid = userModel?.uid;
    if (uid != null) {
      DocumentSnapshot snapshot =
          await _firebaseFirestore.collection("users").doc(uid).get();
      if (snapshot.exists) {
        userModel = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
        await saveUserDataToSP();
      }
    }
  }

  Future<void> saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    log("[][][][][]][]][[][[]][]]=======================================$userModel");
    if (userModel != null) {
      await s.setString("user_model", jsonEncode(userModel!.toMap()));
      log("User data saved to SharedPreferences: ${userModel.toString()}");
    } else {
      log("UserModel is null, unable to save data.");
    }
  }

  Future<void> signOut() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    isSignedIn.value = false;
    s.clear();
    userModel = null;
  }

  Future<void> storeData(
    BuildContext context,
    AuthController authController,
    TextEditingController nameController,
    TextEditingController bioController,
    TextEditingController emailController,
  ) async {
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      createdAt: "",
      phoneNumber: "",
      uid: "",
    );

    authController.saveUserDataToFirebase(
      context: context,
      userModal: userModel,
      onSuccess: () {
        authController.saveUserDataToSP().then(
              (value) => authController.setSignIn().then(
                    (value) =>
                        Get.offAll(() => const BottomnavigationbarView()),
                  ),
            );
      },
    );
  }
}
