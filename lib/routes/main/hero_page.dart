import 'package:quickresponse/main.dart';

import '../../widgets/display/color_mix.dart';

class HeroPage extends ConsumerStatefulWidget {
  final EmergencyTip tip;

  const HeroPage({super.key, required this.tip});

  @override
  ConsumerState<HeroPage> createState() => _HeroPageState();
}

class _HeroPageState extends ConsumerState<HeroPage> {
  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return Scaffold(
      backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      appBar: CustomAppBar(
        leading: const LogoCard(),
        title: Text(widget.tip.shortDescription, style: const TextStyle(fontSize: 21)),
        actionTitle: '',
        actionIcon: CupertinoIcons.doc_on_clipboard,
        onActionClick: () {
          Clipboard.setData(ClipboardData(text: '${widget.tip.shortDescription}: \n${widget.tip.longDescription}'));
          context.toast('Copied to clipboard!', TextAlign.center, Colors.green);
        },
      ),
      body: Container(
        height: dp.height - 120,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColor(theme).white, border: Border.all(width: 1, color: AppColor(theme).overlay), borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Hero(
              tag: widget.tip.iconData, // Use the image URL as the hero tag
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Blink(
                  isNotText: true,
                  child: SvgPicture.asset(Constants.redCross, width: 50, height: 50),
                  //child: ColorMix(gradient: AppColor(theme).alertMix, child: Icon(widget.tip.iconData, size: 72.0, color: AppColor(theme).action)),
                ),
                SizedBox(
                  width: 0.6.dpW(dp),
                  child: ColorMix(gradient: AppColor(theme).textMix, child: Text(softWrap: true, Util.formatCategory(widget.tip.category), style: const TextStyle(fontSize: 24))),
                )
              ]),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(categoryImages[widget.tip.category.toLowerCase()] ?? Constants.caution, height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            ColorMix(gradient: AppColor(theme).iconMix, child: Text(widget.tip.longDescription, style: const TextStyle(fontSize: 23))),
          ]),
        ),
      ),
    );
  }

  Map<String, String> categoryImages = {
    'security': Constants.police,
    'home_invasion': Constants.homeInvasion,
    'robbery': Constants.robbery,
    'fire': Constants.ambulance,
    'medical': Constants.medical,
    'assault': Constants.assault,
    'kidnapping': Constants.kidnapping,
  };
}
