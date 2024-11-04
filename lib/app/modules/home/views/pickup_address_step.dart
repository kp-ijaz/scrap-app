// pickup_address_step.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/modules/home/controllers/home_controller.dart';
import 'package:scrap_app/app/utils/constant_variable.dart';
import 'package:scrap_app/app/widget/app_text_field.dart';
import 'package:scrap_app/l10n/languagemanager.dart';

class PickupAddressStep extends GetView<HomeController> {
  const PickupAddressStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            AppTextFormField(
              hintText: translation(context).name,
              controller: controller.nameController,
              validator: (p0) {
                if (p0 != null && p0.isEmpty) {
                  return translation(context).errorname;
                }
                return null;
              },
            ),
            addVerticalSpace(15),
            AppTextFormField(
              hintText: translation(context).address,
              controller: controller.addressController,
              validator: (p0) {
                if (p0 != null && p0.isEmpty) {
                  return translation(context).erroradrress;
                }
                return null;
              },
            ),
            addVerticalSpace(15),
            AppTextFormField(
              hintText: translation(context).streetaddress,
              controller: controller.streetAddressController,
            ),
            addVerticalSpace(15),
            AppTextFormField(
              keyBoardType: TextInputType.number,
              hintText: translation(context).pincode,
              controller: controller.pincodeController,
              inputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              validator: (pincode) {
                if (pincode == null || pincode.isEmpty) {
                  return translation(context).errorpin;
                }
                return null;
              },
              onChange: (value) async {
                if (value.length == 6) {
                  bool isAvailable =
                      await controller.checkPincodeAvailability(value);
                  controller.updatePincodeIcon(isAvailable);
                } else {
                  controller.resetPincodeIcon();
                }
              },
              suffixIcon: Obx(() {
                return Icon(
                  controller.isPincodeAvailable.value == null
                      ? null
                      : controller.isPincodeAvailable.value!
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                  color: controller.isPincodeAvailable.value == null
                      ? null
                      : controller.isPincodeAvailable.value!
                          ? Colors.blue
                          : Colors.red,
                );
              }),
            ),
            Obx(() {
              return controller.isPincodeAvailable.value == false
                  ? const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Pickup is not available in this pincode",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container();
            }),
            addVerticalSpace(15),
            AppTextFormField(
              hintText: translation(context).city,
              controller: controller.cityController,
              validator: (p0) {
                if (p0 != null && p0.isEmpty) {
                  return translation(context).errorcity;
                }
                return null;
              },
            ),
            addVerticalSpace(15),
            AppTextFormField(
              controller: controller.phoneController,
              hintText: translation(context).mobilenumber,
              keyBoardType: TextInputType.phone,
              inputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10)
              ],
              validator: (p0) {
                if (p0 != null && p0.isEmpty) {
                  return translation(context).errormobile;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
