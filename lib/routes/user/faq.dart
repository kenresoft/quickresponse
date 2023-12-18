import 'package:quickresponse/main.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<FAQItem> faqs = [
    FAQItem(
      question: 'What does SOS stand for?',
      answer: 'SOS stands for "Save Our Souls" or "Save Our Ship." It is used as a universal distress signal in emergency situations.',
    ),
    FAQItem(
      question: 'How do I send an SOS signal using the app?',
      answer:
          'To send an SOS signal, open the app and locate the SOS button. Press and hold the button for a few seconds. The app will then send your distress signal to your predefined emergency contacts or emergency services.',
    ),
    FAQItem(
      question: 'Can I customize my list of emergency contacts?',
      answer: 'Yes, you can customize your list of emergency contacts in the app settings. You can add or remove contacts according to your preference.',
    ),
    FAQItem(
      question: 'What information is sent when I trigger an SOS alert?',
      answer: 'When you trigger an SOS alert, the app sends your current location, along with any additional information you have provided in your profile, to your emergency contacts or emergency services.',
    ),
    /*FAQItem(
      question: 'Is it possible to cancel an SOS alert once it has been sent?',
      answer:
          'Yes, if you accidentally trigger an SOS alert, you typically have a short window of time to cancel it. The exact method may vary based on the app, so it\'s essential to check the app\'s instructions for specific details.',
    ),*/
    FAQItem(
      question: 'Will the app work without an internet connection?',
      answer:
          'While the app is capable of sending distress signals via SMS without an internet connection, we recommend having an internet connection for optimal functionality. An internet connection is particularly useful for features like location fetching, which can provide more accurate and timely assistance during emergencies.',
    ),
    FAQItem(
      question: 'How can I ensure that my emergency contacts receive my SOS alerts promptly?',
      answer: 'To ensure that your emergency contacts receive your SOS alerts promptly, it\'s important to follow these steps:\n\n'
          '1. Confirm that your emergency contacts have a stable internet connection or cellular network to receive notifications.\n'
          '2. Instruct them to keep their phones nearby and ensure that the app notifications are enabled.\n'
          '3. Additionally, be aware that SMS charges may be incurred when sending SOS messages. Make sure you have sufficient credit to cover any potential charges before initiating an SOS.',
    ),
    /*FAQItem(
      question: 'Can I test the SOS feature to see how it works without actually sending an alert?',
      answer: 'Yes, many apps allow you to test the SOS feature without triggering a real alert. Check the app settings or user manual for a testing or demo mode that simulates the SOS functionality.',
    ),*/
    FAQItem(
      question: 'What should I do after sending an SOS alert?',
      answer:
          'After sending an SOS alert, find a safe location if you are not already in one. Wait for help to arrive and stay on the line if you are communicating with emergency services. If you can provide updates on your situation, do so.',
    ),
    FAQItem(
      question: 'How often should I update my emergency contacts and information in the app?',
      answer:
          'It\'s advisable to review and update your emergency contacts and information in the app periodically, especially if there are changes in your contacts\' phone numbers or addresses. Regular updates ensure that your SOS alerts reach the right people.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      appBar: const CustomAppBar(
        title: Text('Frequently Asked Questions', style: TextStyle(fontSize: 20)),
        leading: LogoCard(),
        actionTitle: '',
      ),
      body: Container(
        height: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(color: theme ? AppColor(theme).white : AppColor(theme).black, borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.all(1),
        child: Container(
          decoration: BoxDecoration(color: theme ? AppColor(theme).background : AppColor(theme).backgroundDark, borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ListView.builder(
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor(theme).white,
                  elevation: 0,
                  child: FAQTile(faq: faqs[index]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class FAQTile extends StatefulWidget {
  final FAQItem faq;

  const FAQTile({super.key, required this.faq});

  @override
  State<FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(title: Text(widget.faq.question), children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(widget.faq.answer),
        ),
      ]),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
