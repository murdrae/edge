// The app's localization delegates. Use this list, NOT the generated
// `AppLocalizations.localizationsDelegates`.
//
// Flutter's gen-l10n template (as of 3.50) still fills that generated list
// with flutter_localizations' GlobalMaterialLocalizations /
// GlobalCupertinoLocalizations. Those load the SDK's deprecated
// MaterialLocalizations / CupertinoLocalizations types, which are different
// classes from the ones material_ui / cupertino_ui widgets look up. With the
// generated list, a non-English locale has no MaterialLocalizations at all and
// every MaterialLocalizations.of (date/time pickers, tooltips, the clock
// formatter in app.dart) throws — test/l10n_delegates_test.dart pins this.
import 'package:material_ui/material_ui.dart';

import 'app_localizations.dart';

const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates = [
  AppLocalizations.delegate,
  // material_ui's: its own GlobalMaterialLocalizations, cupertino_ui's
  // GlobalCupertinoLocalizations, and flutter_localizations'
  // GlobalWidgetsLocalizations (text direction), in that package's order.
  ...GlobalMaterialLocalizations.delegates,
];
