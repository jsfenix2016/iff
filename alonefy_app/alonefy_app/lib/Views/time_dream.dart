import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Model/restday.dart';
import 'package:flutter/material.dart';
import '../Utils/Widgets/containerSelectTime.dart';

class TimeDream extends StatefulWidget {
  const TimeDream({Key? key, required this.onChanged, required this.heigth})
      : super(key: key);

  final ValueChanged<List<RestDay>> onChanged;
  final double heigth;
  @override
  // ignore: library_private_types_in_public_api
  _TimeDream createState() => _TimeDream();
}

class _TimeDream extends State<TimeDream> {
  void _selectOption(List<RestDay> value) {
    setState(() {
      widget.onChanged(value);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  final List<RestDay> tempDicRest = [];
  final List<int> tempList = <int>[];
  final List<int> tempListConfig = <int>[];
  var indexSelect = -1;

  var expandCell = false;
  var isSelect = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      margin: const EdgeInsets.all(0),
      color: Colors.white,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(8),
          itemCount: Constant.tempListDay.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                indexSelect = index;
                setState(() {
                  if (isSelect == false) {
                    isSelect = true;
                    expandCell = true;
                  } else {
                    isSelect = false;
                    expandCell = false;
                  }
                });
              },
              child: Dismissible(
                background: Container(
                  color: Colors.red,
                  height: 80,
                  width: double.infinity,
                  child: const Center(
                    child: Text(
                      "Delete",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                onDismissed: ((direction) => {setState(() {})}),
                key: UniqueKey(),
                child: Container(
                  color: Colors.white,
                  height: 110,
                  width: 350,
                  margin: const EdgeInsets.all(2),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      width: double.infinity,
                      height: index == indexSelect ? 105 : 60,
                      decoration: BoxDecoration(
                        color: index != indexSelect
                            ? Colors.white38
                            : Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3.0,
                              offset: Offset(0.0, 5.0),
                              spreadRadius: 3.0),
                        ],
                      ),
                      child: index != indexSelect
                          ? Center(
                              child: Text(
                                Constant.tempListDay[index],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            )
                          : ListView(
                              padding: const EdgeInsets.all(3),
                              children: <Widget>[
                                ContainerSelectTime(
                                  day: Constant.tempListDay[index],
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
