// Mağaza görselleri: merkezin onaylı tasarımdaki ana sayfası ve öne çıkan
// araçların gerçek ekranları; 33 dilde, Android telefon/tablet ve iPhone/iPad
// boyutlarında. Yalnızca store-shots iş akışında çalışır (Linux masaüstü).
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:merkez_verimlilik/main.dart' as hub;
import 'package:studio_core/app/approved_hub.dart' show ApprovedLook;
import 'package:studio_core/app/services/ads.dart';
import 'package:studio_core/app/services/purchases.dart';
import 'package:studio_core/app/studio_look.dart';
import 'package:studio_core/apps/apps.dart';
import 'package:studio_core/core/save_store.dart';
import 'package:studio_core/core/strings.dart';

/// Öncelikli araçlar (eklenti gerektirmeyen, ilk açılışta dolu görünen ekranlar).
const _preferred = <String>['uyg-kanban-panosu', 'uyg-pomodoro', 'uyg-yapilacaklar-listesi'];

class _Target {
  final String name;
  final Size box; // mantıksal boyut
  final Size device; // çerçevedeki ekran
  final double ratio; // piksel oranı
  final bool bleed; // App Store: çerçevesiz, tam ekran
  const _Target(this.name, this.box, this.device, this.ratio, {this.bleed = false});
}

// Play: Android telefon 1080×1920, tablet 1920×1080 (genel cihaz çerçeveli).
// App Store: iPhone 6,9" 1290×2796, iPad 13" 2048×2732; cihaz çerçevesi YOK
// (Apple 2.3.3), gerçek iOS mantıksal boyutunda tam ekran.
const _targets = [
  _Target('phone', Size(360, 640), Size(400, 800), 3),
  _Target('tablet', Size(1280, 720), Size(1000, 620), 1.5),
  _Target('iphone', Size(430, 932), Size.zero, 3, bleed: true),
  _Target('ipad', Size(1024, 1366), Size.zero, 2, bleed: true),
];

Widget _app(AppServices s, String lang, Widget child) {
  final style = hub.hubConfig.style;
  final look = style.look;
  final theme = buildStudioTheme(look);
  return StudioLookScope(
    look: look,
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

Widget _fitCaption(String text, double maxW, double maxH, double size) {
  var fs = size;
  TextStyle st() => TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: fs,
        height: 1.15,
        shadows: const [Shadow(blurRadius: 8, color: Colors.black38)],
      );
  while (fs > 10) {
    final tp = TextPainter(text: TextSpan(text: text, style: st()), textDirection: TextDirection.ltr, maxLines: 2)
      ..layout(maxWidth: maxW);
    if (!tp.didExceedMaxLines && tp.height <= maxH) break;
    fs *= 0.92;
  }
  return Text(text, textAlign: TextAlign.center, maxLines: 2, style: st());
}

/// App Store görseli: cihaz çerçevesi YOK (Apple 2.3.3). Üstte isteğe bağlı
/// başlık bandı, altında oyun ekranı kenardan kenara, gerçek iOS mantıksal
/// boyutunda çizilir.
Widget _bleedFrame({required Size box, required String caption, required Widget screen, required bool rtl}) {
  final bg = hub.hubConfig.style.background;
  final band = (box.height * 0.13).roundToDouble();
  final screenSize = Size(box.width, box.height - band);
  return Directionality(
    textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
    child: SizedBox(
      width: box.width,
      height: box.height,
      child: Column(children: [
        Container(
          width: box.width,
          height: band,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: box.width * 0.06),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [hub.hubConfig.style.accent, bg.first],
            ),
          ),
          child: _fitCaption(caption, box.width * 0.88, band * 0.86, math.min(box.width, box.height) * 0.064),
        ),
        SizedBox(
          width: screenSize.width,
          height: screenSize.height,
          child: ClipRect(
            child: MediaQuery(
              data: MediaQueryData(size: screenSize, devicePixelRatio: 3, padding: EdgeInsets.zero),
              child: screen,
            ),
          ),
        ),
      ]),
    ),
  );
}

