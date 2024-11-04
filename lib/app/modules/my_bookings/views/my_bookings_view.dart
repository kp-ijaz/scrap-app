import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrap_app/app/modules/my_bookings/bindings/my_bookings_binding.dart';
import 'package:scrap_app/app/modules/my_bookings/views/booking_details_view.dart';
import 'package:scrap_app/app/utils/app_colors.dart';
import 'package:scrap_app/app/utils/constant_variable.dart';
import 'package:scrap_app/app/widget/app_text_widget.dart';
import 'package:scrap_app/app/widget/common_app_bar.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:scrap_app/models/orders.dart';
import '../controllers/my_bookings_controller.dart';

class MyBookingsView extends GetView<MyBookingsController> {
  const MyBookingsView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.fetchBooking();
    return Scaffold(
      appBar: RoundedAppBar(
          title: translation(context).mybookings, isBackButtonHide: true),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              indicatorColor: AppColor.primaryColor,
              tabs: [
                Tab(text: translation(context).ongoingbooking),
                Tab(text: translation(context).completedbooking),
              ],
            ),
            GetBuilder<MyBookingsController>(
              builder: (cont) {
                return Expanded(
                  child: Obx(() {
                    if (cont.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return TabBarView(
                      children: [
                        _buildOrderList(
                          cont.orders
                              .where((element) => element.status == 'new')
                              .toList(),
                          false,
                        ),
                        _buildOrderList(
                          cont.orders
                              .where((element) => element.status == 'completed')
                              .toList(),
                          true,
                        ),
                      ],
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Orders> orders, bool isCompleted) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: orders.isNotEmpty
          ? ListView.separated(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return BookingCardWidget(
                  index: index,
                  order: order,
                  progress: isCompleted ? 1 : 0.2,
                  onTap: () {
                    Get.to(
                      () => BookingDetailView(
                        order: order,
                        isCompletedTab: isCompleted,
                      ),
                      binding: MyBookingsBinding(),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => addVerticalSpace(0),
            )
          : Center(
              child: Text(
                translation(Get.context!).emptyoreder,
                style: const TextStyle(fontSize: 24),
              ),
            ),
    );
  }

  Future<void> _handleRefresh() async {
    await controller.refetchBooking();
  }
}

class BookingCardWidget extends StatelessWidget {
  const BookingCardWidget({
    super.key,
    required this.index,
    this.progress,
    required this.onTap,
    required this.order,
  });

  final int index;
  final double? progress;
  final VoidCallback onTap;
  final Orders order;

  @override
  Widget build(BuildContext context) {
    // Convert order.date from String to DateTime
    DateTime orderDate;
    try {
      // Assuming order.date is a string in ISO 8601 format, adjust as needed
      orderDate = DateTime.parse(order.date);
    } catch (e) {
      // Handle parsing error, fallback to current date
      orderDate = DateTime.now();
      log('Date parsing error: $e');
    }

    // Format the date to dd/MM/yyyy
    String formattedDate = DateFormat('dd/MM/yyyy').format(orderDate);

    return Container(
      padding: const EdgeInsets.only(left: 12, top: 10, right: 12, bottom: 0),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: AppColor.greyColor.withOpacity(0.3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget(
            text: "${translation(context).order} ${order.id.substring(0, 6)}",
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          addVerticalSpace(15),
          AppTextWidget(
            text: "${translation(context).address} : ${order.address}",
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          Baseline(
            baseline: 40,
            baselineType: TextBaseline.alphabetic,
            child: Slider(value: progress ?? 0, onChanged: (val) {}),
          ),
          AppTextWidget(
            text: "${translation(context).date} : $formattedDate",
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          addVerticalSpace(15),
          const Divider(
            height: 0,
          ),
          TextButton(
            onPressed: onTap,
            child: AppTextWidget(
              text: translation(context).viewdetails,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
