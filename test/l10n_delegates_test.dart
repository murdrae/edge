// The app's localization delegates must load material_ui / cupertino_ui's
// localizations. The generated `AppLocalizations.localizationsDelegates` loads
// flutter_localizations' deprecated SDK types instead, which material_ui
// widgets never look up — so in any non-English locale there is no
// MaterialLocalizations at all, and every MaterialLocalizations.of (pickers,
// tooltips, the clock formatter) throws. See lib/l10n/delegates.dart.
import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoLocalizations;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openstrap_edge/l10n/app_localizations.dart';
import 'package:openstrap_edge/l10n/delegates.dart';

Future<BuildContext> _pump(
    WidgetTester t, List<LocalizationsDelegate<dynamic>> delegates) async {
  late BuildContext ctx;
  await t.pumpWidget(MaterialApp(
    locale: const Locale('de'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: delegates,
    home: Builder(builder: (c) {
      ctx = c;
      return const SizedBox();
    }),
  ));
  return ctx;
}

void main() {
  testWidgets('appLocalizationsDelegates localize Material and Cupertino',
      (t) async {
    final c = await _pump(t, appLocalizationsDelegates);
    expect(MaterialLocalizations.of(c).backButtonTooltip, 'Zurück');
    expect(CupertinoLocalizations.of(c).cutButtonLabel, 'Ausschneiden');
    expect(AppLocalizations.of(c)!.localeName, 'de');
  });

  // Positive control: the generated list is what this file exists to avoid.
  // If gen-l10n starts emitting material_ui's delegates this fails — then the
  // generated list is fine to use again and lib/l10n/delegates.dart can go.
  testWidgets('the generated delegate list leaves de without Material',
      (t) async {
    final c = await _pump(t, AppLocalizations.localizationsDelegates);
    // The "locale is not supported by all of its delegates" warning.
    expect(t.takeException(), isNotNull);
    expect(Localizations.of<MaterialLocalizations>(c, MaterialLocalizations),
        isNull);
  });

  test('no hand-written code uses the generated delegate list', () {
    final offenders = [
      for (final dir in ['lib', 'test'])
        for (final f in Directory(dir).listSync(recursive: true))
          if (f is File &&
              f.path.endsWith('.dart') &&
              !f.path.contains('app_localizations') &&
              f.path != 'lib/l10n/delegates.dart' &&
              f.path != 'test/l10n_delegates_test.dart' &&
              f.readAsStringSync().contains(
                  'AppLocalizations.localizationsDelegates'))
            f.path,
    ];
    expect(offenders, isEmpty);
  });
}
