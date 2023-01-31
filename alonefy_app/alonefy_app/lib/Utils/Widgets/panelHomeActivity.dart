import 'package:flutter/material.dart';

class PanelHomeActivity extends StatefulWidget {
  const PanelHomeActivity({super.key});

  @override
  State<PanelHomeActivity> createState() => _PanelHomeActivityState();
}

class _PanelHomeActivityState extends State<PanelHomeActivity> {
  var position = -20.0;
  int selectOption = 0;
  var isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: Center(
          child: AnimatedContainer(
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            width: 350,
            height: 190,
            alignment: AlignmentDirectional.topCenter,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            child: Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                height: 300,
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 20,
                        color: Colors.white,
                        padding: const EdgeInsets.only(left: 0.0, right: 0),
                        child: isOpen == true
                            ? const Icon(Icons.arrow_upward)
                            : const Icon(Icons.arrow_downward),
                      ),
                      onTap: () {
                        setState(() {
                          if (position == 0) {
                            isOpen = true;
                            position = -170;
                          } else {
                            isOpen = false;
                            position = 0;
                          }
                        });
                      },
                    ),
                    Container(
                      color: Colors.amber,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
