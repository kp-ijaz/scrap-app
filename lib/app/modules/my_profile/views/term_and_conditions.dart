import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/modules/my_profile/controllers/my_profile_controller.dart';
import 'package:scrap_app/app/widget/common_app_bar.dart';
import 'package:scrap_app/l10n/languagemanager.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyProfileController>();

    controller.fetchTermsAndConditions();

    return Scaffold(
      appBar: CommonAppBar(
        title: translation(context).termsandcondition,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<MyProfileController>(
          builder: (controller) {
            if (controller.termsAndConditions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: HtmlWidget(
                controller.termsAndConditions,
              ),
            );
          },
        ),
      ),
    );
  }
}
