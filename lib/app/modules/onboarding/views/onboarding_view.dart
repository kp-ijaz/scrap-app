import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/modules/bottomnavigationbar/views/bottomnavigationbar_view.dart';
import 'package:scrap_app/app/modules/onboarding/views/select_log_in_type.dart';
import 'package:scrap_app/app/modules/registration/controllers/registration_controller.dart';
import 'package:scrap_app/app/utils/snackbar.dart';
import 'package:scrap_app/app/widget/app_button.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:scrap_app/models/users.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:otpless_flutter/otpless_flutter.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isProceed = false;

  final _otplessFlutterPlugin = Otpless();
  var arg = {
    'appId': 'OVRT9VUBD4CRUBFHJ0N8',
  };

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: controller,
                    children: [
                      buildPage(
                          imgUrl: 'assets/images/3.png', context: context),
                      buildPage(
                          imgUrl: 'assets/images/4.png', context: context),
                      buildPage(
                          imgUrl: 'assets/images/5.png', context: context),
                    ],
                    onPageChanged: (index) {
                      setState(() {
                        isProceed = index == 2;
                      });
                    },
                  ),
                  Positioned(
                    left: 22,
                    right: 20,
                    bottom: 25,
                    child: Center(
                      child: Column(
                        children: [
                          SmoothPageIndicator(
                            count: 3,
                            controller: controller,
                            effect: WormEffect(
                              spacing: width * 0.015,
                              dotWidth: width * 0.02,
                              dotHeight: height * 0.01,
                              dotColor: const Color.fromRGBO(219, 207, 240, 1),
                              activeDotColor:
                                  const Color.fromARGB(255, 228, 218, 210),
                            ),
                          ),
                          const SizedBox(height: 20),
                          isProceed
                              ? AppButtonBoarding(
                                  onPressed: () async {
                                    _otplessFlutterPlugin.openLoginPage(
                                      (result) async {
                                        log("Result: $result");

                                        if (result.containsKey('data')) {
                                          final data = result['data'];

                                          if (data.containsKey('status') &&
                                              data['status'] == 'SUCCESS') {
                                            final userData = data;
                                            final token = data['token'];
                                            final userId = data['userId'];
                                            final name = userData['identities']
                                                [0]['name'];
                                            final identityValue =
                                                userData['identities'][0]
                                                    ['identityValue'];

                                            final userModel = UserModel(
                                              name: name ?? '',
                                              email: identityValue,
                                              createdAt: DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString(),
                                              phoneNumber: identityValue,
                                              uid: userId,
                                            );
                                            log("${userModel.uid}useeeeerrrrriiiiiddddddd99999999999999999");
                                            final authController =
                                                Get.find<AuthController>();
                                            await storeData(
                                              context,
                                              authController,
                                              userModel,
                                            );
                                          } else {
                                            final errorMessage =
                                                data['errorMessage'] ??
                                                    'An error occurred';
                                            showSnackBar(context, errorMessage);
                                          }
                                        } else {
                                          showSnackBar(
                                              context,
                                              translation(context)
                                                  .unexpectederror);
                                        }
                                      },
                                      arg,
                                    );
                                  },
                                  buttonText:
                                      translation(context).continue_text,
                                )
                              : AppButtonBoarding(
                                  onPressed: () {
                                    controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  buttonText: translation(context).next,
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildPage({required BuildContext context, required String imgUrl}) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imgUrl),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Future<void> storeData(
  BuildContext context,
  AuthController authController,
  UserModel userModel,
) async {
  if (userModel.name.isEmpty) {
    // Navigate to NameInputPage with userModel if name is missing
    Get.to(() => NameInputPage(userModl: userModel));
  } else {
    // Save user data to Firebase and SharedPreferences
    await authController.saveUserDataToFirebase(
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
