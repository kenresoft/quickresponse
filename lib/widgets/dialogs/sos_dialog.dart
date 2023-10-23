import 'package:quickresponse/main.dart';

class SOSDialog extends StatelessWidget {
  final List<String> sosMessages;
  final Function(String) onMessageSelected;

  const SOSDialog({super.key, required this.sosMessages, required this.onMessageSelected});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        //padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(12)),
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: const Text('Select SOS Message', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white)),
          ),
          Container(
            color: Colors.transparent,
            //color: AppColor(theme).bg,
            height: 300,
            child: ListView.builder(
              itemCount: sosMessages.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    onMessageSelected(sosMessages[index]);
                  },
                  child: Card(
                    elevation: 1,
                    color: AppColor(theme).white,
                    //color: AppColor(theme).white,
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.wand_stars, color: sosMessage == sosMessages[index] ? Colors.red : Colors.transparent, size: 14),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 200,
                            child: Text(
                              sosMessages[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColor(theme).title, fontWeight: FontWeight.w300, fontSize: 17),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
