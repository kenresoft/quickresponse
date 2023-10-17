import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/utils/extensions.dart';

import '../../data/constants/styles.dart';
import '../../providers/settings/prefs.dart';
import 'outlined_fab.dart';

class CustomFAB extends ConsumerStatefulWidget {
  const CustomFAB(this.theme, {super.key, required this.onPressed1, required this.onPressed2});

  final bool theme;
  final Function() onPressed1;
  final Function() onPressed2;

  @override
  ConsumerState<CustomFAB> createState() => _CustomFABState();
}

class _CustomFABState extends ConsumerState<CustomFAB> {
  bool isExpanded = false;
  bool isButtonVisible = true;

  void toggleVisibility() {
    setState(() {
      isButtonVisible = !isButtonVisible;
    });

    // Delay for 2 seconds and then show the button again
    Future.delayed(const Duration(milliseconds: 4500), () {
      setState(() {
        isButtonVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    //final theme = ref.watch(themeProvider.select((value) => value));
    return Stack(children: [
      Positioned(
        bottom: 16.0,
        right: 16.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Action 1
                    buildRow(
                      dp: dp,
                      label: 'Export',
                      iconData: CupertinoIcons.cloud_upload,
                      onPressed: () {
                        widget.onPressed1();
                        toggleVisibility();
                      },
                    ),
                    // Action 2
                    buildRow(
                      dp: dp,
                      label: 'Import',
                      iconData: CupertinoIcons.cloud_download,
                      onPressed: () {
                        widget.onPressed2();
                        toggleVisibility();
                      },
                    ),
                  ],
                ),
              ),
            if (isButtonVisible)
              OutlinedFab(
                theme,
                isExpanded: isExpanded,
                onPressed: () => setState(() => isExpanded = !isExpanded),
                child: isExpanded ? const Icon(Icons.close) : const Icon(Icons.cloud_sync), // Replace with your child widget
              )
          ],
        ),
      ),
    ]);
  }

  Widget buildRow({
    String label = 'Add New',
    IconData iconData = Icons.add,
    required Function() onPressed,
    required Density dp,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: 0.25.dpW(dp),
      height: 35,
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: AppColor(theme).alertTransparent,
        elevation: 0,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          onPressed();
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Row(children: [
          Icon(iconData, size: 18),
          const SizedBox(width: 1),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              softWrap: true, // Allow text to wrap to a new line if it overflows
            ),
          ),
        ]),
      ),
    );
  }
}
