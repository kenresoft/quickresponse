import 'package:quickresponse/main.dart';

class CustomLocationDialog extends StatefulWidget {
  const CustomLocationDialog({super.key});

  @override
  State<CustomLocationDialog> createState() => _CustomLocationDialogState();
}

class _CustomLocationDialogState extends State<CustomLocationDialog> {
  /*String? _streetAddress;
  String? _locationData;*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final position = ref.watch(positionProvider.select((value) => value));
          if (position != null) {
            _getAddressFromCoordinates(position.latitude, position.longitude);
          }
          return AlertDialog(
            title: Text(
              'Last Known Location',
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Current Address:', style: TextStyle(color: AppColor(theme).action, fontSize: 17)),
                Text(locationData),
                const SizedBox(height: 10),
                Text('Current Coordinate:', style: TextStyle(color: AppColor(theme).action, fontSize: 17)),
                Text('Latitude: ${position?.latitude}, Longitude: ${position?.longitude}'),
              ],
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              FilledButton(
                onPressed: () => launch(context, Constants.locationMap),
                child: const Text('Open Map'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        final address = 'Street: ${placemark.street}, ${placemark.name}, \n'
                'Province: ${placemark.subAdministrativeArea}, \n'
                'Locality: ${placemark.locality}, \n'
                'State: ${placemark.administrativeArea}, \n'
                'Country: ${placemark.country}, \n'
                'Postal code: ${placemark.postalCode}. '
            .log;
        locationData = address;
      }
    } catch (e) {
      locationData = 'Error fetching address: $e'.log;
    }
  }
}
