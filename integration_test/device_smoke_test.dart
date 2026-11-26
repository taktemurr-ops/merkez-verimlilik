// Cihazda araç gezintisi (device-smoke / device-matrix iş akışları): merkez
// gerçek ekranda açılır; Türkçe, Arapça (sağdan sola) ve İngilizcede her
// kategoriden araçlar açılıp kapanır, sekmeler gezilir. Taşma, kesik metin ve
// ekran dışında kalan düğmeler toplanır; sonuç logcat'e yazılır
// (DEVICE_SMOKE_OK / DEVICE_SMOKE_FAIL). Derleme:
//   flutter build apk --debug -t integration_test/device_smoke_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:merkez_verimlilik/main.dart' as hub;
import 'package:studio_core/app/services/ads.dart';
import 'package:studio_core/app/services/purchases.dart';
import 'package:studio_core/apps/apps.dart';
import 'package:studio_core/core/save_store.dart';

import '../test/layout_check.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('cihazda araç gezintisi', (tester) async {
    // ignore: avoid_print
    print('DEVICE_SMOKE_START');
    final c = hub.hubConfig;
    final issues = LayoutIssues();
    final trap = ErrorTrap();
    var dev = '?';
    var opened = 0;

    Future<void> wait(int ms) async {
      for (var i = 0; i < ms ~/ 100; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    }

    try {
      final s = AppServices(hubId: c.hubId, backend: MemoryBackend(), ads: NoAdsService(), purchases: NoPurchaseService());
      await s.load();
      await s.setConsent(false);
      for (final lang in ['tr', 'ar', 'en']) {
        await s.setLanguage(lang);
        await tester.pumpWidget(AppHubApp(config: c, services: s));
        await wait(1500);
        final size = tester.binding.renderViews.first.size;
        dev = '${size.width.round()}x${size.height.round()}';
        checkLayout(tester, issues, trap, 'merkez', '$dev $lang');
        // Alt gezinme sekmeleri.
        for (final icon in [Icons.apps_rounded, Icons.star_rounded, Icons.person_rounded, Icons.home_rounded]) {
          final f = find.byIcon(icon);
          if (f.evaluate().isEmpty) continue;
          await tester.tap(f.last, warnIfMissed: false);
          await wait(800);
          checkLayout(tester, issues, trap, 'sekme-${icon.codePoint}', '$dev $lang');
        }
        final perCategory = lang == 'tr' ? 3 : 1;
        for (final cat in c.categories) {
          for (final t in c.tools.where((t) => t.category == cat.id).take(perCategory)) {
            final shell = find.byType(AppHubShell);
            if (shell.evaluate().isEmpty) break;
            final nav = Navigator.of(tester.element(shell));
            // ignore: unawaited_futures
            nav.push(MaterialPageRoute<void>(builder: (_) => AppToolPage(config: c, tool: t, services: s, lang: lang)));
            await wait(1500);
            checkLayout(tester, issues, trap, t.id, '$dev $lang');
            opened++;
            nav.pop();
            await wait(600);
          }
        }
      }
      await tester.pumpWidget(const SizedBox());
      await wait(500);
    } catch (e) {
      issues.add('test', dev, 'hata', e.toString().split('\n').first);
    } finally {
      trap.stop();
    }
    issues.printSummary('cihaz');
    // ignore: avoid_print
    print(issues.items.isEmpty ? 'DEVICE_SMOKE_OK araç=$opened' : 'DEVICE_SMOKE_FAIL sorun=${issues.items.length} araç=$opened');
    expect(issues.items, isEmpty);
  }, timeout: const Timeout(Duration(minutes: 15)));
}
