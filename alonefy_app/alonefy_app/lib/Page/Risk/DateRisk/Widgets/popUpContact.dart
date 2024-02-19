import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Model/activityDay.dart';

import 'package:flutter/material.dart';

class PopUpContact extends StatefulWidget {
  const PopUpContact(
      {super.key, required this.onChanged, required this.listcontact});
  final List<Contact> listcontact;

  final ValueChanged<int> onChanged;

  @override
  State<PopUpContact> createState() => _PopUpContactState();
}

class _PopUpContactState extends State<PopUpContact> {
  late Contact contactSelect;
  int indexSelect = -1;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0, left: 8, right: 8),
      child: ListView.separated(
        shrinkWrap: false,
        itemCount: widget.listcontact.length,
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              contactSelect = widget.listcontact[index];
              indexSelect = index;
              widget.onChanged(indexSelect);
              Navigator.pop(context);
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(60),
                borderRadius: const BorderRadius.all(Radius.circular(79.0)),
              ),
              width: 300,
              height: 80,
              child: Stack(
                children: [
                  Container(
                    width: 79,
                    height: 79,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(79.0)),
                      border: Border.all(color: Colors.blueAccent),
                      image: DecorationImage(
                        image: (widget.listcontact[index].photo == null)
                            ? const AssetImage("assets/images/icons8.png")
                            : Image.memory(
                                widget.listcontact[index].photo!,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100.0,
                              ).image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 90.0),
                    child: Container(
                      color: Colors.transparent,
                      height: 79,
                      width: 220,
                      child: Center(
                        child: Text(
                          widget.listcontact[index].displayName.toString(),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.barlow(
                            fontSize: 18.0,
                            wordSpacing: 1,
                            letterSpacing: 1,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
