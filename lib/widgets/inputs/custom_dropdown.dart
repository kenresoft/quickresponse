import 'package:quickresponse/main.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final double width;
  final double height;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width = 120.0,
    this.height = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height, // Set the width of the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            isExpanded: true,
            isDense: true,
            elevation: 0,
            dropdownColor: AppColor(theme).dropdown,
            borderRadius: BorderRadius.circular(12),
            menuMaxHeight: 160,
            style: TextStyle(fontSize: 13, fontFamily: FontResoft.sourceSansPro, package: FontResoft.package),
          ),
        ),
      ),
    );
  }
}
