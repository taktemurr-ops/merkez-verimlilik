// Ekran boyutları: merkezin ana ekranları ve her aracın açılış ekranı küçük
// telefondan yatay tablete kadar, büyük yazı ve sağdan sola dilde taşmadan,
// metin kesilmeden, düğmeler erişilebilir biçimde açılır. CI'da ayrı işte
// çalışır (etiket: boyut).
@Tags(['boyut'])
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merkez_verimlilik/main.dart' as hub;
import 'package:studio_core/app/approved_hub.dart' show ApprovedLook;
import 'package:studio_core/app/services/ads.dart';
import 'package:studio_core/app/services/purchases.dart';
import 'package:studio_core/app/studio_look.dart';
import 'package:studio_core/apps/apps.dart';
import 'package:studio_core/core/save_store.dart';
import 'package:studio_core/core/strings.dart';

import 'layout_check.dart';

final issues = LayoutIssues();

Future<AppServices> _services(String lang) async {
  final s = AppServices(hubId: hub.hubConfig.hubId, backend: MemoryBackend(), ads: NoAdsService(), purchases: NoPurchaseService());
  await s.load();
  await s.setConsent(false);
  await s.setLanguage(lang);
  return s;
}

Widget _app(String lang, Widget child) {
  final style = hub.hubConfig.style;
  final theme = buildStudioTheme(style.look);
  return StudioLookScope(
    look: style.look,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      darkTheme: theme,
      themeMode: ThemeMode.dark,
      locale: Locale(lang),
      supportedLocales: Strings.languages.map(Locale.new).toList(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, c) => AppLook(style: style, child: c ?? const SizedBox()),
      home: child,
    ),
  );
}

/// Eklentiler (kamera, sensör, NFC…) widget testinde yoktur: bunların hatası
/// düzen sorunu sayılmaz, diğer hatalar sayılır.
Future<void> _guarded(String screen, Future<void> Function() body) async {
  void onError(Object e, StackTrace st) {
    final s = e.toString();
    if (s.contains('MissingPluginException') || s.contains('PlatformException') || s.contains('No implementation found')) return;
    issues.add(screen, '-', 'hata', s.split('\n').first);
  }

  await runZonedGuarded(() async {
    try {
      await body();
    } catch (e, st) {
      onError(e, st);
    }
  }, onError);
}

void main() {
  tearDownAll(() => issues.printSummary('merkez_verimlilik'));

  testWidgets('merkez ana ekranları tüm boyutlarda', (tester) async {
    final s = (await tester.runAsync(() => _services('tr')))!;
    await sweep(tester, issues, 'merkez', langScales: const [('tr', 1.0), ('tr', 1.3), ('ar', 1.3)], (lang) async {
      await tester.runAsync(() => s.setLanguage(lang));
      await tester.pumpWidget(fresh(AppHubApp(config: hub.hubConfig, services: s)));
    });
    expect(issues.items.where((i) => i.startsWith('SORUN|merkez|')).toList(), isEmpty);
  }, timeout: const Timeout(Duration(minutes: 10)));

  for (final t in hub.hubConfig.tools) {
    testWidgets('açılış ekranı tüm boyutlarda: ${t.id}', (tester) async {
      final s = (await tester.runAsync(() => _services('tr')))!;
      await sweep(tester, issues, t.id, langScales: const [('tr', 1.3), ('ar', 1.3)], (lang) async {
        await tester.runAsync(() => s.setLanguage(lang));
        await _guarded(t.id, () async {
          await tester.pumpWidget(fresh(_app(lang, AppToolPage(config: hub.hubConfig, tool: t, services: s, lang: lang))));
        });
      });
      expect(issues.items.where((i) => i.startsWith('SORUN|${t.id}|')).toList(), isEmpty);
    }, timeout: const Timeout(Duration(minutes: 10)));
  }
}
