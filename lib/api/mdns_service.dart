// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter_mdns_plugin/flutter_mdns_plugin.dart';

class MdnsService {
  final String serviceType = '_http._tcp.local.';
  final String serviceName = 'Food_Nutrition_API._http._tcp.local.';
  late FlutterMdnsPlugin _flutterMdnsPlugin;
  final StreamController<String> _ipController = StreamController<String>();

  MdnsService() {
    _flutterMdnsPlugin = FlutterMdnsPlugin(
      discoveryCallbacks: DiscoveryCallbacks(
        onDiscoveryStarted: () {
          print("Discovery started");
        },
        onDiscoveryStopped: () {
          print("Discovery stopped");
        },
        onDiscovered: (ServiceInfo serviceInfo) {
          print("Service discovered: ${serviceInfo.name}");
        },
        onResolved: (ServiceInfo serviceInfo) {
          if (serviceInfo.name == serviceName) {
            final ip = serviceInfo.hostName;
            print("Service resolved with IP: $ip");
            _ipController.add(ip ?? '');
          }
        },
      ),
    );
  }

  Future<String?> discoverService() async {
    _flutterMdnsPlugin.startDiscovery(serviceType);
    String? ipAddress;

    try {
      ipAddress =
          await _ipController.stream.first.timeout(const Duration(seconds: 10));
    } catch (e) {
      print("Timeout while resolving service");
    } finally {
      _flutterMdnsPlugin.stopDiscovery();
    }

    return ipAddress;
  }
}
