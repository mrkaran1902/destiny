// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'footer_widget.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:dbus/dbus.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'System Menu',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),// Footer
        ),
        centerTitle: true,
        foregroundColor: Color(0xffffffff),
        backgroundColor: const Color(0xff602E84),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMenuButton(
                context,
                title: 'Water Management',
                icon: Icons.water_drop,
                onTap: () {
                  // Navigate to the Water Management page or trigger functionality
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WaterManagementPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                title: 'Network',
                icon: Icons.network_wifi,
                onTap: () {
                  // Navigate to the Network page or trigger functionality
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NetworkPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                title: 'Update',
                icon: Icons.system_update,
                onTap: () {
                  // Navigate to the Upgrade page or trigger functionality
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UpdatePage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                title: 'System Parameters',
                icon: Icons.settings,
                onTap: () {
                  // Navigate to the System Parameters page or trigger functionality
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SystemParametersPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: // Footer
          const FooterWidget(),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        backgroundColor: const Color(0xff602E84),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder pages for each menu option
class WaterManagementPage extends StatelessWidget {
  const WaterManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Management'),
        backgroundColor: const Color(0xff602E84),
      ),
      body: const Center(
        child: Text('Water Management Page'),
      ),
    );
  }
}

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  List<String> _wifiNetworks = [];
  String? _connectedSSID;

  @override
  void initState() {
    super.initState();
    getCurrentWifi();
    if (Platform.isLinux) {
      scanWifiNetworks();
    }
  }

  Future<void> scanWifiNetworks() async {
    if (!Platform.isLinux) return;
    try {
      final client = DBusClient.system();
      final object = DBusRemoteObject(client, 
        name: 'org.freedesktop.NetworkManager', 
        path: DBusObjectPath('/org/freedesktop/NetworkManager')
      );

      final response = await object.callMethod('org.freedesktop.NetworkManager', 'GetDevices', []);
      // Process response and update _wifiNetworks list
      client.close();

      if (mounted) {
        setState(() {
          _wifiNetworks = ["WiFi 1", "WiFi 2", "WiFi 3"]; // Placeholder for real networks
        });
      }
    } catch (e) {
      print("Error scanning WiFi: $e");
    }
  }

  Future<void> getCurrentWifi() async {
    final info = NetworkInfo();
    String? ssid = await info.getWifiName();
    if (mounted) {
      setState(() {
        _connectedSSID = ssid;
      });
    }
  }

  Future<void> connectToWifi(String ssid, String password) async {
    if (!Platform.isLinux) return;
    Process.run('nmcli', ['d', 'wifi', 'connect', ssid, 'password', password]).then((result) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connected to $ssid")),
        );
      }
    });
  }

  Future<void> disconnectFromWifi() async {
    if (!Platform.isLinux) return;
    Process.run('nmcli', ['d', 'disconnect', 'wlan0']).then((_) {
      if (mounted) {
        setState(() {
          _connectedSSID = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Networks'),
        backgroundColor: const Color(0xff602E84),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: scanWifiNetworks,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_connectedSSID != null)
            ListTile(
              title: Text("Connected: $_connectedSSID"),
              trailing: ElevatedButton(
                onPressed: disconnectFromWifi,
                child: Text("Disconnect"),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _wifiNetworks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_wifiNetworks[index]),
                  trailing: ElevatedButton(
                    onPressed: () {
                      TextEditingController passwordController = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Connect to ${_wifiNetworks[index]}"),
                          content: TextField(
                            controller: passwordController,
                            decoration: InputDecoration(hintText: "Enter WiFi Password"),
                            obscureText: true,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                connectToWifi(_wifiNetworks[index], passwordController.text);
                                Navigator.pop(context);
                              },
                              child: Text("Connect"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text("Connect"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  Future<String?> getLatestReleaseUrl() async {
    final response = await http.get(
      Uri.parse('https://api.github.com/repos/YOUR_GITHUB_USERNAME/YOUR_REPO/releases/latest'),
      headers: {'Accept': 'application/vnd.github.v3+json'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var asset in data['assets']) {
        if (asset['name'] == 'flutter_app.tar.gz') {
          return asset['browser_download_url'];
        }
      }
    }
    return null;
  }

  Future<void> downloadAndInstallUpdate(BuildContext context) async {
    String? url = await getLatestReleaseUrl();
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No update available")),
      );
      return;
    }

    String filePath = '/home/pi/flutter_update.tar.gz';
    Dio dio = Dio();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Downloading update...")),
    );
    
    await dio.download(url, filePath);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Installing update...")),
    );

    Process.run('tar', ['-xzf', filePath, '-C', '/home/pi/flutter_app/']).then((_) {
      Process.run('chmod', ['+x', '/home/pi/flutter_app/your_binary']);
      Process.run('pkill', ['your_app_name']);
      Process.run('/home/pi/flutter_app/your_binary', []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPDATE'),
        centerTitle: true,
        backgroundColor: const Color(0xff602E84),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          height: 100,
          child: ElevatedButton(
            onPressed: () => downloadAndInstallUpdate(context),
            child: const Text("UPDATE SYSTEM", style: TextStyle(fontSize: 45)),
          ),
        ),
      ),
    );
  }
}

class SystemParametersPage extends StatelessWidget {
  const SystemParametersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Parameters'),
        backgroundColor: const Color(0xff602E84),
      ),
      body: const Center(
        child: Text('System Parameters Page'),
      ),
    );
  }
}