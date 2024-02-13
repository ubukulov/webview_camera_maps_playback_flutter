import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Browser App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BrowserPage(),
    );
  }
}

class BrowserPage extends StatefulWidget {
  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  late WebViewController _webViewController;
  TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 145.0,
        title: TextField(
          controller: _urlController,
          decoration: const InputDecoration(
            isDense: true,
            hintText: 'Введите адрес',
            border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                )
            )
          ),
          onSubmitted: (value) {
            _webViewController.loadRequest(Uri.parse(value));
          },
        ),
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () async {
                if (await _webViewController.canGoBack()) {
                  _webViewController.goBack();
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              color: Colors.black,
              onPressed: () async {
                if (await _webViewController.canGoForward()) {
                  _webViewController.goForward();
                }
              },
            ),
            IconButton(
              color: Colors.black,
              icon: Icon(_isLoading ? Icons.stop : Icons.refresh),
              onPressed: () {
                if (_isLoading) {
                  // _webViewController.stopLoading();
                } else {
                  _webViewController.reload();
                }
              },
            ),
          ],
        ),
      ),
      body: WebViewWidget(controller: _webViewController),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}