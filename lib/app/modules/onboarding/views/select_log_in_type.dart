import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/modules/bottomnavigationbar/views/bottomnavigationbar_view.dart';
import 'package:scrap_app/app/modules/registration/controllers/registration_controller.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:scrap_app/models/users.dart';

class NameInputPage extends StatelessWidget {
  final UserModel userModl;

  NameInputPage({super.key, required this.userModl});

  final AuthController authController = Get.find<AuthController>();
  final RxString name = ''.obs;
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    name.value = userModl.name;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 80, 40, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width * 1,
                        padding: const EdgeInsets.only(bottom: 8),
                        child: AutoSizeText(
                          translation(context).scraptocash,
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 60,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      AutoSizeText(
                        translation(context).namescreenmaintext,
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.7),
                            fontFamily: "Inter",
                            fontSize: 17),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AutoSizeText(
                          translation(context).entername,
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 32,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      Obx(() => TextField(
                            onChanged: (value) => name.value = value.trim(),
                            decoration: InputDecoration(
                              hintText: translation(context).yourname,
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                            ),
                            controller: nameController..text = name.value,
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  log("Submitting...");
                  final nameValue = name.value;
                  if (nameValue.isNotEmpty) {
                    log("Name is not empty: $nameValue");

                    userModl.name = nameValue;
                    userModl.createdAt =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    final phoneNumber =
                        authController.userModel?.phoneNumber ?? '';
                    final uid = authController.userModel?.uid ?? '';

                    final updatedUserModel = UserModel(
                      name: nameValue,
                      email: userModl.email,
                      createdAt: userModl.createdAt,
                      phoneNumber: phoneNumber,
                      uid: userModl.uid,
                    );

                    await storeData(
                      context: context,
                      authController: authController,
                      userModel: updatedUserModel,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(translation(context).namecantbeempty)),
                    );
                  }
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: Get.width * 2,
                    height: Get.height * 0.065,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(0, 255, 38, 0)
                              .withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 10),
                        )
                      ],
                      color: const Color.fromARGB(255, 255, 108, 22),
                    ),
                    child: Transform.translate(
                      offset: const Offset(0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_forward_rounded,
                              color: Color.fromARGB(255, 255, 255, 255)),
                          const SizedBox(width: 2),
                          AutoSizeText(
                            translation(context).submit,
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255)),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> storeData({
  required BuildContext context,
  required AuthController authController,
  required UserModel userModel,
}) async {
  try {
    await authController.saveUserDataToFirebase(
      context: context,
      userModal: userModel,
      onSuccess: () async {
        await authController.saveUserDataToSP();

        await authController.setSignIn();

        Get.offAll(() => const BottomnavigationbarView());
      },
    );
  } catch (e) {
    log('Error storing data: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An error occurred while saving data.')),
    );
  }
}
