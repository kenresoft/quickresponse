import 'package:flutter/material.dart';

import '../data/constants/constants.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  var list = ['Designer', 'Category', 'Attention'];
  var list2 = ['Illustration', 'Interface', 'Web Design', 'Technology'];

  //var list3 = [Constants.profile].multiply(times: 6);
  var list3 = [Constants.tech, Constants.web, Constants.spaceship, Constants.laptop, Constants.www, Constants.moon];
  var colors = [Colors.green.shade300, Colors.blue.shade300, Colors.orange.shade300, Colors.pink.shade300];
  var colors2 = [Colors.purple.shade200, Colors.green.shade200, Colors.orange.shade200, Colors.blue.shade200, Colors.teal.shade200, Colors.red.shade200];

  late AnimationController controller;

  ColorScheme? color;

  Animatable<Color?> anim(List<Color> colors) => TweenSequence<Color?>([
        for (var i = 0; i <= colors.length - 2; ++i) TweenSequenceItem(weight: 1.0, tween: ColorTween(begin: colors[i], end: colors[i + 1])),
      ]);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 10), vsync: this);
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme;

    return Container(
      color: Colors.white,
    );
  }
}
