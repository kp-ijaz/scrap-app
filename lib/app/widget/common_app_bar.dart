import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/utils/app_colors.dart';
import 'package:scrap_app/app/utils/constant_variable.dart';
import 'package:scrap_app/app/widget/app_text_widget.dart';

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonHide;

  const RoundedAppBar({super.key, this.title, this.isBackButtonHide = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.13,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
        color: AppColor.primaryColor,
      ),
      child: AppBar(
        leading:
            isBackButtonHide ? const SizedBox.shrink() : const BackButton(),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: title != null
            ? Text(title!)
            : const AppTextWidget(
                text: "",
                textColor: Colors.white,
              ),
        centerTitle: false,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 30);
}

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    required this.title,
    required IconButton leading,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AppTextWidget(
        text: title,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          addHorizontalySpace(20),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColor.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
