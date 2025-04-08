import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider with ChangeNotifier {
  final Map<Permission, bool> _permissionStatus = {
    Permission.location: false,
    Permission.sensors: false,
  };

  Map<Permission, bool> get permissionStatus => _permissionStatus;

  Future<void> checkAllPermissions() async {
    for (var permission in _permissionStatus.keys) {
      _permissionStatus[permission] = await permission.isGranted;
    }
    notifyListeners();
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    _permissionStatus[permission] = status.isGranted;
    notifyListeners();
  }

  bool get allPermissionsGranted {
    return _permissionStatus.values.every((status) => status);
  }
}
