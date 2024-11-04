import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageBanner extends StatefulWidget {
  const ImageBanner({super.key});

  @override
  _ImageBannerState createState() => _ImageBannerState();
}

class _ImageBannerState extends State<ImageBanner> {
  final List<String> _imagePaths = [
    "assets/images/banner1.png",
    "assets/images/banner2.png",
  ];

  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % _imagePaths.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.2,
      width: Get.width,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _imagePaths.length,
            pageSnapping: true,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      width: 0.05, color: const Color.fromARGB(181, 0, 0, 0)),
                  image: DecorationImage(
                    image: AssetImage(_imagePaths[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
