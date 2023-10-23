import 'package:carousel_slider/carousel_slider.dart';
import 'package:quickresponse/utils/util.dart';

import '../../main.dart';
import '../display/color_mix.dart';

class TipSlider extends StatefulWidget {
  final List<EmergencyTip> tips;
  final VoidCallback action;

  const TipSlider({super.key, required this.tips, required this.action});

  @override
  State<TipSlider> createState() => _TipSliderState();
}

class _TipSliderState extends State<TipSlider> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: widget.tips.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        EmergencyTip tip = widget.tips[index];
        return GestureDetector(
          onTap: () => conditionFunction(isSignedIn(), () => launch(context, Constants.heroPage, tip), () => _showSignInDialog()),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              ColorMix(gradient: AppColor(theme).alertMix, child: Icon(widget.tips[index].iconData, size: 56.0, color: AppColor(theme).action)),
              const SizedBox(height: 16.0),
              ColorMix(
                gradient: AppColor(theme).textMix,
                child: Text(Util.formatCategory(widget.tips[index].category), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: AppColor(theme).action)),
              ),
              const SizedBox(height: 8.0),
              Text(widget.tips[index].shortDescription, style: const TextStyle(fontSize: 14.0)),
            ]),
          ),
        );
      },
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.85,
        aspectRatio: 16 / 9,
      ),
    );
  }

  void _showSignInDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => SignInDialog(action: () => widget.action()),
    );
  }
}
