import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrap_app/app/modules/home/controllers/home_controller.dart';
import 'package:scrap_app/app/utils/app_colors.dart';
import 'package:scrap_app/app/utils/constant_variable.dart';
import 'package:scrap_app/app/widget/app_text_field.dart';
import 'package:scrap_app/app/widget/app_text_widget.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
// import 'package:scrap_app/models/items.dart';

class BookingStep extends GetView<HomeController> {
  const BookingStep({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ct) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            addVerticalSpace(6),
            AppTextFormField(
              hintText: translation(context).placehint,
              controller: controller.completeAddressController,
            ),
            addVerticalSpace(15),
            AppTextFormField(
              hintText: translation(context).datehint,
              controller: controller.dateController,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime(2101),
                );

                if (picked != null && picked != controller.selectedDate) {
                  controller.selectedDate = picked;
                  controller.dateController.text = controller.selectedDate
                      .toLocal()
                      .toString()
                      .split(' ')[0];
                  controller.update();
                }
              },
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return translation(context).plsselectdate;
                }
                return null;
              },
            ),
            addVerticalSpace(15),
            AppTextFormField(
              hintText: translation(context).weighthint,
              controller: controller.weightController,
            ),
            addVerticalSpace(15),
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(8)),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox.shrink(),
                value: controller.selectedPaymentMethod,
                items: controller.paymentMethod(context).map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? selectedItem) {
                  controller.selectedPaymentMethod = selectedItem!;
                  controller.update();
                },
                hint: Text(translation(context).selectpayment),
              ),
            ),
            addVerticalSpace(15),
            InkWell(
              onTap: () {
                controller.selectImageFromCamera(ImageSource.camera);
              },
              child: Container(
                height: Get.height * 0.15,
                width: Get.width * 0.3,
                decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.textColor)),
                child: controller.selectedImage != null
                    ? Image.file(controller.selectedImage!)
                    : Center(
                        child: AppTextWidget(
                        text: translation(context).scrapphototext,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      )),
              ),
            )
          ],
        ),
      );
    });
  }
}
