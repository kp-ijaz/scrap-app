import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scrap_app/app/modules/bottomnavigationbar/controllers/bottomnavigationbar_controller.dart';
// import 'package:scrap_app/app/modules/bottomnavigationbar/views/bottomnavigationbar_view.dart';
import 'package:scrap_app/app/routes/app_pages.dart';
import 'package:scrap_app/app/utils/app_colors.dart';
import 'package:scrap_app/app/utils/constant_variable.dart';
import 'package:scrap_app/app/widget/app_text_widget.dart';
import 'package:scrap_app/app/widget/custom_loader_dialog.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:scrap_app/models/items.dart';
import 'package:scrap_app/models/orders.dart';
import 'package:scrap_app/models/users.dart';
import 'package:scrap_app/services/cloud_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  RxBool tempRxValue = false.obs;
  RxInt currentStep = 0.obs;
  File? selectedImage;
  RxInt selectedCat = 0.obs;
  String? selectedPaymentMethod;
  RxList<Items> items = <Items>[].obs;
  Map<String, List<Items>> selectedItemsMap = {};
  String address = "";
  final formKey = GlobalKey<FormState>();
  UserModel? users;
  String? uploadedImageUrl;
  RxnBool isPincodeAvailable = RxnBool(null);

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final streetAddressController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  final completeAddressController = TextEditingController();
  final weightController = TextEditingController();

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    // addItemToEwaste();
    fetchItemsByCategory();
    fetchUserDetailsFromSP();
  }

  Future<String?> selectImageFromCamera(ImageSource source) async {
    try {
      final returnImage = await ImagePicker().pickImage(source: source);
      if (returnImage == null) return null;

      selectedImage = File(returnImage.path);
      Get.back();

      AppLoader().showLoader(Get.context!);

      String imageUrl =
          await CloudStorageServices().uploadImage(selectedImage!);

      Get.back();
      update();

      uploadedImageUrl = imageUrl;
      return imageUrl;
    } catch (e) {
      Get.back();
      Get.snackbar("${translation(Get.context!).uploadimgfail}:", "$e");
      log('Error uploading image: $e');
      return null;
    }
  }

  Future<bool> checkPincodeAvailability(String pincode) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Pincodes')
          .doc('pincode')
          .get();

      if (snapshot.exists) {
        List<dynamic> pinArray = snapshot['pin'];
        if (pinArray.contains(int.parse(pincode))) {
          print("Pincode $pincode is available.");
          return true;
        } else {
          print("Pincode $pincode is not available.");
          return false;
        }
      } else {
        print("Document does not exist.");
        return false;
      }
    } catch (e) {
      print("Error checking pincode: $e");
      return false;
    }
  }

  void updatePincodeIcon(bool isAvailable) {
    isPincodeAvailable.value = isAvailable;
  }

  void resetPincodeIcon() {
    isPincodeAvailable.value = null;
  }

  List<ScrapCategoryModel> getScrapCatList(BuildContext context) {
    return [
      ScrapCategoryModel(
          id: 1,
          image: "assets/images/plastic.png",
          title: translation(context).plastic_title,
          subTitle: translation(context).plastic_subtitle),
      ScrapCategoryModel(
          id: 2,
          image: "assets/images/metal.png",
          title: translation(context).metal_title,
          subTitle: translation(context).metal_subtitle),
      ScrapCategoryModel(
          id: 3,
          image: "assets/images/ewaste.png",
          title: translation(context).ewaste_title,
          subTitle: translation(context).ewaste_subtitle),
      ScrapCategoryModel(
          id: 4,
          image: "assets/images/papers.png",
          title: translation(context).paper_title,
          subTitle: translation(context).paper_subtitle),
      ScrapCategoryModel(
          id: 5,
          image: "assets/images/others.png",
          title: translation(context).others_title,
          subTitle: translation(context).others_subtitle),
    ];
  }

  List<String> paymentMethod(BuildContext context) {
    return [
      translation(context).online,
      translation(context).cash,
    ];
  }

  List<Step> steps(BuildContext context) {
    return <Step>[
      Step(
        title: const SizedBox.shrink(),
        content: const Text(''),
        state: currentStep.value >= 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep.value >= 0,
        label: AutoSizeText(translation(context).selectscrap),
      ),
      Step(
        title: const SizedBox.shrink(),
        content: const Text(''),
        isActive: currentStep.value >= 1,
        state: currentStep.value >= 1 ? StepState.complete : StepState.indexed,
        label: AutoSizeText(translation(context).pickupaddress),
      ),
      Step(
        title: const SizedBox.shrink(),
        content: const Text(''),
        isActive: currentStep.value >= 2,
        state: currentStep.value >= 2 ? StepState.complete : StepState.indexed,
        label: AutoSizeText(translation(context).confirmbuttontext),
      ),
    ];
  }

  List dummyScrapList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  Future<void> fetchItemsByCategory() async {
    log("Fetching items...");

    final categoryMapping = {
      0: 'plastic',
      1: 'metal',
      2: 'e-waste',
      3: 'paper',
      4: 'others',
    };

    if (selectedCat < 0 || selectedCat > 4) {
      log('Invalid selectedCat value: $selectedCat');
      return;
    }

    String category = categoryMapping[selectedCat.value] ??
        translation(Get.context!).others.toLowerCase();

    log('Selected category index: ${selectedCat.value}');
    log('Category resolved: $category');

    try {
      log('Fetching all items from Firestore');

      final QuerySnapshot snapshot = await firestore.collection('items').get();

      if (snapshot.docs.isNotEmpty) {
        items.value = snapshot.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final itemCategory = (data['category'] as String).toLowerCase();

          return itemCategory == category;
        }).map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          log('Document data: $data');
          return Items.fromJson({
            'id': doc.id,
            'name': data['name'] as String,
            'category': (data['category'] as String).toLowerCase(),
            'price': data['price'] as String,
            'imageUrl': data['imageUrl'] as String,
            'checked':
                selectedItemsMap[category]?.any((item) => item.id == doc.id) ??
                    false,
          });
        }).toList();
        log('Items fetched: ${items.length}');
      } else {
        items.value = [];
        log('No items found');
      }
    } catch (e) {
      log('Error fetching items: $e');
    }
  }

  void toggleItemSelection(Items item) {
    String category = item.category;
    if (selectedItemsMap[category] == null) {
      selectedItemsMap[category] = [];
    }

    if (item.selected) {
      selectedItemsMap[category]!.add(item);
    } else {
      selectedItemsMap[category]!
          .removeWhere((element) => element.id == item.id);
    }
    update();
  }

  // Future<void> addItemToEwaste() async {
  //   try {
  //     // Define the item data
  //     final itemData = {
  //       'name': 'computers',
  //       'price': 200,
  //       'category': 'E-Waste',
  //       'checked': false,
  //     };

  //     // Add the item to the Firestore collection
  //     await firestore.collection('items').add(itemData);

  //     log('Item added successfully: $itemData');
  //   } catch (e) {
  //     log('Error adding item: $e');
  //   }
  // }

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

  addAddress() {
    if (formKey.currentState!.validate()) {
      address =
          "${nameController.text}, ${phoneController.text}, ${streetAddressController.text}, ${addressController.text}, ${cityController.text}, ${pincodeController.text}";
      completeAddressController.text = address;
      update();
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

  Future<void> addOrder(BuildContext context) async {
    try {
      if (selectedPaymentMethod != null) {
        if (uploadedImageUrl != null) {
          if (dateController.text.isEmpty) {
            Get.snackbar(translation(context).plsselectdate, '');
            return;
          }
          log("Inside the addOrder function");

          AppLoader().showLoader(context);
          log("Loading...");

          String? userId = await getUserIdFromSP();
          DateFormat dateFormat = DateFormat('dd/MM/yyyy');
          if (userId == null) {
            Get.snackbar(translation(context).usernotfoundinsp, '');
            log("User ID not found: $userId");
            Get.back();
            return;
          }
          log("User ID: $userId");

          String weight =
              weightController.text.isEmpty ? "0" : weightController.text;

          // Collect all selected items from selectedItemsMap
          List<Items> selectedItems = [];
          selectedItemsMap.forEach((category, items) {
            selectedItems.addAll(items.where((item) => item.selected));
          });

          // Format the date
          String formattedDate = dateFormat.format(selectedDate);

          Orders order = Orders(
            id: '',
            status: 'new',
            date: formattedDate,
            address: address,
            weight: weight,
            paymentMode: selectedPaymentMethod!,
            scrapImage: uploadedImageUrl!,
            paymentProofImage: "",
            paymentDetails: {},
            userId: userId,
            agentId: "",
            items: selectedItems,
            amount: selectedItems
                .fold(
                  0.0,
                  (previousValue, element) =>
                      previousValue + double.parse(element.price),
                )
                .toString(),
            paymentDate: 0,
          );

          await firestore.collection('Orders').add(order.tojson());

          clearOrderDetails();

          Get.back();

          Get.dialog(
            AlertDialog(
              surfaceTintColor: AppColor.white,
              content: SizedBox(
                height: Get.height * 0.37,
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    addVerticalSpace(20),
                    AppTextWidget(
                      text: translation(context).bookingsuccess,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      maxLines: 2,
                      minFontSize: 10,
                    ),
                    addVerticalSpace(20),
                    Image.asset(
                      "assets/images/successIcon.png",
                      height: Get.height * 0.18,
                    ),
                    addVerticalSpace(20),
                    AppTextWidget(
                      text: translation(context).pickupmessage,
                      fontSize: 18,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w700,
                      minFontSize: 12,
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: true,
          ).then((_) {
            Get.offAllNamed(Routes.BOTTOMNAVIGATIONBAR);
            final bottomNavController =
                Get.find<BottomNavigationBarController>();
            bottomNavController.updateIndex(1);
          });
        } else {
          Get.snackbar(translation(context).errorimage, '');
        }
      } else {
        Get.snackbar(translation(context).errorpayment, '');
      }
    } catch (e) {
      log('Add Orders Error: $e');
    }
  }

  void clearOrderDetails() {
    address = '';
    weightController.clear();
    selectedPaymentMethod = null;
    uploadedImageUrl = null;
    selectedImage = null;
    dateController.clear();
    completeAddressController.clear();
    nameController.clear();
    addressController.clear();
    streetAddressController.clear();
    pincodeController.clear();
    cityController.clear();
    phoneController.clear();
    items.clear();
    isPincodeAvailable.isFalse;
    selectedItemsMap.clear();

    currentStep.value = 0;
    update();
  }
}

class ScrapCategoryModel {
  final int? id;
  final String? title;
  final String? subTitle;
  final String? image;
  ScrapCategoryModel({this.title, this.subTitle, this.image, this.id});
}
