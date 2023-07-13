import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final permissionProvider = StateNotifierProvider<PermissionNotifier, LocationPermission?>((ref) => PermissionNotifier());

class PermissionNotifier extends StateNotifier<LocationPermission?> {
  PermissionNotifier() : super(null);

  set setPermission(LocationPermission? locationPermission) => state = locationPermission;
}
