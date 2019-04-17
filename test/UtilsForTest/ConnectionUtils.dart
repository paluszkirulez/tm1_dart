import 'dart:io';

Future<String> getIp() async {
  for (var interface in await NetworkInterface.list()) {
    for (var addr in interface.addresses) {
      return
        '${addr.address}';
    }
  }
}