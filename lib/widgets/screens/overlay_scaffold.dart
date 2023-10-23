import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/constants/styles.dart';
import '../../providers/settings/prefs.dart';
import '../../utils/wrapper.dart';
import '../inputs/custom_fab.dart';

class ScaffoldX extends ConsumerStatefulWidget {
  ScaffoldX({
    super.key,
    this.backgroundColor,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.focusNode,
    GlobalKey<ScaffoldMessengerState>? sKey,
    this.onPressed1,
    this.onPressed2,
  }) : sKey = sKey ?? GlobalKey<ScaffoldMessengerState>();

  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final FocusNode? focusNode;
  final GlobalKey<ScaffoldMessengerState> sKey;
  final Function()? onPressed1;
  final Function()? onPressed2;

/*  void toast(String message) {
    sKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }*/

  void toast(Object msg, [TextAlign? textAlign, Color? color]) {
    sKey.currentState?.showSnackBar(SnackBar(content: Text(msg.toString(), textAlign: textAlign), backgroundColor: color ?? AppColor(theme).black));
  }

  @override
  ConsumerState<ScaffoldX> createState() => _ScaffoldXState();
}

class _ScaffoldXState extends ConsumerState<ScaffoldX> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldMessengerState> sKey = widget.sKey;

    return Stack(
      children: [
        ScaffoldMessenger(
          key: sKey,
          child: focus(
            widget.focusNode ?? FocusNode(),
            Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: widget.backgroundColor,
              appBar: widget.appBar,
              body: widget.body,
              bottomNavigationBar: widget.bottomNavigationBar,
            ),
          ),
        ),
        CustomFAB(
          theme,
          onPressed1: () => widget.onPressed1!(),
          onPressed2: () => widget.onPressed2!(),
        ),
      ],
    );
  }
}
