import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/Constant.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebViewTermsConditions extends StatefulWidget {
  const WebViewTermsConditions({super.key});

  @override
  State<WebViewTermsConditions> createState() => _WebViewTermsConditionsState();
}

class _WebViewTermsConditionsState extends State<WebViewTermsConditions> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    controller = WebViewController.fromPlatformCreationParams(params);

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            Center(
              child: CircularProgressIndicator(),
            );
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            print("algo");
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(Constant.urlTerms)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(Constant.urlTerms));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Aquí puedes ejecutar acciones personalizadas antes de volver atrás
        // Por ejemplo, mostrar un diálogo de confirmación

        var confirmExit = await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Confirmar'),
            content: const Text('¿Se han leido los terminos y condiciones?'),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(
                    Icons.cancel,
                  ),
                  tooltip: 'Negar',
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                  }),
              IconButton(
                  icon: const Icon(
                    Icons.save,
                  ),
                  tooltip: 'Aceptar',
                  onPressed: () async {
                    // Navigator.of(context).pop(true);
                    Navigator.pop(context, true);
                  }),
            ],
          ),
        );
        Navigator.pop(context, confirmExit);
        return confirmExit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Terminos y condiciones',
          ),
          backgroundColor: const Color.fromARGB(255, 76, 52, 22),
        ),
        body: SafeArea(child: WebViewWidget(controller: controller)),
      ),
    );
  }
}
