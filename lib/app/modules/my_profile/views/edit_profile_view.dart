import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrap_app/app/modules/my_profile/controllers/my_profile_controller.dart';
import 'package:scrap_app/app/utils/app_colors.dart';
import 'package:scrap_app/app/utils/constant_variable.dart';
import 'package:scrap_app/app/widget/app_button.dart';
import 'package:scrap_app/app/widget/app_text_widget.dart';
import 'package:scrap_app/app/widget/common_app_bar.dart';
import 'package:scrap_app/l10n/languagemanager.dart';

class EditProfileView extends GetView<MyProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyProfileController>(builder: (ct) {
      controller.nameController.text = controller.users!.name;
      controller.mailController.text = controller.users!.email;

      controller.numberController.text = controller.users!.phoneNumber;
      return Scaffold(
        appBar: CommonAppBar(
          title: translation(context).profile,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
                  child: const Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                addVerticalSpace(30),
                AppTextWidget(
                  text: translation(context).details,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                addVerticalSpace(15),
                AppTextWidget(
                  text: "${translation(context).name} :",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  textColor: AppColor.lableColor,
                ),
                TextFormField(
                  controller: controller.nameController,
                  decoration:
                      InputDecoration(hintText: translation(context).name),
                ),
                addVerticalSpace(15),
                AppTextWidget(
                  text: "${translation(context).mobilenumber} :",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  textColor: AppColor.lableColor,
                ),
                TextFormField(
                  controller: controller.mailController,
                  decoration: InputDecoration(
                      hintText: translation(context).mobilenumber),
                  keyboardType: TextInputType.phone,
                ),
                addVerticalSpace(50),
                AppButton(
                    onPressed: () {
                      controller.updateProfile();
                    },
                    buttonText: translation(context).editprofile)
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<T?> imagePickerDialog<T>(BuildContext context) async {
    Get.bottomSheet(
        backgroundColor: AppColor.white,
        Container(
          height: Get.height * 0.15,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: AppTextWidget(
                  text: translation(context).camera,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                onTap: () {
                  controller.selectImageFromCamera(ImageSource.camera);
                },
              ),
              const Divider(
                height: 0,
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: AppTextWidget(
                  text: translation(context).gallery,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                onTap: () {
                  controller.selectImageFromCamera(ImageSource.gallery);
                },
              ),
            ],
          ),
        ));
    return null;
  }
}
