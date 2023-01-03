import 'dart:async';
import 'package:dw_bike_trips_client/json/storage.dart' as storage;

class Host {
  final String name;
  final String url;
  bool active = false;

  Host(this.name, this.url);
}

class Hosts {
  final List<Host> _entries = [];

  final StreamController<List<Host>> _entriesStreamController =
      StreamController<List<Host>>.broadcast();

  dispose() {
    _entriesStreamController.close();
  }

  _changed() {
    _entriesStreamController.sink.add(_entries);
    storage.saveHosts(this);
  }

  addHost(String name, String url) {
    var host = Host(name, url);
    host.active = true;
    _entries.add(host);
    setActiveHost(host);
  }

  removeHost(Host host) {
    _entries.remove(host);
    _changed();
  }

  setActiveHost(Host host) {
    for (var entry in entries) {
      entry.active = (entry == host);
    }
    _changed();
  }

  Host get activeHost {
    for (var host in _entries) {
      if (host.active) {
        return host;
      }
    }
    return null;
  }

  List<Host> get entries => _entries;
  Stream<List<Host>> get entriesStream => _entriesStreamController.stream;
}
