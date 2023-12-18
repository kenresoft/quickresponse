import 'package:quickresponse/main.dart';

class CustomExpansionCard extends StatefulWidget {
  final String title;
  final String subTitle;
  final IconData iconData;
  final String content;

  const CustomExpansionCard({
    super.key,
    required this.title,
    required this.content,
    required this.subTitle,
    required this.iconData,
  });

  @override
  State<CustomExpansionCard> createState() => _CustomExpansionCardState();
}

class _CustomExpansionCardState extends State<CustomExpansionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColor(theme).white,
      elevation: 0,
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Column(children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Padding(padding: const EdgeInsets.only(left: 16), child: Icon(widget.iconData, color: AppColor(theme).navIconSelected, size: 30)),
            title: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
              maxLines: 1, // Limit to a single line
            ),
            subtitle: Text(widget.subTitle),
          ),
          _isExpanded ? Padding(padding: const EdgeInsets.all(16.0), child: Text(widget.content, textAlign: TextAlign.center)) : Container(),
        ]),
      ),
    );
  }
}
