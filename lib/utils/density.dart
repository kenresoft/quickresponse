part of '../data/constants/styles.dart';

class Density {
  Density.init(BuildContext context)
      : height = MediaQuery.of(context).size.height,
        width = MediaQuery.of(context).size.width,
        aspectRatio = MediaQuery.of(context).size.aspectRatio;

  final double height;
  final double width;
  final double aspectRatio;
}
