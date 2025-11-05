// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get helloWorld => '¡Hola Mundo!';

  @override
  String get unread => 'Unread';

  @override
  String get search => 'Search';

  @override
  String get settings => 'Settings';

  @override
  String get toggleSortingAsc => 'Toggle sort order (currently oldest first)';

  @override
  String get toggleSortingDesc => 'Toggle sort order (currently newest first)';

  @override
  String unreadTitle(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return 'Unread ($countString)';
  }

  @override
  String get loginTitle => 'Login';

  @override
  String get apiUrlLabel => 'API URL';

  @override
  String get errEmptyValue => 'Please enter a value';

  @override
  String get errInvalidURL => 'Please enter a valid URL';

  @override
  String get loginButton => 'Login';

  @override
  String get authFailedNoToken => 'Authentication failed: No token received';

  @override
  String authFailedMessage(String error) {
    return 'Authentication failed: $error';
  }

  @override
  String get filterTooltip => 'Filter';

  @override
  String get preferences => 'Preferences';

  @override
  String get theme => 'Theme';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get acknowledgements => 'Acknowledgements';

  @override
  String get cancel => 'Cancel';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get systemDefault => 'System Default';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get logout => 'Logout';

  @override
  String get notAuthenticated => 'Not authenticated';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get copiedServerUrl => 'Copied server url to clipboard';

  @override
  String get cancelSelection => 'Cancel selection';

  @override
  String itemsSelected(int count) {
    return '$count items';
  }

  @override
  String deleteItemsPrompt(int count) {
    return 'Delete $count links permanently?';
  }

  @override
  String get deletePermanentWarning =>
      'This is permanent and cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get moreActions => 'More actions';

  @override
  String get archive => 'Archive';

  @override
  String get all => 'All';

  @override
  String get archived => 'Archived';

  @override
  String get notArchived => 'Not Archived';

  @override
  String get favorite => 'Favorite';

  @override
  String get favorited => 'Favorited';

  @override
  String get notFavorited => 'Not Favorited';

  @override
  String get order => 'Order';

  @override
  String get newestFirst => 'Newest First';

  @override
  String get oldestFirst => 'Oldest First';

  @override
  String get loading => 'Loading...';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get helloWorld => '¡Hola Mundo!';
}
