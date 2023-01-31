import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Views/alternative_page.dart';

import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage extends StatelessWidget {
  final _controller = PageController(
    initialPage: 0,
  );

  OnboardingPage({super.key});

  final onboardingPagesList = [
    PageModel(
      widget: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            'assets/images/Mapsicle Map-2.png',
            width: double.infinity,
          ),
          SizedBox(
              width: double.infinity,
              child: Text(Constant.onBoardingWelcome,
                  style: GoogleFonts.barlow())),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              Constant.onBoardingWelcomeMessage,
              style: GoogleFonts.barlow(),
            ),
          ),
        ],
      ),
    ),
    PageModel(
      widget: Column(
        children: [
          Image.asset('assets/images/Mapsicle Map.png', color: pageImageColor),
          const SizedBox(
            height: 10,
          ),
          const Text(Constant.onBoardingPageTwoTitle, style: pageTitleStyle),
          const SizedBox(
            height: 20,
          ),
          const Text(
            Constant.onBoardingPageTwoSubtitle,
            style: pageInfoStyle,
          )
        ],
      ),
    ),
    PageModel(
      widget: Column(
        children: [
          Image.asset(
            'assets/images/Mapsicle Map-3.png',
            color: Colors.white,
            width: 200,
            height: 200,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(Constant.onBoardingPageTreeTitle, style: pageTitleStyle),
          const SizedBox(
            height: 20,
          ),
          const Text(
            Constant.onBoardingPageTreeSubtitle,
            style: pageInfoStyle,
          )
        ],
      ),
    ),
    PageModel(
      widget: Column(
        children: [
          Image.asset('assets/images/Mapsicle Map-4.png',
              color: pageImageColor),
          const SizedBox(
            height: 10,
          ),
          const Text(Constant.onBoardingPageFourTitle, style: pageTitleStyle),
          const SizedBox(
            height: 10,
          ),
          const Text(
            Constant.onBoardingPageFourSubtitle,
            style: pageInfoStyle,
          ),
        ],
      ),
    ),
  ];
// the index of the current page
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment(0, 1),
            colors: <Color>[
              Color.fromRGBO(21, 14, 3, 1),
              Color.fromRGBO(115, 75, 24, 1),
            ], // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
        ),
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
                                    ? Colors.amber
                                    : Colors.grey,
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
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                    ),
                    child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(219, 177, 42, 1),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        height: 42,
                        width: 200,
                        child: const Center(child: Text(Constant.continueTxt))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AlternativePage()),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createButtonNext(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
        const Color.fromRGBO(219, 177, 42, 1),
      )),
      label: const Text(Constant.continueTxt),
      icon: const Icon(
        Icons.next_plan,
      ),
      onPressed: (() async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AlternativePage()),
        );
      }),
    );
  }
}

class MyPage1Widget extends StatelessWidget {
  const MyPage1Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          child: Image.asset(
            scale: 0.5,
            fit: BoxFit.fill,
            'assets/images/Mask group-2.png',
            height: 430,
            width: double.infinity,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Text(
            Constant.onBoardingWelcome,
            textAlign: TextAlign.center,
            style: GoogleFonts.barlow(
              fontSize: 22.0,
              wordSpacing: 1,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(219, 177, 42, 1),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: Text(
            Constant.onBoardingWelcomeMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.barlow(
              fontSize: 22.0,
              wordSpacing: 1,
              letterSpacing: 1,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class MyPage2Widget extends StatelessWidget {
  const MyPage2Widget({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          child: Image.asset(
            fit: BoxFit.fill,
            scale: 0.5,
            'assets/images/Mask group.png',
            height: 430,
            width: double.infinity,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            width: 350,
            child: Text(
              Constant.onBoardingPageTwoTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.barlow(
                fontSize: 22.0,
                wordSpacing: 1,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(219, 177, 42, 1),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            width: 350,
            child: Text(
              Constant.onBoardingPageTwoSubtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.barlow(
                fontSize: 22.0,
                wordSpacing: 1,
                letterSpacing: 1,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyPage3Widget extends StatelessWidget {
  const MyPage3Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          child: Image.asset(
            fit: BoxFit.fill,
            scale: 0.5,
            'assets/images/Mask group-3.png',
            height: 420,
            width: double.infinity,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            width: 350,
            child: Text(
              Constant.onBoardingPageTreeTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.barlow(
                fontSize: 22.0,
                wordSpacing: 1,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(219, 177, 42, 1),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            width: 350,
            child: Text(
              Constant.onBoardingPageTreeSubtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.barlow(
                fontSize: 22.0,
                wordSpacing: 1,
                letterSpacing: 1,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyPage4Widget extends StatelessWidget {
  const MyPage4Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          child: Image.asset(
            fit: BoxFit.fill,
            scale: 0.5,
            'assets/images/Mask group-4.png',
            height: 400,
            width: double.infinity,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            width: 350,
            child: Text(
              Constant.onBoardingPageFourTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.barlow(
                fontSize: 22.0,
                wordSpacing: 1,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(219, 177, 42, 1),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            width: 350,
            child: Text(
              Constant.onBoardingPageFourSubtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.barlow(
                fontSize: 22.0,
                wordSpacing: 1,
                letterSpacing: 1,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
