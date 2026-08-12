import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:fitness_pro/main.dart';
import 'package:fitness_pro/services/hive_service.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('fitness_pro_test');
    // path_provider has no platform channel in widget tests, so point
    // Hive at a temp directory directly rather than calling initFlutter().
    await HiveService.instance.init(testPath: tempDir.path);
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  testWidgets('FitnessProApp builds and loads without fake demo data',
      (tester) async {
    await tester.pumpWidget(const FitnessProApp());
    await tester.pumpAndSettle();

    expect(find.byType(FitnessProApp), findsOneWidget);

    // A brand-new install must not show fabricated demo content.
    expect(find.text('Alex Johnson'), findsNothing);
    expect(find.text('alex@fitnesspro.com'), findsNothing);
  });
}
