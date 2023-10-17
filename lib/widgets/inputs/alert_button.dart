import 'package:quickresponse/main.dart';

class AlertButton extends StatefulWidget {
  const AlertButton({
    Key? key,
    required this.height,
    required this.width,
    required this.borderWidth,
    required this.shadowWidth,
    required this.iconSize,
    this.showSecondShadow = true,
    this.iconData,
    required this.onPressed,
    this.delay,
  }) : super(key: key);

  final double height;
  final double width;
  final double borderWidth;
  final double shadowWidth;
  final double iconSize;
  final bool showSecondShadow;
  final IconData? iconData;
  final Function()? onPressed;
  final Duration? delay;

  @override
  State<AlertButton> createState() => _AlertButtonState();
}

class _AlertButtonState extends State<AlertButton> with TickerProviderStateMixin {
  late ValueNotifier<bool> _isPressedNotifier;
  late AnimationController _iconAnimationController;
  late AnimationController _shadowAnimationController;
  late AnimationController _gradientAnimationController;

  @override
  void initState() {
    super.initState();
    _isPressedNotifier = ValueNotifier<bool>(false);
    _iconAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat(reverse: true);
    _shadowAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat(reverse: true);
    _gradientAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _isPressedNotifier.dispose();
    _iconAnimationController.dispose();
    _shadowAnimationController.dispose();
    _gradientAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) {
        _isPressedNotifier.value = !_isPressedNotifier.value;
        if (widget.onPressed != null) {
          Future.delayed(widget.delay ?? const Duration(seconds: 3), () {
            widget.onPressed!();
            _isPressedNotifier.value = !_isPressedNotifier.value;
          });
        }
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _isPressedNotifier,
        builder: (context, isPressed, child) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.elliptical(widget.width, widget.height)),
                  color: ColorTween(begin: AppColor(theme).alert_2, end: AppColor(theme).action).evaluate(_gradientAnimationController),
                  border: Border.all(width: widget.borderWidth, color: isPressed ? Colors.transparent : Colors.grey),
                  boxShadow: isPressed
                      ? [
                          BoxShadow(color: Colors.white.withOpacity(0.6), spreadRadius: 3),
                          BoxShadow(
                            color: theme ? Colors.white.withOpacity(0.5) : AppColor(theme).white.withOpacity(0.8),
                            offset: Tween<Offset>(begin: const Offset(0, -20), end: const Offset(0, -30)).animate(_shadowAnimationController).value,
                            blurRadius: 5,
                          ),
                          BoxShadow(
                            color: theme ? Colors.grey.withOpacity(0.3) : AppColor(theme).white.withOpacity(0.5),
                            offset: Tween<Offset>(begin: const Offset(10, 20), end: const Offset(10, 30)).animate(_shadowAnimationController).value,
                            blurRadius: 5,
                          ),
                          BoxShadow(color: Colors.grey.withOpacity(0.3), offset: Tween<Offset>(begin: const Offset(10, 0), end: const Offset(10, 10)).animate(_shadowAnimationController).value, blurRadius: 5),
                          BoxShadow(
                            color: theme ? Colors.grey.withOpacity(0.3) : AppColor(theme).white.withOpacity(0.5),
                            offset: Tween<Offset>(begin: const Offset(-10, 10), end: const Offset(-10, 20)).animate(_shadowAnimationController).value,
                            blurRadius: 5,
                          ),
                          BoxShadow(color: Colors.grey.withOpacity(0.3), offset: Tween<Offset>(begin: const Offset(-10, 0), end: const Offset(-10, 10)).animate(_shadowAnimationController).value, blurRadius: 5),
                          BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: widget.shadowWidth),
                        ]
                      : [const BoxShadow(color: Colors.white, spreadRadius: 3)],
                ),
                width: widget.width,
                height: widget.height,
                child: AnimatedBuilder(
                  animation: _iconAnimationController,
                  builder: (context, child) {
                    return Icon(
                      widget.iconData ?? CupertinoIcons.location_solid,
                      size: widget.iconSize,
                      color: !isPressed ? Colors.red.shade900.withOpacity(1 - _iconAnimationController.value) : CupertinoColors.white,
                    );
                  },
                ),
              ),
              Visibility(
                visible: isPressed,
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: CircularProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: widget.borderWidth,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
