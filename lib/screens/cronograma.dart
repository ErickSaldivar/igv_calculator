import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Cronograma extends StatelessWidget {
  const Cronograma({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: WebViewController()
        ..setJavaScriptMode(JavaScriptMode.disabled)
        ..loadRequest(
          Uri.parse(
            'https://www.sunat.gob.pe/orientacion/cronogramas/2026/cObligacionMensual2026.html',
          ),
        ),
    );
  }
}
