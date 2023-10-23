import 'package:flutter/material.dart';

class GradientCircleImage extends StatelessWidget {
  final ImageProvider image;
  final List<Color> gradientColors;

  const GradientCircleImage({
    super.key,
    required this.image,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.transparent, // Set the border color to transparent
              width: 5.0, // Set the border width
            ),
            gradient: SweepGradient(
              colors: gradientColors,
              stops: const [
                0.0,
                0.3,
                0.6,
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.transparent, // Set the border color to transparent
              width: 1.0, // Set the border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0), // Adjust padding as needed
            child: Image(
              //radius: 15.0, // Adjust the radius as needed
              image: image,
            ),
          ),
        ),
      ],
    );
  }
}
