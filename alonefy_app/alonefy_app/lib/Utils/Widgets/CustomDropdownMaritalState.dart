import 'package:ifeelefine/Model/restday.dart';
import 'package:flutter/material.dart';

class CustomDropdownMaritalState extends StatefulWidget {
  const CustomDropdownMaritalState(
      {Key? key,
      required this.instance,
      required this.mensaje,
      required this.isVisible,
      required this.onChanged})
      : super(key: key);

  final bool isVisible;
  final ValueChanged<String> onChanged;
  final Map<String, String> instance;
  final String mensaje;
  @override
  // ignore: library_private_types_in_public_api
  _CustomDropdownMaritalStateState createState() =>
      _CustomDropdownMaritalStateState();
}

class _CustomDropdownMaritalStateState
    extends State<CustomDropdownMaritalState> {
  late int _indexList;

  var _selectedLocation = '';

  void _selectOption(String value) {
    setState(() {
      widget.onChanged(value);
    });
  }

  @override
  void initState() {
    _indexList = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.yellow,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: SizedBox(
          height: 52,
          child: DropdownButton<String?>(
            underline: Container(),
            hint: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.mensaje,
                style: const TextStyle(fontSize: 18, color: Colors.yellow),
              ),
            ),
            dropdownColor: Colors.brown,
            iconEnabledColor: Colors.yellow, //Ico
            value: _selectedLocation.isEmpty
                ? widget.instance[_indexList]
                : _selectedLocation,
            isExpanded: true,
            items: widget.instance.keys
                .toList()
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: widget.instance[e],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.instance[e] ?? "",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.yellow),
                      ),
                    ),
                  ),
                )
                .toList(),

            onChanged: (v) {
              setState(() {
                _selectedLocation = v.toString();
                widget.onChanged(_selectedLocation);
              });
            },
          ),
        ),
      ),
    );
  }
}
