import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/main.dart';

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
            const Center(
              child: CircularProgressIndicator(),
            );
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
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
        starTap();
        var confirmExit = await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(Constant.confirmTitleAlert),
            content: const Text(Constant.alertBody),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Cerrar",
                  style: textNormal16Black(),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  "Aceptar",
                  style: textNormal16Black(),
                ),
                onPressed: () async {
                  // Navigator.of(context).pop(true);
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        );
        Navigator.pop(context, confirmExit);
        return confirmExit;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text(
            Constant.termsAndConditionTitle,
            style: textForTitleApp(),
          ),
        ),
        body: SafeArea(child: WebViewWidget(controller: controller)),
      ),
    );
  }
}