Widget _frame({required _Target t, required String caption, required Widget screen, required bool rtl}) {
  if (t.bleed) return _bleedFrame(box: t.box, caption: caption, screen: screen, rtl: rtl);
  final box = t.box, device = t.device;
  final bg = hub.hubConfig.style.background;
  return Directionality(
    textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
    child: SizedBox(
      width: box.width,
      height: box.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [hub.hubConfig.style.accent, bg.first, bg.last],
            stops: const [0, 0.45, 1],
          ),
        ),
        child: Column(children: [
          SizedBox(
            height: box.height * 0.16,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: box.width * 0.06),
                child: _fitCaption(caption, box.width * 0.88, box.height * 0.15, math.min(box.width, box.height) * 0.072),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(box.width * 0.07, 0, box.width * 0.07, box.height * 0.035),
              child: FittedBox(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111318),
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: const [BoxShadow(blurRadius: 30, color: Colors.black45, offset: Offset(0, 10))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: SizedBox(
                      width: device.width,
                      height: device.height,
                      child: MediaQuery(
                        data: MediaQueryData(size: device, devicePixelRatio: 2.5, padding: EdgeInsets.zero),
                        child: screen,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    ),
  );
}

Widget _feature(String lang) {
  final c = hub.hubConfig;
  final bg = c.style.background;
  return Directionality(
    textDirection: Strings(lang).rtl ? TextDirection.rtl : TextDirection.ltr,
    child: SizedBox(
      width: 512,
      height: 250,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [c.style.accent, bg.first, bg.last])),
        child: Row(children: [
          SizedBox(
            width: 190,
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(color: const Color(0x33FFFFFF), borderRadius: BorderRadius.circular(32)),
                child: Icon(c.icon, size: 76, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 22),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(c.localized(c.title, lang),
                      maxLines: 1, style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(height: 8),
                Text(c.localized(c.tagline, lang),
                    maxLines: 3,
                    style: const TextStyle(color: Color(0xEEFFFFFF), fontSize: 17, fontWeight: FontWeight.w600, height: 1.2)),
              ]),
            ),
          ),
        ]),
      ),
    ),
  );
}

final _shotKey = GlobalKey();

Widget _offscreen(Widget child) => OverflowBox(
      alignment: Alignment.topLeft,
      minWidth: 0,
      minHeight: 0,
      maxWidth: double.infinity,
      maxHeight: double.infinity,
      child: RepaintBoundary(key: _shotKey, child: Material(type: MaterialType.transparency, child: child)),
    );

Future<void> _capture(WidgetTester tester, double pixelRatio, String name) async {
  final boundary = _shotKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    final f = File('${Directory.systemTemp.path}/shots/$name.png');
    f.createSync(recursive: true);
    f.writeAsBytesSync(data!.buffer.asUint8List());
  });
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('mağaza görselleri', (tester) async {
    final c = hub.hubConfig;
    final s = AppServices(hubId: c.hubId, backend: MemoryBackend(), ads: NoAdsService(), purchases: NoPurchaseService());
    await s.load();
    await s.setConsent(false);
    const only = String.fromEnvironment('LANGS');
    final langs = only.isEmpty ? Strings.languages : only.split(',');

    // Ekranları hatasız çizilen ilk üç aracı seç (önce öncelikli liste).
    final candidates = <AppTool>[
      for (final id in _preferred) if (c.tool(id) != null) c.tool(id)!,
      for (final id in c.featured) if (c.tool(id) != null && !_preferred.contains(id)) c.tool(id)!,
    ];
    final tools = <AppTool>[];
    await s.setLanguage('tr');
    for (final t in candidates) {
      if (tools.length == 3) break;
      await tester.pumpWidget(_app(s, 'tr', AppToolPage(config: c, tool: t, services: s, lang: 'tr')));
      await _settle(tester);
      final e = tester.takeException();
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      if (e == null) {
        tools.add(t);
      } else {
        debugPrint('atlandı: ${t.id}: $e');
      }
    }
    debugPrint('araçlar: ${tools.map((t) => t.id).join(', ')}');

    var count = 0;
    for (final lang in langs) {
      await s.setLanguage(lang);
      final rtl = Strings(lang).rtl;
      for (final target in _targets) {
        final screens = <(String, Widget)>[
          (c.localized(c.tagline, lang), AppHubShell(config: c, services: s, lang: lang)),
          for (final t in tools)
            (c.localized(t.tagline, lang), AppToolPage(config: c, tool: t, services: s, lang: lang)),
        ];
        for (var k = 0; k < screens.length; k++) {
          final (caption, screen) = screens[k];
          await tester.pumpWidget(_app(
            s,
            lang,
            _offscreen(_frame(
              t: target,
              caption: caption,
              rtl: rtl,
              screen: KeyedSubtree(key: ValueKey('$lang-${target.name}-$k'), child: screen),
            )),
          ));
          await _settle(tester);
          tester.takeException();
          await _capture(tester, target.ratio, '${target.name}_${lang}_${k + 1}');
          count++;
        }
      }
      await tester.pumpWidget(_app(s, lang, _offscreen(_feature(lang))));
      await tester.pump(const Duration(milliseconds: 300));
      await _capture(tester, 2, 'feature_$lang');
      count++;
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    }
    binding.reportData = {'count': count, 'tools': tools.map((t) => t.id).toList()};
  }, timeout: const Timeout(Duration(minutes: 40)));
}
