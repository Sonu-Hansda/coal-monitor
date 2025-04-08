import 'package:coal_monitor/provider/permission_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Permissions'),
        backgroundColor: Colors.orange,
      ),
      body: Consumer<PermissionProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Please grant these permissions for full functionality:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Location Permission Tile
              _PermissionTile(
                permission: Permission.location,
                name: 'Location Access',
                description: 'Required for mine location tracking',
                icon: Icons.location_on,
                isGranted:
                    provider.permissionStatus[Permission.location] ?? false,
                onRequest: () =>
                    provider.requestPermission(Permission.location),
              ),

              // Sensors Permission Tile
              _PermissionTile(
                permission: Permission.sensors,
                name: 'Sensor Access',
                description: 'Required for device sensor data',
                icon: Icons.sensors,
                isGranted:
                    provider.permissionStatus[Permission.sensors] ?? false,
                onRequest: () => provider.requestPermission(Permission.sensors),
              ),

              const SizedBox(height: 30),
              if (provider.allPermissionsGranted)
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Continue to App',
                      style: TextStyle(fontSize: 18)),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final Permission permission;
  final String name;
  final String description;
  final IconData icon;
  final bool isGranted;
  final VoidCallback onRequest;

  const _PermissionTile({
    required this.permission,
    required this.name,
    required this.description,
    required this.icon,
    required this.isGranted,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Icon(
          isGranted ? Icons.check_circle : Icons.error,
          color: isGranted ? Colors.green : Colors.red,
        ),
        onTap: !isGranted ? () => _showPermissionDialog(context) : null,
      ),
    );
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Allow $name?'),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRequest();
            },
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }
}
