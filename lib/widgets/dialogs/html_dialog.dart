import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/utils/extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/constants/styles.dart';
import '../../providers/settings/prefs.dart';

enum PageTitle { privacyPolicy, termsAndConditions }

class HTMLDialog extends ConsumerStatefulWidget {
  final String htmlAsset1;
  final String htmlAsset2;

  const HTMLDialog({
    Key? key,
    required this.htmlAsset1,
    required this.htmlAsset2,
  }) : super(key: key);

  @override
  ConsumerState<HTMLDialog> createState() => _HTMLDialogState();
}

class _HTMLDialogState extends ConsumerState<HTMLDialog> {
  late WebViewController _controller;
  bool showHtml1 = true;
  PageTitle dialogTitle = PageTitle.privacyPolicy; // Initialize the title to Privacy Policy

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.prevent;
          },
        ),
      );
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
        surfaceTintColor: Colors.transparent,
        backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: WebViewWidget(
                  controller: _controller..setBackgroundColor(theme ? AppColor(theme).white : AppColor(theme).black),
                ),
              ),
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
