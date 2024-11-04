import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/routes/app_pages.dart';
import 'package:scrap_app/app/utils/db_keys.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:scrap_app/models/items.dart';
import 'package:scrap_app/models/orders.dart';
import 'package:scrap_app/models/users.dart';
import 'package:scrap_app/services/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/app_colors.dart';
import '../../../widget/app_text_widget.dart';

class MyBookingsController extends GetxController {
  RxBool tempBool = false.obs;
  bool isAgentFlow = false;
  int? qty = 0;
  TextEditingController qtyController = TextEditingController();
  List<Orders> orders = [];
  var isLoading = false.obs;

  Timer? timer;
  int resendInterval = 30;

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  List pickupList = [
    {"prodName": "Soda can", "price": 200.0, "totalPrice": 0.0, "qty": 0},
    {"prodName": "Plastic Bag", "price": 400.0, "totalPrice": 0.0, "qty": 0},
    {"prodName": "Soda can", "price": 300.0, "totalPrice": 0.0, "qty": 0},
    {"prodName": "Soda can", "price": 100.0, "totalPrice": 0.0, "qty": 0},
  ];

  var qtyControllers = <TextEditingController>[].obs;

  void initializeControllers(int length) {
    qtyControllers.value =
        List.generate(length, (index) => TextEditingController());
  }

  void updateController(int index, String value) {
    if (index < qtyControllers.length) {
      qtyControllers[index].text = value;
      update();
    }
  }

  void addController() {
    qtyControllers.add(TextEditingController());
    update();
  }

  @override
  void onClose() {
    for (var controller in qtyControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  fetchBooking() async {
    try {
      String? userId = await getUserIdFromSP();
      log("User ID: $userId");

      if (userId == null) return;

      if (LocalStorage().read(DBKeys.userType) == 'agent') {
        log("checkimg on agent+=+=+=+==+=++++====+=+=+=+=");
        firestore
            .collection('Orders')
            .where('agentId', isEqualTo: userId)
            .snapshots()
            .listen((value) {
          orders.clear();
          if (value.docs.isNotEmpty) {
            orders = List<Orders>.from(value.docs
                .map((e) => Orders.fromJson({'id': e.id, ...e.data()})));
            update();
          } else {
            log("No orders found for agent.");
          }
        });
      } else {
        log("checkimg on user-=-=-=---==-=-=-=-=-=-=-=-=-=-=-");
        await firestore
            .collection('Orders')
            .where('userId', isEqualTo: userId)
            .get()
            .then((value) {
          orders.clear();
          if (value.docs.isNotEmpty) {
            orders = List<Orders>.from(value.docs.map((e) {
              if (e["userId"] == userId) {
                List<Items> tempItems = [];
                for (int i = 0; i < e["items"].length; i++) {
                  Items subItems = Items(
                      name: e["items"][i]["name"],
                      category: e["items"][i]["category"],
                      price: e["items"][i]["price"].toString(),
                      imageUrl: e["items"][i]["imageUrl"]);
                  tempItems.add(subItems);
                }
                Orders obj = Orders(
                    id: e.id,
                    status: e["status"],
                    date: e["date"],
                    address: e["address"],
                    weight: e["weight"],
                    paymentMode: e["paymentMode"],
                    scrapImage: e["scrapImage"],
                    paymentProofImage: e["paymentProofImage"],
                    paymentDetails: e["paymentDetails"],
                    userId: userId,
                    agentId: e["agentId"],
                    items: tempItems,
                    amount: e["amount"],
                    paymentDate: e["paymentDate"]);
                return obj;
              }

              // Orders.fromJson({'id': e.id, ...e.data()});
            }));
            update();
          } else {
            log("No orders found for user.");
          }
        });
      }
    } catch (e) {
      log('Fetch User Booking Error: $e');
    }
  }

  Future<void> refetchBooking() async {
    try {
      isLoading.value = true;
      await fetchBooking();
    } finally {
      isLoading.value = false;
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

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendInterval <= 0) {
        timer.cancel();
        Get.back();
        successPaymentDialog;
      } else {
        resendInterval--;
        update();
      }
    });
  }

  @override
  void onReady() {
    isAgentFlow = LocalStorage().read(DBKeys.userType) == 'agent' ?? false;
    update();
    super.onReady();
  }

  void onClosee() {
    super.onClose();
  }
}

Future<T?> successPaymentDialog<T>(BuildContext context) async {
  Future.delayed(const Duration(seconds: 2), () {
    Get.offNamedUntil(Routes.MY_BOOKINGS, (route) => false);
  });

  Get.dialog(
    AlertDialog(
      surfaceTintColor: AppColor.white,
      content: SizedBox(
        height: Get.height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/images/successIcon.png",
              height: Get.height * 0.18,
            ),
            AppTextWidget(
              text: translation(context).paymentsuccess,
              fontSize: 18,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    ),
  );
  return null;
}
