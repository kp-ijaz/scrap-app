import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrap_app/app/modules/my_bookings/controllers/my_bookings_controller.dart';
import 'package:scrap_app/app/widget/app_text_field.dart';
import 'package:scrap_app/app/widget/app_text_widget.dart';
import 'package:scrap_app/app/widget/common_app_bar.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:scrap_app/models/orders.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/constant_variable.dart';

class BookingDetailView extends GetView<MyBookingsController> {
  const BookingDetailView(
      {super.key, this.isCompletedTab = false, required this.order});
  final bool isCompletedTab;
  final Orders order;

  @override
  Widget build(BuildContext context) {
    // Assuming order.date is a string in ISO 8601 format or another string format
    DateTime orderDate;
    try {
      // Parse the date string to a DateTime object
      orderDate = DateTime.parse(order.date);
    } catch (e) {
      // Handle parsing error
      orderDate =
          DateTime.now(); // Fallback to current date or handle as needed
      log('Date parsing error: $e');
    }

    // Format the date in dd/MM/yyyy
    String formattedDate = DateFormat('dd/MM/yyyy').format(orderDate);

    return Scaffold(
      appBar: CommonAppBar(
        title: translation(context).booking,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  addHorizontalySpace(10),
                  AppTextWidget(
                    text: translation(context).items,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  const Spacer(),
                  AppTextWidget(text: translation(context).price),
                  addHorizontalySpace(10)
                ],
              ),
              addVerticalSpace(10),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.boxColor),
                                  borderRadius: BorderRadius.circular(50)),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 25,
                                child: Image.network(
                                  order.items[index].imageUrl,
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                            ),
                            addHorizontalySpace(10),
                            Expanded(
                              child: AppTextWidget(
                                text: order.items[index].name,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            AppTextWidget(
                              text: "${order.items[index].price} Rs /Kg",
                              textColor: AppColor.successColor,
                            ),
                            addHorizontalySpace(10)
                          ],
                        ),
                        addVerticalSpace(15)
                      ],
                    );
                  }),
              addVerticalSpace(6),
              AppTextWidget(
                text: translation(context).location,
                textColor: AppColor.greyColor,
              ),
              addVerticalSpace(7),
              AppTextFormField(
                initialValue: order.address,
                hintText: translation(context).placehint,
                readOnly: true,
              ),
              addVerticalSpace(8),
              AppTextWidget(
                text: translation(context).date,
                textColor: AppColor.greyColor,
              ),
              addVerticalSpace(7),
              AppTextFormField(
                hintText: "dd/MM/yyyy",
                readOnly: true,
                initialValue: formattedDate, // Use the formatted date
              ),
              addVerticalSpace(8),
              AppTextWidget(
                text: translation(context).weight,
                textColor: AppColor.greyColor,
              ),
              addVerticalSpace(7),
              AppTextFormField(
                hintText: "10 KG",
                readOnly: true,
                initialValue: order.weight,
              ),
              if (isCompletedTab)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addVerticalSpace(8),
                    AppTextWidget(
                      text: translation(context).amount,
                      textColor: AppColor.greyColor,
                    ),
                    addVerticalSpace(7),
                    AppTextFormField(
                      hintText: "100 Rs",
                      readOnly: true,
                      initialValue: order.amount,
                    ),
                    addVerticalSpace(8),
                    AppTextWidget(
                      text: translation(context).paymentmethod,
                      textColor: AppColor.greyColor,
                    ),
                    addVerticalSpace(7),
                    AppTextFormField(
                      hintText: "Cash",
                      readOnly: true,
                      initialValue: order.paymentMode,
                    ),
                  ],
                ),
              addVerticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}
