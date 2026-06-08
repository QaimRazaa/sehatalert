import 'package:flutter/material.dart';
import '../../../utils/device/responsive_size.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final List<String> bannerImages = ['assets/logo/one.jpg', 'assets/logo/two.jpg', 'assets/logo/three.jpg'];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: ResponsiveSize.h(15),
          child: PageView.builder(
            itemCount: bannerImages.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  bannerImages[index],
                  width: double.infinity,
                  height: ResponsiveSize.h(15),
                  fit: BoxFit.fill,
                ),
              );
            },
          ),
        ),
        SizedBox(height: ResponsiveSize.h(1)),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(bannerImages.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentIndex == index ? Colors.green : Colors.grey[400],
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}
