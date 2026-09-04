import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Cronograma extends StatefulWidget {
  const Cronograma({super.key});

  @override
  State<Cronograma> createState() => _CronogramaState();
}

class _CronogramaState extends State<Cronograma> {
  late final WebViewController _controller;
  int _loadingProgress = 0;
  bool _hasError = false;

  final String _url =
      'https://www.sunat.gob.pe/orientacion/cronogramas/2026/cObligacionMensual2026.html';

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  void _initWebViewController() {
    _hasError = false;
    _loadingProgress = 0;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress;
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _hasError = false;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _loadingProgress = 100;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Cronograma WebView error: ${error.description}');
            if (mounted && error.isForMainFrame == true) {
              setState(() {
                _hasError = true;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(_url));
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 64,
                color: Color(0xFF081034),
              ),
              const SizedBox(height: 16),
              const Text(
                'No se pudo cargar el cronograma de SUNAT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Verifique su conexión a Internet e intente nuevamente.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _initWebViewController();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_loadingProgress < 100)
          LinearProgressIndicator(
            value: _loadingProgress / 100.0,
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF081034)),
          ),
      ],
    );
  }
}
