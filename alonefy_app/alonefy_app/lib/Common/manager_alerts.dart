import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Services/mainService.dart';
import 'package:permission_handler/permission_handler.dart';

class ManagerAlert {}

void showPermissionDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Abrir permisos"),
        content: Text(
          message,
          style: textBold16Black(),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Cerrar", style: textBold16Black()),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Abrir", style: textBold16Black()),
            onPressed: () => openAppSettings(),
          )
        ],
      );
    },
  );
}

void showAlertDialog(String message, List<String> listid) async {
  await showDialog(
    context: RedirectViewNotifier.storedContext!,
    builder: (context) {
      return AlertDialog(
        title: const Text("Información"),
        content: const Text(Constant.notAccion),
        actions: <Widget>[
          TextButton(
            child: Text("NO", style: textBold16Black()),
            onPressed: () => {
              Navigator.of(context).pop(),
              MainService().cancelAllNotifications(listid)
            },
          ),
          TextButton(
            child: Text("SI", style: textBold16Black()),
            onPressed: () => {
              MainService().sendAlertToContactImmediately(listid),
              Navigator.of(context).pop(),
            },
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
              child: Text("No", style: textBold16Black()),
              onPressed: () {
                response(false);
                Navigator.of(context).pop();
              }),
          TextButton(
            child: Text("Sí", style: textBold16Black()),
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
              child: Text("OK", style: textBold16Black()),
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
              onPressed: onChanged,
              child: Text("OK", style: textBold16Black()),
            )
          ],
        );
      });
}
