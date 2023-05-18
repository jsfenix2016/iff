import 'package:grouped_list/grouped_list.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/activityDay.dart';
import 'package:ifeelefine/Model/activitydaybd.dart';
import 'package:ifeelefine/Page/FallDetected/Pageview/fall_activation_page.dart';
import 'package:ifeelefine/Page/UserInactivityPage/Controller/inactivityViewController.dart';
import 'package:ifeelefine/Utils/Widgets/containerTextEditAndTime.dart';
import 'package:collection/collection.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

class PreviewInactivityPage extends StatefulWidget {
  const PreviewInactivityPage({super.key});

  @override
  State<PreviewInactivityPage> createState() => _PreviewInactivityPageState();
}

class _PreviewInactivityPageState extends State<PreviewInactivityPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final InactivityViewController inactVC = Get.put(InactivityViewController());
  List<ActivityDayBD> tempDicRest = [];
  List<ActivityDay> selecDicActivity = <ActivityDay>[];
  List<ActivityDayBD> selecDicActivityTemp = <ActivityDayBD>[];
  Map<String, List<ActivityDayBD>> groupedProducts = {};
  final List<int> tempListConfig = <int>[];
  late ActivityDay temp;
  final List<String> tempListDay = <String>[];
  List<ActivityDayBD> lista = [];
  @override
  void initState() {
    getInactivity();
    super.initState();
  }

  Future<void> getInactivity() async {
    var a = await inactVC.getInactivity();

    print(a);

    groupedProducts = groupBy(a, (product) => product.day);
    groupedProducts.forEach((key, value) {
      selecDicActivityTemp.add(value.first);
    });

    groupedProducts.forEach((key, value) {
      for (int i = 0; i < value.length; i++) {
        lista.add(value[i]);
      }
    });

    setState(() {});
  }

  void _selectOption(ActivityDay value) {
    selecDicActivity.removeAt(value.id);
    selecDicActivity.insert(value.id, value);
    setState(() {});
  }

  Widget _createButtonNext() {
    return ElevateButtonFilling(
      onChanged: (value) async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FallActivationPage()),
        );
      },
      mensaje: Constant.nextTxt,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: _createButtonNext(),
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("Previsualizar actividades"),
      ),
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: GroupedListView<ActivityDayBD, String>(
          elements: lista,
          groupBy: (ActivityDayBD event) => event.day,
          groupSeparatorBuilder: (String day) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(day, style: Theme.of(context).textTheme.headline4),
          ),
          itemBuilder: (BuildContext context, ActivityDayBD event) {
            var select = ActivityDay();
            select.activity = event.activity;
            select.timeStart = event.timeStart;
            select.timeFinish = event.timeFinish;
            select.day = event.day;
            return ContainerTextEditTime(
              day: event.day,
              acti: select,
              onChanged: (value) {
                _selectOption(value);
              },
            );
          },
        ),
      ),
    );
  }
}
