import 'dart:convert';
import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    responseDataCallback: (data) async {
      final images = data?['screenImages'] as Map<String, dynamic>? ?? {};
      for (final entry in images.entries) {
        final file = File('docs/screenshots/${entry.key}.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(base64Decode(entry.value as String));
      }
      if (images.length != 19) {
        throw StateError('Expected 19 screenshots, received ${images.length}.');
      }
    },
  );
}
