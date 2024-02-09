import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

import 'package:ifeelefine/Provider/prefencesUser.dart';

class ContainerTopButton extends StatefulWidget {
  const ContainerTopButton(
      {super.key,
      required this.onOpenMenu,
      required this.goToAlert,
      required this.pref,
      required this.isconfig});
  final ValueChanged<bool> onOpenMenu;
  final ValueChanged<bool> goToAlert;
  final PreferenceUser pref;
  final bool isconfig;
  @override
  State<ContainerTopButton> createState() => _ContainerTopButtonState();
}

class _ContainerTopButtonState extends State<ContainerTopButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 230,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 8,
            left: 16,
            child: IconButton(
              iconSize: 40,
              color: ColorPalette.principal,
              onPressed: () {
                setState(() {
                  widget.onOpenMenu(true);
                });
              },
              icon: Container(
                height: 32,
                width: 28,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/ajustes.png'),
                    fit: BoxFit.fill,
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            left: 54,
            top: 18,
            child: Visibility(
              visible: widget.pref.getUserFree || widget.isconfig,
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(
                            20.0) //                 <--- border radius here
                        ),
                    color: Colors.red),
                height: 8,
                width: 8,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 16,
            child: IconButton(
              iconSize: 40,
              color: ColorPalette.principal,
              onPressed: () {
                widget.goToAlert(true);
              },
              icon: Container(
                height: 32,
                width: 28,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Vector.png'),
                    fit: BoxFit.fill,
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 18,
            child: Visibility(
              visible: widget.pref.getNotificationType != "",
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(
                            20.0) //                 <--- border radius here
                        ),
                    color: Colors.red),
                height: 8,
                width: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}