import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class VersionChecker {
  static Future<String?> getLatestVersion() async {
    final url = Uri.parse('https://api.github.com/repos/Andrewaziz99/EFTKDNY_APP/releases/latest');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['tag_name'] as String?;
    }
    return null;
  }

  static Future<String> getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  static Future<bool> isUpdateAvailable() async {
    final latest = await getLatestVersion();
    final current = await getCurrentVersion();
    if (latest == null) return false;
    return _compareVersions(latest, current) > 0;
  }

  static int _compareVersions(String v1, String v2) {
    final v1Parts = v1.replaceAll(RegExp(r'[^0-9.]'), '').split('.').map(int.parse).toList();
    final v2Parts = v2.replaceAll(RegExp(r'[^0-9.]'), '').split('.').map(int.parse).toList();
    for (int i = 0; i < v1Parts.length; i++) {
      if (i >= v2Parts.length) return 1;
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }
    return 0;
  }
}

