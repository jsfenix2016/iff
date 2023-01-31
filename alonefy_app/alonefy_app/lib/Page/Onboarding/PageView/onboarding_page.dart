import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Page/Alternative/Pageview/alternative_page.dart';

import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/Onboarding/Widget/widgetColumnOnboarding.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

class OnboardingPage extends StatelessWidget {
  final _controller = PageController(
    initialPage: 0,
  );

  OnboardingPage({super.key});

  int _activePage = 0;

  // this list holds all the pages
  // all of them are constructed in the very end of this file for readability
  final List<Widget> _pages = [
    const MyPage1Widget(),
    const MyPage2Widget(),
    const MyPage3Widget(),
    const MyPage4Widget(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: decorationCustom(),
        child: Stack(
          children: [
            // the page view
            PageView.builder(
              controller: _controller,
              onPageChanged: (int page) {
                _activePage = page;
                (context as Element).markNeedsBuild();
              },
              itemCount: _pages.length,
              itemBuilder: (BuildContext context, int index) {
                return _pages[index % _pages.length];
              },
            ),
            // Display the dots indicator
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              height: 20,
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                      _pages.length,
                      (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: InkWell(
                              onTap: () {
                                _controller.animateToPage(index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              child: CircleAvatar(
                                radius: 8,
                                // check if a dot is connected to the current page
                                // if true, give it a different color
                                backgroundColor: _activePage == index
                                    ? ColorPalette.principal
                                    : ColorPalette.dotbackground,
                              ),
                            ),
                          )),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              height: 50,
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: ElevateButtonFilling(
                    onChanged: (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AlternativePage(),
                        ),
                      );
                    },
                    mensaje: Constant.continueTxt,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPage1Widget extends StatelessWidget {
  const MyPage1Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return const WidgetColumnOnboarding(
      img: 'assets/images/Mask group-2.png',
      title: Constant.onBoardingWelcome,
      subtitle: Constant.onBoardingWelcomeMessage,
    );
  }
}

class MyPage2Widget extends StatelessWidget {
  const MyPage2Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return const WidgetColumnOnboarding(
      img: 'assets/images/Mask group.png',
      title: Constant.onBoardingPageTwoTitle,
      subtitle: Constant.onBoardingPageTwoSubtitle,
    );
  }
}

class MyPage3Widget extends StatelessWidget {
  const MyPage3Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return const WidgetColumnOnboarding(
      img: 'assets/images/Mask group-3.png',
      title: Constant.onBoardingPageTreeTitle,
      subtitle: Constant.onBoardingPageTreeSubtitle,
    );
  }
}

class MyPage4Widget extends StatelessWidget {
  const MyPage4Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return const WidgetColumnOnboarding(
      img: 'assets/images/Mask group-4.png',
      title: Constant.onBoardingPageFourTitle,
      subtitle: Constant.onBoardingPageFourSubtitle,
    );
  }
}
