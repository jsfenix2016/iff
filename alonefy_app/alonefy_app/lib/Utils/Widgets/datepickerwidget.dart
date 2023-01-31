import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'DatePicker_controller.dart';

// ignore: must_be_immutable
class Datepickerwidget extends StatelessWidget {
  Datepickerwidget({Key? key, required this.date, required this.onChange})
      : super(key: key);

  final ValueChanged<DateTime> onChange;
  final DateTime date;
  final Datepicker_controller c = Get.put(Datepicker_controller());

  TextEditingController controlador = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controlador.text =
        "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            labelText: "Fecha de nacimiento".tr,
          ),
          readOnly: true,
          controller: controlador,
          onTap: () async {
            DateTime? date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now().add(const Duration(days: 1)));

            if (date != null) {
              c.dateC =
                  "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"
                      .obs;

              controlador.text = c.dateC.string;
              onChange(date);
              (context as Element).markNeedsBuild();
            }
          },
        ),
      ],
    );
  }
}
