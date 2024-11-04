import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/modules/home/controllers/home_controller.dart';
import 'package:scrap_app/app/utils/app_colors.dart';
import 'package:scrap_app/app/utils/constant_variable.dart';
import 'package:scrap_app/app/widget/app_text_widget.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:scrap_app/models/items.dart';

class SelectScrapStep extends GetView<HomeController> {
  const SelectScrapStep({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ct) {
      if (controller.items.isEmpty) {
        controller.fetchItemsByCategory();
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.044,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.getScrapCatList(context).length,
                itemBuilder: (ctx, i) {
                  return InkWell(
                    onTap: () {
                      controller.selectedCat.value = i;
                      controller.fetchItemsByCategory();
                      controller.update();
                    },
                    child: Container(
                      width: Get.width * 0.29,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: controller.selectedCat.value == i
                            ? AppColor.primaryColor
                            : Colors.white,
                        border: Border.all(color: AppColor.primaryColor),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            controller.getScrapCatList(context)[i].image ?? "",
                            height: 15,
                          ),
                          addHorizontalySpace(7),
                          AppTextWidget(
                            text:
                                controller.getScrapCatList(context)[i].title ??
                                    "",
                            textColor: controller.selectedCat.value == i
                                ? Colors.white
                                : AppColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            addVerticalSpace(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                addHorizontalySpace(10),
                AppTextWidget(
                  text: translation(context).items,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
                addHorizontalySpace(Get.width * 0.2),
                const Spacer(),
                AppTextWidget(text: translation(context).price),
                const Spacer(),
                AppTextWidget(text: translation(context).checkbox),
              ],
            ),
            addVerticalSpace(10),
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  Items product = controller.items[index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          product.selected = !product.selected;
                          controller.toggleItemSelection(product);
                        },
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.boxColor),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(product.imageUrl),
                                backgroundColor: Colors.white,
                                radius: 25,
                              ),
                            ),
                            addHorizontalySpace(10),
                            SizedBox(
                              width: width(context) * .32,
                              child: AppTextWidget(
                                text: product.name,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            AppTextWidget(
                              text: "${product.price} Rs /Kg",
                              textColor: AppColor.successColor,
                            ),
                            const Spacer(),
                            Icon(
                              product.selected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: product.selected
                                  ? AppColor.primaryColor
                                  : AppColor.textColor,
                            ),
                          ],
                        ),
                      ),
                      addVerticalSpace(15),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
