import 'package:quickresponse/main.dart';

class LogoCard extends StatelessWidget {
  const LogoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor(theme).white,
      elevation: 0,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(FontAwesomeIcons.q, color: AppColor(theme).navIconSelected, size: 5),
            Icon(FontAwesomeIcons.u, color: AppColor(theme).navIconSelected, size: 5),
            Icon(FontAwesomeIcons.i, color: AppColor(theme).navIconSelected, size: 5),
            Icon(FontAwesomeIcons.c, color: AppColor(theme).navIconSelected, size: 5),
            Icon(FontAwesomeIcons.k, color: AppColor(theme).navIconSelected, size: 5)
          ]),
          const SizedBox(height: 1),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(FontAwesomeIcons.r, color: AppColor(theme).navIconSelected, size: 3),
            Icon(FontAwesomeIcons.e, color: AppColor(theme).navIconSelected, size: 3),
            Icon(FontAwesomeIcons.s, color: AppColor(theme).navIconSelected, size: 3),
            Icon(FontAwesomeIcons.p, color: AppColor(theme).navIconSelected, size: 3),
            Icon(FontAwesomeIcons.o, color: AppColor(theme).navIconSelected, size: 3),
            Icon(FontAwesomeIcons.n, color: AppColor(theme).navIconSelected, size: 3),
            Icon(FontAwesomeIcons.s, color: AppColor(theme).navIconSelected, size: 3),
            Icon(FontAwesomeIcons.e, color: AppColor(theme).navIconSelected, size: 3)
          ]),
        ]),
      ]),
    );
  }
}
