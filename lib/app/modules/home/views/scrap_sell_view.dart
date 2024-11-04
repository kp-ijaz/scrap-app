import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/modules/home/controllers/home_controller.dart';
import 'package:scrap_app/app/modules/home/views/booking_step.dart';
import 'package:scrap_app/app/modules/home/views/pickup_address_step.dart';
import 'package:scrap_app/app/modules/home/views/select_scrap_step.dart';
import 'package:scrap_app/app/routes/app_pages.dart';
import 'package:scrap_app/app/utils/app_colors.dart';
import 'package:scrap_app/app/widget/app_button.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
// import '../../../widget/common_app_bar.dart';

class ScrapSellView extends GetView<HomeController> {
  const ScrapSellView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                if (controller.currentStep.value > 0) {
                  controller.currentStep.value--;
                } else {
                  Get.offAllNamed(Routes.BOTTOMNAVIGATIONBAR);
                  controller.clearOrderDetails();
                }
                controller.update();
              },
              icon: const Icon(Icons.arrow_back)),
          title: Text(translation(context).scrap),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Obx(
            () {
              return controller.currentStep.value >= 2
                  ? AppButton(
                      onPressed: () {
                        controller.addOrder(context);
                      },
                      buttonText: translation(context).confirmbuttontext,
                    )
                  : AppButton(
                      bgColor: controller.currentStep.value == 0
                          ? controller.items
                                  .where((element) => element.selected)
                                  .isNotEmpty
                              ? AppColor.primaryColor
                              : AppColor.primaryColor.withOpacity(.1)
                          : AppColor.primaryColor,
                      onPressed: () {
                        if (controller.currentStep.value >= 0 &&
                            controller.currentStep.value < 2) {
                          if (controller.currentStep.value == 0 &&
                              controller.items
                                  .where((element) => element.selected)
                                  .isNotEmpty) {
                            controller.currentStep.value++;
                          } else if (controller.currentStep.value == 1 &&
                              controller.formKey.currentState!.validate()) {
                            controller.currentStep.value++;
                            controller.addAddress();
                          }
                          controller.update(); // Ensure UI reflects changes
                        }
                      },
                      buttonText: controller.currentStep.value == 0
                          ? translation(context).next
                          : controller.currentStep.value == 1
                              ? translation(context).addaddress
                              : "",
                    );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PopScope(
                canPop: false,
                onPopInvoked: ((didPop) {
                  if (didPop) {
                    return;
                  }
                  if (controller.currentStep.value > 0) {
                    controller.currentStep.value--;
                  } else {
                    Get.offAllNamed(Routes.BOTTOMNAVIGATIONBAR);
                    controller.clearOrderDetails();
                  }
                  controller.update();
                }),
                child: SizedBox(
                  height: Get.height * 0.14,
                  child: const HorizontalStepper(),
                ),
              ),
              controller.currentStep.value == 0
                  ? const SelectScrapStep()
                  : controller.currentStep.value == 1
                      ? const PickupAddressStep()
                      : const BookingStep(),
            ],
          ),
        ),
      );
    });
  }
}

class HorizontalStepper extends GetView<HomeController> {
  const HorizontalStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Stepper(
        elevation: 0,
        type: StepperType.horizontal,
        currentStep: controller.currentStep.value,
        onStepTapped: (step) {
          if (step < controller.currentStep.value) {
            controller.currentStep.value = step;
          }
        },
        steps: controller.steps(context),
        connectorThickness: 2,
      );
    });
  }
}
