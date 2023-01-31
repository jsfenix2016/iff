import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Model/restday.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Views/time_dream.dart';
import 'package:flutter/material.dart';

class DesactivePage extends StatefulWidget {
  const DesactivePage({super.key});

  @override
  State<DesactivePage> createState() => _DesactivePageState();
}

class _DesactivePageState extends State<DesactivePage> {
  final List<RestDay> tempDicRest = [];
  final List<String> listDisamble = <String>[
    "1 hora",
    "2 horas",
    "3 horas",
    "8 horas",
    "24 horas",
    "1 semana",
    "1 mes",
    "1 año",
    "Siempre",
  ];

  Map<String, bool> permissionStatus = {
    'Camera': false,
    'Location': false,
    'Acceso a mis contacts': false,
    'Permitir uso en segundo plano': false,
    'Permitir notificaciones': false,
    'Compartir mi ubicacion': false,
    'Sonido en silencio': false,
    'Permitir acceso a fotos': false
  };
  String desactiveIFeelFine = "1 hora";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Desactivar IFeelFine'),
        ),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "Permite desactivar la aplicación por un tiempo determinado.",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listDisamble.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: RadioListTile(
                          title: Text(
                            listDisamble[index],
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                          ),
                          value: listDisamble[index],
                          groupValue: desactiveIFeelFine,
                          onChanged: (value) {
                            setState(() {
                              desactiveIFeelFine = value.toString();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              _createButtonNext()
            ],
          ),
        ),
      ),
    );
  }

  Widget _createButtonNext() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
      label: const Text("Guardar"),
      icon: const Icon(
        Icons.save,
      ),
      onPressed: (() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserInactivityPage()),
        );
      }),
    );
  }
}
