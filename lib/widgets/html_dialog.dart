import 'package:flutter/material.dart';
import 'package:quickresponse/utils/extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/density.dart';

enum PageTitle { privacyPolicy, termsAndConditions }

class HTMLDialog extends StatefulWidget {
  final String htmlAsset1;
  final String htmlAsset2;

  const HTMLDialog({
    Key? key,
    required this.htmlAsset1,
    required this.htmlAsset2,
  }) : super(key: key);

  @override
  _HTMLDialogState createState() => _HTMLDialogState();
}

class _HTMLDialogState extends State<HTMLDialog> {
  late WebViewController _controller;
  bool showHtml1 = true;
  PageTitle dialogTitle = PageTitle.privacyPolicy; // Initialize the title to Privacy Policy

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
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
            /*if (request.url.startsWith('https://')) {
              return NavigationDecision.prevent;
            }*/
            return NavigationDecision.prevent;
          },
          onUrlChange: (a) {
            _controller.reload();
          },
        ),
      )
      ..clearCache();
    /*..createHandler(WebViewHandler(
        allowTextSelection: false, // Prevent text selection
        customScrollBar: CustomScrollBar( // Customize the scrollbar
          backgroundColor: Colors.grey[200],
          width: 6.0,
          isAlwaysShown: true,
          radius: Radius.circular(3),
          color: Colors.blue,
        ),
      ));*/
    loadHtml(widget.htmlAsset1);
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  void loadHtml(String htmlAsset) {
    setState(() {
      showHtml1 = htmlAsset == widget.htmlAsset1;
      dialogTitle = showHtml1 ? PageTitle.privacyPolicy : PageTitle.termsAndConditions;
    });

    _controller.loadFlutterAsset(htmlAsset);
  }

  void toggleHtml() {
    if (showHtml1) {
      loadHtml(widget.htmlAsset2);
    } else {
      loadHtml(widget.htmlAsset1);
    }
  }

  @override
  Widget build(BuildContext context) {
    Density dp = Density.init(context);
    return WillPopScope(
      onWillPop: () async {
        // Prevent the dialog from closing on outside click
        return false;
      },
      child: Dialog(
        // Use Dialog instead of AlertDialog
        insetPadding: const EdgeInsets.symmetric(horizontal: 24), // Adjust the horizontal padding
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text("QR - $_getTitleString", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
            ),
            Container(
              height: 0.7.dpH(dp),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: WebViewWidget(controller: _controller),
            ),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SizedBox(
                width: 120, // Adjust the width as needed
                child: ElevatedButton(
                  onPressed: toggleHtml,
                  child: Text(_getOtherPageTitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(
                // Fixed width button
                width: 120, // Adjust the width as needed
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close", style: TextStyle(fontSize: 16)),
                ),
              ),
            ]),
            const SizedBox(height: 5)
          ]),
        ),
      ),
    );
  }

  String get _getTitleString => switch (dialogTitle) {
        PageTitle.privacyPolicy => "Privacy Policy",
        PageTitle.termsAndConditions => "Terms & Conditions",
      };

  String get _getOtherPageTitle => showHtml1 ? "Terms & Conditions" : "Privacy Policy";
}
