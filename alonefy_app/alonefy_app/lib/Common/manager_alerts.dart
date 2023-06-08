import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ManagerAlert {}

void showPermissionDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Abrir permisos"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text("Cerrar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Abrir"),
            onPressed: () => openAppSettings(),
          )
        ],
      );
    },
  );
}

void showLocalPermissionDialog(
    BuildContext context, String message, Function(bool) response) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Permitir permiso"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
              child: const Text("No"),
              onPressed: () {
                response(false);
                Navigator.of(context).pop();
              }),
          TextButton(
            child: const Text("Sí"),
            onPressed: () {
              response(true);
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

void showSaveAlert(BuildContext context, String title, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("Ok"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

Future<void> showSaveAlertWithAction(BuildContext context, String title,
    String message, Function()? onChanged) async {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("Ok"),
              onPressed: onChanged,
            )
          ],
        );
      });
}
