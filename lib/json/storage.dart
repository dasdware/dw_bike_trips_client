import 'dart:convert';
import 'dart:io';
import 'package:dw_bike_trips_client/json/hosts.dart';
import 'package:dw_bike_trips_client/session/hosts.dart';
import 'package:path_provider/path_provider.dart';

void saveHosts(Hosts hosts) async {
  final json = JSONHosts.fromHosts(hosts);
  final jsonString = jsonEncode(json);

  File output = await _getDefaultStorageFile('hosts');
  await output.writeAsString(jsonString);
}

Future<Hosts> loadHosts() async {
  final File input = await _getDefaultStorageFile('hosts');
  if (await input.exists()) {
    return JSONHosts.fromJson(
      jsonDecode(await input.readAsString()),
    ).toHosts();
  } else {
    return Hosts();
  }
}

Future<File> _getDefaultStorageFile(String name) async {
  final path = await getApplicationDocumentsDirectory();
  return File('${path.path}/$name.json');
}
