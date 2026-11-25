import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merkez_verimlilik/main.dart';
import 'package:studio_core/app/services/ads.dart';
import 'package:studio_core/app/services/purchases.dart';
import 'package:studio_core/apps/apps.dart';
import 'package:studio_core/core/save_store.dart';

void main() {
  test('merkezde 32 uygulama benzersiz kimlikle, 33 dilde', () {
    expect(hubConfig.tools.length, 32);
    expect(hubConfig.tools.map((t) => t.id).toSet().length, 32);
    for (final t in hubConfig.tools) {
      expect(t.title.length, 33, reason: t.id);
      expect(hubConfig.categories.any((c) => c.id == t.category), isTrue, reason: t.id);
    }
    for (final id in hubConfig.featured) {
      expect(hubConfig.tool(id), isNotNull, reason: id);
    }
  });

  testWidgets('merkez açılır ve "32 Uygulama" yazar', (tester) async {
    final s = AppServices(hubId: hubConfig.hubId, backend: MemoryBackend(), ads: NoAdsService(), purchases: NoPurchaseService());
    await s.load();
    await s.setConsent(false);
    await s.setLanguage('tr');
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(AppHubApp(config: hubConfig, services: s));
    await tester.pumpAndSettle();
    expect(find.text(appTx('n_apps', 'tr', {'n': 32})), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
