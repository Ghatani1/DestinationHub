import 'package:destination/categories/buildpage.dart';
import 'package:destination/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPages extends StatefulWidget {
  const IntroPages({super.key});

  @override
  State<IntroPages> createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  final PageController controller = PageController();
  bool islastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom: 150),
          child: PageView(
            scrollDirection: Axis.horizontal,
            controller: controller,
            onPageChanged: (index) {
              setState(() => islastPage = index == 2);
            },
            // Added the controller here
            children: const [
              BuildPage(
                  // color: Colors.blue.shade200,
                  imageUrl: 'images/buddha.png',
                  // imagePng: 'images/Stupa.png',
                  title: 'Search',
                  subtitle:
                      'All You need is the plan, the road map, and the courage to press on to your destination'),
              BuildPage(
                  // color: Colors.red.shade200,
                  imageUrl: 'images/9.png',
                  // imagePng: 'images/9.png',
                  title: 'Select',
                  subtitle:
                      "Life's all about choices. Everyone's destination is the same; only the paths are different"),
              BuildPage(
                  // color: Colors.teal.shade200,
                  imageUrl: 'images/Stupa.png',
                  // imagePng: 'images/mountain.png',
                  title: 'Visit',
                  subtitle: 'Not all those wonder are lost.')
            ],
          ),
        ),
        bottomSheet: islastPage
            ? Container(
                color: kWhite,
                height: 170,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  backgroundColor: kSecondary,
                                  foregroundColor: kWhite,
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                Navigator.pushNamed(context, '/Login');
                              },
                              child: const Text('Login'))),
                      const SizedBox(height: 30),
                      Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  backgroundColor: kSecondary,
                                  foregroundColor: kWhite,
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                Navigator.pushNamed(context, '/Register');
                              },
                              child: const Text('Register'))),
                    ],
                  ),
                ),
              )
            : Container(
                decoration: const BoxDecoration(color: kWhite),
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        axisDirection: Axis.horizontal,
                        effect: const SlideEffect(
                          spacing: 10.0,
                          radius: 4.0,
                          dotWidth: 14.0,
                          dotHeight: 12.0,
                          paintStyle: PaintingStyle.stroke,
                          strokeWidth: 1.5,
                          dotColor: Colors.blueGrey,
                          activeDotColor: kPrimary,
                        ),
                        onDotClicked: (index) => controller.animateToPage(index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInBack),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.jumpToPage(2);
                            },
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.nextPage(
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.slowMiddle);
                            },
                            icon: const Icon(Icons.arrow_circle_right),
                            iconSize: 50,
                            color: kSecondary,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
