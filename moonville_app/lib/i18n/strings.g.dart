
/*
 * Generated file. Do not edit.
 *
 * Locales: 2
 * Strings: 230 (115.0 per locale)
 *
 * Built on 2022-05-19 at 14:45 UTC
 */

import 'package:flutter/widgets.dart';

const AppLocale _baseLocale = AppLocale.en;
AppLocale _currLocale = _baseLocale;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale {
	en, // 'en' (base locale, fallback)
	th, // 'th'
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
_StringsEn _t = _currLocale.translations;
_StringsEn get t => _t;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class Translations {
	Translations._(); // no constructor

	static _StringsEn of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw 'Please wrap your app with "TranslationProvider".';
		}
		return inheritedWidget.translations;
	}
}

class LocaleSettings {
	LocaleSettings._(); // no constructor

	/// Uses locale of the device, fallbacks to base locale.
	/// Returns the locale which has been set.
	static AppLocale useDeviceLocale() {
		final locale = AppLocaleUtils.findDeviceLocale();
		return setLocale(locale);
	}

	/// Sets locale
	/// Returns the locale which has been set.
	static AppLocale setLocale(AppLocale locale) {
		_currLocale = locale;
		_t = _currLocale.translations;

		if (WidgetsBinding.instance != null) {
			// force rebuild if TranslationProvider is used
			_translationProviderKey.currentState?.setLocale(_currLocale);
		}

		return _currLocale;
	}

	/// Sets locale using string tag (e.g. en_US, de-DE, fr)
	/// Fallbacks to base locale.
	/// Returns the locale which has been set.
	static AppLocale setLocaleRaw(String rawLocale) {
		final locale = AppLocaleUtils.parse(rawLocale);
		return setLocale(locale);
	}

	/// Gets current locale.
	static AppLocale get currentLocale {
		return _currLocale;
	}

	/// Gets base locale.
	static AppLocale get baseLocale {
		return _baseLocale;
	}

	/// Gets supported locales in string format.
	static List<String> get supportedLocalesRaw {
		return AppLocale.values
			.map((locale) => locale.languageTag)
			.toList();
	}

	/// Gets supported locales (as Locale objects) with base locale sorted first.
	static List<Locale> get supportedLocales {
		return AppLocale.values
			.map((locale) => locale.flutterLocale)
			.toList();
	}
}

/// Provides utility functions without any side effects.
class AppLocaleUtils {
	AppLocaleUtils._(); // no constructor

	/// Returns the locale of the device as the enum type.
	/// Fallbacks to base locale.
	static AppLocale findDeviceLocale() {
		final String? deviceLocale = WidgetsBinding.instance?.window.locale.toLanguageTag();
		if (deviceLocale != null) {
			final typedLocale = _selectLocale(deviceLocale);
			if (typedLocale != null) {
				return typedLocale;
			}
		}
		return _baseLocale;
	}

	/// Returns the enum type of the raw locale.
	/// Fallbacks to base locale.
	static AppLocale parse(String rawLocale) {
		return _selectLocale(rawLocale) ?? _baseLocale;
	}
}

// context enums

// interfaces generated as mixins

// translation instances

late _StringsEn _translationsEn = _StringsEn.build();
late _StringsTh _translationsTh = _StringsTh.build();

// extensions for AppLocale

extension AppLocaleExtensions on AppLocale {

	/// Gets the translation instance managed by this library.
	/// [TranslationProvider] is using this instance.
	/// The plural resolvers are set via [LocaleSettings].
	_StringsEn get translations {
		switch (this) {
			case AppLocale.en: return _translationsEn;
			case AppLocale.th: return _translationsTh;
		}
	}

	/// Gets a new translation instance.
	/// [LocaleSettings] has no effect here.
	/// Suitable for dependency injection and unit tests.
	///
	/// Usage:
	/// final t = AppLocale.en.build(); // build
	/// String a = t.my.path; // access
	_StringsEn build() {
		switch (this) {
			case AppLocale.en: return _StringsEn.build();
			case AppLocale.th: return _StringsTh.build();
		}
	}

	String get languageTag {
		switch (this) {
			case AppLocale.en: return 'en';
			case AppLocale.th: return 'th';
		}
	}

	Locale get flutterLocale {
		switch (this) {
			case AppLocale.en: return const Locale.fromSubtags(languageCode: 'en');
			case AppLocale.th: return const Locale.fromSubtags(languageCode: 'th');
		}
	}
}

extension StringAppLocaleExtensions on String {
	AppLocale? toAppLocale() {
		switch (this) {
			case 'en': return AppLocale.en;
			case 'th': return AppLocale.th;
			default: return null;
		}
	}
}

// wrappers

GlobalKey<_TranslationProviderState> _translationProviderKey = GlobalKey<_TranslationProviderState>();

class TranslationProvider extends StatefulWidget {
	TranslationProvider({required this.child}) : super(key: _translationProviderKey);

	final Widget child;

	@override
	_TranslationProviderState createState() => _TranslationProviderState();

	static _InheritedLocaleData of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw 'Please wrap your app with "TranslationProvider".';
		}
		return inheritedWidget;
	}
}

class _TranslationProviderState extends State<TranslationProvider> {
	AppLocale locale = _currLocale;

	void setLocale(AppLocale newLocale) {
		setState(() {
			locale = newLocale;
		});
	}

	@override
	Widget build(BuildContext context) {
		return _InheritedLocaleData(
			locale: locale,
			child: widget.child,
		);
	}
}

class _InheritedLocaleData extends InheritedWidget {
	final AppLocale locale;
	Locale get flutterLocale => locale.flutterLocale; // shortcut
	final _StringsEn translations; // store translations to avoid switch call

	_InheritedLocaleData({required this.locale, required Widget child})
		: translations = locale.translations, super(child: child);

	@override
	bool updateShouldNotify(_InheritedLocaleData oldWidget) {
		return oldWidget.locale != locale;
	}
}

// pluralization feature not used

// helpers

final _localeRegex = RegExp(r'^([a-z]{2,8})?([_-]([A-Za-z]{4}))?([_-]?([A-Z]{2}|[0-9]{3}))?$');
AppLocale? _selectLocale(String localeRaw) {
	final match = _localeRegex.firstMatch(localeRaw);
	AppLocale? selected;
	if (match != null) {
		final language = match.group(1);
		final country = match.group(5);

		// match exactly
		selected = AppLocale.values
			.cast<AppLocale?>()
			.firstWhere((supported) => supported?.languageTag == localeRaw.replaceAll('_', '-'), orElse: () => null);

		if (selected == null && language != null) {
			// match language
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.startsWith(language) == true, orElse: () => null);
		}

		if (selected == null && country != null) {
			// match country
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.contains(country) == true, orElse: () => null);
		}
	}
	return selected;
}

// translations

// Path: <root>
class _StringsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEn.build();

	/// Access flat map
	dynamic operator[](String key) => _flatMap[key];

	// Internal flat map initialized lazily
	late final Map<String, dynamic> _flatMap = _buildFlatMap();

	// ignore: unused_field
	late final _StringsEn _root = this;

	// Translations
	String get app => 'Moonville';
	late final _StringsSwitchLocaleEn switchLocale = _StringsSwitchLocaleEn._(_root);
	late final _StringsCommonEn common = _StringsCommonEn._(_root);
	late final _StringsQuestionEn question = _StringsQuestionEn._(_root);
	late final _StringsValidatorEn validator = _StringsValidatorEn._(_root);
	late final _StringsMessageBoxEn messageBox = _StringsMessageBoxEn._(_root);
	late final _StringsWaitBoxEn waitBox = _StringsWaitBoxEn._(_root);
	late final _StringsServiceRunnerEn serviceRunner = _StringsServiceRunnerEn._(_root);
	late final _StringsImageChooserEn imageChooser = _StringsImageChooserEn._(_root);
	late final _StringsSearchBarEn searchBar = _StringsSearchBarEn._(_root);
	late final _StringsPaginatorEn paginator = _StringsPaginatorEn._(_root);
	late final _StringsAppBarEn appBar = _StringsAppBarEn._(_root);
	late final _StringsDrawerUiEn drawerUi = _StringsDrawerUiEn._(_root);
	late final _StringsBeginPageEn beginPage = _StringsBeginPageEn._(_root);
	late final _StringsSignUpPageEn signUpPage = _StringsSignUpPageEn._(_root);
	late final _StringsForgotPasswordPageEn forgotPasswordPage = _StringsForgotPasswordPageEn._(_root);
	late final _StringsDashboardPageEn dashboardPage = _StringsDashboardPageEn._(_root);
	late final _StringsChangeIconPageEn changeIconPage = _StringsChangeIconPageEn._(_root);
	late final _StringsChangeNamePageEn changeNamePage = _StringsChangeNamePageEn._(_root);
	late final _StringsChangePasswordPageEn changePasswordPage = _StringsChangePasswordPageEn._(_root);
	late final _StringsAccountsPageEn accountsPage = _StringsAccountsPageEn._(_root);
	late final _StringsAccountEditPageEn accountEditPage = _StringsAccountEditPageEn._(_root);
	late final _StringsSettingsPageEn settingsPage = _StringsSettingsPageEn._(_root);
}

// Path: switchLocale
class _StringsSwitchLocaleEn {
	_StringsSwitchLocaleEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get en => 'Change Language to English';
	String get th => 'Change Language to ไทย';
}

// Path: common
class _StringsCommonEn {
	_StringsCommonEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get close => 'Close';
	String get ok => 'OK';
	String get cancel => 'Cancel';
	String get yes => 'Yes';
	String get no => 'No';
	String get retry => 'Retry';
	String get name => 'Name';
	String get value => 'Value';
	String get create => 'Create';
	String get createMore => 'Create...';
	String get update => 'Save';
	String get updateMore => 'Save...';
	String get remove => 'Delete';
	String get removeMore => 'Delete...';
}

// Path: question
class _StringsQuestionEn {
	_StringsQuestionEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get areYouSureToExit => 'Are you sure to exit this program?';
	String get areYouSureToDelete => 'Are you sure to delete this item?';
	String get areYouSureToLeave => 'Are you sure to leave without save data?';
}

// Path: validator
class _StringsValidatorEn {
	_StringsValidatorEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String isMinInt({required Object min}) => 'Please input as integer, minimum >= $min.';
	String isMaxInt({required Object max}) => 'Please input as integer, maximum <= $max.';
	String get isPositiveInt => 'Please input as positive integer.';
	String get isPositiveOrZeroInt => 'Please input as positive integer or zero.';
	String get isNegativeInt => 'Please input as negative integer.';
	String get isNegativeOrZeroInt => 'Please input as negative integer or zero.';
	String isMinFloat({required Object min}) => 'Please input as floating-point, minimum >= $min.';
	String isMaxFloat({required Object max}) => 'Please input as floating-point, maximum <= $max.';
	String get isPositiveFloat => 'Please input as positive floating-point.';
	String get isPositiveOrZeroFloat => 'Please input as positive floating-point or zero.';
	String get isNegativeFloat => 'Please input as negative floating-point.';
	String get isNegativeOrZeroFloat => 'Please input as negative floating-point or zero.';
	String get isMoney => 'Please input as money.';
	String isMinLength({required Object min}) => 'Please input length >= $min.';
	String isMaxLength({required Object max}) => 'Please input length <= $max.';
	String get isEmail => 'Please input as email.';
	String get isSamePasswords => 'Password and confirm password must be equal.';
}

// Path: messageBox
class _StringsMessageBoxEn {
	_StringsMessageBoxEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get info => 'Information';
	String get warning => 'Warning';
	String get error => 'Error';
	String get question => 'Question';
}

// Path: waitBox
class _StringsWaitBoxEn {
	_StringsWaitBoxEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get message => 'Please wait...';
}

// Path: serviceRunner
class _StringsServiceRunnerEn {
	_StringsServiceRunnerEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get message => 'Network error!';
}

// Path: imageChooser
class _StringsImageChooserEn {
	_StringsImageChooserEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get upload => 'Upload';
	String get reset => 'Reset';
	String get revert => 'Revert';
}

// Path: searchBar
class _StringsSearchBarEn {
	_StringsSearchBarEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get open => 'Open search...';
	String get hint => 'Search...';
}

// Path: paginator
class _StringsPaginatorEn {
	_StringsPaginatorEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get first => 'Go to first page.';
	String get previous => 'Go to previous page.';
	String get next => 'Go to next page.';
	String get last => 'Go to last page.';
	String get go => 'Go';
}

// Path: appBar
class _StringsAppBarEn {
	_StringsAppBarEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get changeIcon => 'Change Icon';
	String get changeName => 'Change Name';
	String get changePassword => 'Change Password';
	String get exit => 'Exit';
}

// Path: drawerUi
class _StringsDrawerUiEn {
	_StringsDrawerUiEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get title => 'Hello';
	String get home => 'Home';
	String get accounts => 'Accounts';
	String get settings => 'Settings';
	String get exit => 'Exit';
}

// Path: beginPage
class _StringsBeginPageEn {
	_StringsBeginPageEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get title => 'Moonville';
	String get email => 'Email';
	String get password => 'Password';
	String get remember => 'Remember Login';
	String get forgotPassword => 'Forgot password?';
	String get ok => 'Login';
	String get or => '- or -';
	String get signUp => 'Sign Up';
}

// Path: signUpPage
class _StringsSignUpPageEn {
	_StringsSignUpPageEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get title => 'Sign Up';
	String get email => 'Email';
	String get password => 'Password';
	String get confirmPassword => 'Confirm Password';
	String get ok => 'Register';
	String get confirm => 'Please confirm the signup by email!';
}

// Path: forgotPasswordPage
class _StringsForgotPasswordPageEn {
	_StringsForgotPasswordPageEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get title => 'Forgot Password';
	String get email => 'Email';
	String get ok => 'Send Email';
	String get check => 'Please check email for your instruction!';
}

// Path: dashboardPage
class _StringsDashboardPageEn {
	_StringsDashboardPageEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get title => 'Dashboard';
	String get role => 'Role';
	String get name => 'Name';
	String get locale => 'Locale';
	String get signup => 'Signup';
}

// Path: changeIconPage
class _StringsChangeIconPageEn {
	_StringsChangeIconPageEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get title => 'Change Icon';
	String get icon => 'Current Icon';
	String get ok => 'Change Icon';
}

// Path: changeNamePage
class _StringsChangeNamePageEn {
	_StringsChangeNamePageEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get title => 'Change Current Name';
	String get name => 'Current Name';
	String get ok => 'Change Name';
}

// Path: changePasswordPage
class _StringsChangePasswordPageEn {
	_StringsChangePasswordPageEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get title => 'Change Current Password';
	String get password => 'Password';
	String get confirmPassword => 'Confirm Password';
	String get ok => 'Change Password';
	String get confirm => 'You have to logout, then login again with new password!';
}

// Path: accountsPage
class _StringsAccountsPageEn {
	_StringsAccountsPageEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get title => 'Accounts';
	late final _StringsAccountsPageSortByEn sortBy = _StringsAccountsPageSortByEn._(_root);
	String get trash => 'Resigned';
}

// Path: accountEditPage
class _StringsAccountEditPageEn {
	_StringsAccountEditPageEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String title({required Object name}) => 'Edit $name';
	String get role => 'Role';
	String get name => 'Name';
	String get locale => 'Locale';
	String get disabled => 'Disabled';
	String get resigned => 'Resigned';
	String get signup => 'Signup';
	String get disable => 'Disable';
	String get ok => 'Save';
}

// Path: settingsPage
class _StringsSettingsPageEn {
	_StringsSettingsPageEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get title => 'Settings';
	String get locale => 'Change Locale';
	String get color => 'Change Color Theme';
}

// Path: accountsPage.sortBy
class _StringsAccountsPageSortByEn {
	_StringsAccountsPageSortByEn._(this._root);

	// ignore: unused_field
	final _StringsEn _root;

	// Translations
	String get id => 'Id';
	String get emailAsc => 'Email ASC';
	String get emailDesc => 'Email DESC';
	String get signUpAsc => 'Signup ASC';
	String get signUpDesc => 'Signup DESC';
}

// Path: <root>
class _StringsTh implements _StringsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsTh.build();

	/// Access flat map
	@override dynamic operator[](String key) => _flatMap[key];

	// Internal flat map initialized lazily
	late final Map<String, dynamic> _flatMap = _buildFlatMap();

	// ignore: unused_field
	@override late final _StringsTh _root = this;

	// Translations
	@override String get app => 'หมู่บ้านพระจันทร์';
	@override late final _StringsSwitchLocaleTh switchLocale = _StringsSwitchLocaleTh._(_root);
	@override late final _StringsCommonTh common = _StringsCommonTh._(_root);
	@override late final _StringsQuestionTh question = _StringsQuestionTh._(_root);
	@override late final _StringsValidatorTh validator = _StringsValidatorTh._(_root);
	@override late final _StringsMessageBoxTh messageBox = _StringsMessageBoxTh._(_root);
	@override late final _StringsWaitBoxTh waitBox = _StringsWaitBoxTh._(_root);
	@override late final _StringsServiceRunnerTh serviceRunner = _StringsServiceRunnerTh._(_root);
	@override late final _StringsImageChooserTh imageChooser = _StringsImageChooserTh._(_root);
	@override late final _StringsSearchBarTh searchBar = _StringsSearchBarTh._(_root);
	@override late final _StringsPaginatorTh paginator = _StringsPaginatorTh._(_root);
	@override late final _StringsAppBarTh appBar = _StringsAppBarTh._(_root);
	@override late final _StringsDrawerUiTh drawerUi = _StringsDrawerUiTh._(_root);
	@override late final _StringsBeginPageTh beginPage = _StringsBeginPageTh._(_root);
	@override late final _StringsSignUpPageTh signUpPage = _StringsSignUpPageTh._(_root);
	@override late final _StringsForgotPasswordPageTh forgotPasswordPage = _StringsForgotPasswordPageTh._(_root);
	@override late final _StringsDashboardPageTh dashboardPage = _StringsDashboardPageTh._(_root);
	@override late final _StringsChangeIconPageTh changeIconPage = _StringsChangeIconPageTh._(_root);
	@override late final _StringsChangeNamePageTh changeNamePage = _StringsChangeNamePageTh._(_root);
	@override late final _StringsChangePasswordPageTh changePasswordPage = _StringsChangePasswordPageTh._(_root);
	@override late final _StringsAccountsPageTh accountsPage = _StringsAccountsPageTh._(_root);
	@override late final _StringsAccountEditPageTh accountEditPage = _StringsAccountEditPageTh._(_root);
	@override late final _StringsSettingsPageTh settingsPage = _StringsSettingsPageTh._(_root);
}

// Path: switchLocale
class _StringsSwitchLocaleTh implements _StringsSwitchLocaleEn {
	_StringsSwitchLocaleTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get en => 'สลับภาษาเป็น English';
	@override String get th => 'สลับภาษาเป็น ไทย';
}

// Path: common
class _StringsCommonTh implements _StringsCommonEn {
	_StringsCommonTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get close => 'ปิด';
	@override String get ok => 'ตกลง';
	@override String get cancel => 'ยกเลิก';
	@override String get yes => 'ใช่';
	@override String get no => 'ไม่ใช่';
	@override String get retry => 'ลองใหม่';
	@override String get name => 'ชื่อ';
	@override String get value => 'ค่า';
	@override String get create => 'สร้าง';
	@override String get createMore => 'สร้าง...';
	@override String get update => 'บันทึก';
	@override String get updateMore => 'บันทึก...';
	@override String get remove => 'ลบ';
	@override String get removeMore => 'ลบ...';
}

// Path: question
class _StringsQuestionTh implements _StringsQuestionEn {
	_StringsQuestionTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get areYouSureToExit => 'คุณแน่ใจที่จะออกจากโปรแกรมนี้หรือไม่?';
	@override String get areYouSureToDelete => 'คุณแน่ใจที่จะลบข้อมูลนี้หรือไม่?';
	@override String get areYouSureToLeave => 'คุณแน่ใจที่จะออกจากหน้านี้โดยไม่เซฟข้อมูล?';
}

// Path: validator
class _StringsValidatorTh implements _StringsValidatorEn {
	_StringsValidatorTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String isMinInt({required Object min}) => 'กรอกข้อมูล เป็นเลขจำนวนเต็ม, อย่างน้อย >= $min.';
	@override String isMaxInt({required Object max}) => 'กรอกข้อมูล เป็นเลขจำนวนเต็ม, อย่างมาก <= $max.';
	@override String get isPositiveInt => 'กรอกข้อมูล เป็นเลขจำนวนเต็มบวก';
	@override String get isPositiveOrZeroInt => 'กรอกข้อมูล เป็นเลขจำนวนเต็มบวกหรือศูนย์';
	@override String get isNegativeInt => 'กรอกข้อมูล เป็นเลขจำนวนเต็มลบ';
	@override String get isNegativeOrZeroInt => 'กรอกข้อมูล เป็นเลขจำนวนเต็มลบหรือศูนย์';
	@override String isMinFloat({required Object min}) => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยม, อย่างน้อย >= $min.';
	@override String isMaxFloat({required Object max}) => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยม, อย่างมาก <= $max.';
	@override String get isPositiveFloat => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมบวก';
	@override String get isPositiveOrZeroFloat => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมบวกหรือศูนย์';
	@override String get isNegativeFloat => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมลบ';
	@override String get isNegativeOrZeroFloat => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมลบหรือศูนย์';
	@override String get isMoney => 'กรอกข้อมูล เป็นเลขจำนวนเงิน.';
	@override String isMinLength({required Object min}) => 'กรอกข้อมูล ความยาว >= $min';
	@override String isMaxLength({required Object max}) => 'กรอกข้อมูล ความยาว <= $max';
	@override String get isEmail => 'กรอกข้อมูล เป็นอีเมล';
	@override String get isSamePasswords => 'รหัสผ่าน และ ยืนยันรหัสผ่าน ต้องเหมือนกัน';
}

// Path: messageBox
class _StringsMessageBoxTh implements _StringsMessageBoxEn {
	_StringsMessageBoxTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get info => 'ข้อมูลข่าวสาร';
	@override String get warning => 'แจ้งเตือน';
	@override String get error => 'เกิดข้อผิดพลาด';
	@override String get question => 'คำถาม';
}

// Path: waitBox
class _StringsWaitBoxTh implements _StringsWaitBoxEn {
	_StringsWaitBoxTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get message => 'โปรดรอสักครู่...';
}

// Path: serviceRunner
class _StringsServiceRunnerTh implements _StringsServiceRunnerEn {
	_StringsServiceRunnerTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get message => 'เกิดข้อผิดพลาดบนเน็ตเวิร์ค!';
}

// Path: imageChooser
class _StringsImageChooserTh implements _StringsImageChooserEn {
	_StringsImageChooserTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get upload => 'อัพโหลด';
	@override String get reset => 'รีเซ็ต';
	@override String get revert => 'ย้อนกลับ';
}

// Path: searchBar
class _StringsSearchBarTh implements _StringsSearchBarEn {
	_StringsSearchBarTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get open => 'เปิดการค้นหา...';
	@override String get hint => 'ค้นหา...';
}

// Path: paginator
class _StringsPaginatorTh implements _StringsPaginatorEn {
	_StringsPaginatorTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get first => 'ไปยังหน้าแรก';
	@override String get previous => 'ไปยังหน้าที่แล้ว';
	@override String get next => 'ไปยังหน้าถัดไป';
	@override String get last => 'ไปยังหน้าสุดท้าย';
	@override String get go => 'ไป';
}

// Path: appBar
class _StringsAppBarTh implements _StringsAppBarEn {
	_StringsAppBarTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get changeIcon => 'เปลี่ยน Icon';
	@override String get changeName => 'เปลี่ยนชื่อ';
	@override String get changePassword => 'เปลี่ยนรหัสผ่าน';
	@override String get exit => 'ออกจากระบบ';
}

// Path: drawerUi
class _StringsDrawerUiTh implements _StringsDrawerUiEn {
	_StringsDrawerUiTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get title => 'สวัสดี';
	@override String get home => 'เริ่มต้น';
	@override String get accounts => 'บัญชีผู้ใช้';
	@override String get settings => 'การตั้งค่า';
	@override String get exit => 'ออกจากระบบ';
}

// Path: beginPage
class _StringsBeginPageTh implements _StringsBeginPageEn {
	_StringsBeginPageTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get title => 'หมู่บ้านพระจันทร์';
	@override String get email => 'อีเมล';
	@override String get password => 'รหัสผ่าน';
	@override String get remember => 'จำรหัสผ่าน';
	@override String get forgotPassword => 'ลืมรหัสผ่าน?';
	@override String get ok => 'เข้าสู่ระบบ';
	@override String get or => '- หรือ -';
	@override String get signUp => 'สมัครสมาชิก';
}

// Path: signUpPage
class _StringsSignUpPageTh implements _StringsSignUpPageEn {
	_StringsSignUpPageTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get title => 'สมัครสมาชิก';
	@override String get email => 'อีเมล';
	@override String get password => 'รหัสผ่าน';
	@override String get confirmPassword => 'ยืนยันรหัสผ่าน';
	@override String get ok => 'ลงทะเบียน';
	@override String get confirm => 'โปรดยืนยันการสมัครสมาชิกทางอีเมล!';
}

// Path: forgotPasswordPage
class _StringsForgotPasswordPageTh implements _StringsForgotPasswordPageEn {
	_StringsForgotPasswordPageTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get title => 'ลืมรหัสผ่าน';
	@override String get email => 'อีเมล';
	@override String get ok => 'ส่งอีเมล';
	@override String get check => 'โปรดเช็คอีเมลสำหรับคำแนะนำต่อไป!';
}

// Path: dashboardPage
class _StringsDashboardPageTh implements _StringsDashboardPageEn {
	_StringsDashboardPageTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get title => 'กระดานของคุณ';
	@override String get role => 'ประเภท';
	@override String get name => 'ชื่อ';
	@override String get locale => 'ภาษา';
	@override String get signup => 'สมัครสมาชิก';
}

// Path: changeIconPage
class _StringsChangeIconPageTh implements _StringsChangeIconPageEn {
	_StringsChangeIconPageTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get title => 'เปลี่ยนรูป Icon';
	@override String get icon => 'Icon ปัจจุบัน';
	@override String get ok => 'เปลี่ยนรูป Icon';
}

// Path: changeNamePage
class _StringsChangeNamePageTh implements _StringsChangeNamePageEn {
	_StringsChangeNamePageTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get title => 'เปลี่ยนชื่อ';
	@override String get name => 'ชื่อปัจจุบัน';
	@override String get ok => 'เปลี่ยนชื่อ';
}

// Path: changePasswordPage
class _StringsChangePasswordPageTh implements _StringsChangePasswordPageEn {
	_StringsChangePasswordPageTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get title => 'เปลี่ยนรหัสผ่าน';
	@override String get password => 'รหัสผ่าน';
	@override String get confirmPassword => 'ยืนยันรหัสผ่าน';
	@override String get ok => 'เปลี่ยนรหัสผ่าน';
	@override String get confirm => 'คุณต้องออกจากระบบ แล้วเข้าระบบใหม่ ด้วยรหัสผ่านใหม่!';
}

// Path: accountsPage
class _StringsAccountsPageTh implements _StringsAccountsPageEn {
	_StringsAccountsPageTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get title => 'บัญชีผู้ใช้';
	@override late final _StringsAccountsPageSortByTh sortBy = _StringsAccountsPageSortByTh._(_root);
	@override String get trash => 'ลาออกจากระบบ';
}

// Path: accountEditPage
class _StringsAccountEditPageTh implements _StringsAccountEditPageEn {
	_StringsAccountEditPageTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String title({required Object name}) => 'แก้ไข $name';
	@override String get role => 'ประเภท';
	@override String get name => 'ชื่อ';
	@override String get locale => 'ภาษา';
	@override String get disabled => 'ถูกปิดการทำงาน';
	@override String get resigned => 'ลาออกจากระบบ';
	@override String get signup => 'สมัครสมาชิก';
	@override String get disable => 'ปิดการทำงาน';
	@override String get ok => 'บันทึก';
}

// Path: settingsPage
class _StringsSettingsPageTh implements _StringsSettingsPageEn {
	_StringsSettingsPageTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get title => 'การตั้งค่า';
	@override String get locale => 'เปลี่ยนภาษา';
	@override String get color => 'เปลี่ยนธีมสี';
}

// Path: accountsPage.sortBy
class _StringsAccountsPageSortByTh implements _StringsAccountsPageSortByEn {
	_StringsAccountsPageSortByTh._(this._root);

	// ignore: unused_field
	@override final _StringsTh _root;

	// Translations
	@override String get id => 'Id';
	@override String get emailAsc => 'อีเมล น้อยไปมาก';
	@override String get emailDesc => 'อีเมล มากไปน้อย';
	@override String get signUpAsc => 'วันที่สมัคร น้อยไปมาก';
	@override String get signUpDesc => 'วันที่สมัคร มากไปน้อย';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on _StringsEn {
	Map<String, dynamic> _buildFlatMap() {
		return {
			'app': 'Moonville',
			'switchLocale.en': 'Change Language to English',
			'switchLocale.th': 'Change Language to ไทย',
			'common.close': 'Close',
			'common.ok': 'OK',
			'common.cancel': 'Cancel',
			'common.yes': 'Yes',
			'common.no': 'No',
			'common.retry': 'Retry',
			'common.name': 'Name',
			'common.value': 'Value',
			'common.create': 'Create',
			'common.createMore': 'Create...',
			'common.update': 'Save',
			'common.updateMore': 'Save...',
			'common.remove': 'Delete',
			'common.removeMore': 'Delete...',
			'question.areYouSureToExit': 'Are you sure to exit this program?',
			'question.areYouSureToDelete': 'Are you sure to delete this item?',
			'question.areYouSureToLeave': 'Are you sure to leave without save data?',
			'validator.isMinInt': ({required Object min}) => 'Please input as integer, minimum >= $min.',
			'validator.isMaxInt': ({required Object max}) => 'Please input as integer, maximum <= $max.',
			'validator.isPositiveInt': 'Please input as positive integer.',
			'validator.isPositiveOrZeroInt': 'Please input as positive integer or zero.',
			'validator.isNegativeInt': 'Please input as negative integer.',
			'validator.isNegativeOrZeroInt': 'Please input as negative integer or zero.',
			'validator.isMinFloat': ({required Object min}) => 'Please input as floating-point, minimum >= $min.',
			'validator.isMaxFloat': ({required Object max}) => 'Please input as floating-point, maximum <= $max.',
			'validator.isPositiveFloat': 'Please input as positive floating-point.',
			'validator.isPositiveOrZeroFloat': 'Please input as positive floating-point or zero.',
			'validator.isNegativeFloat': 'Please input as negative floating-point.',
			'validator.isNegativeOrZeroFloat': 'Please input as negative floating-point or zero.',
			'validator.isMoney': 'Please input as money.',
			'validator.isMinLength': ({required Object min}) => 'Please input length >= $min.',
			'validator.isMaxLength': ({required Object max}) => 'Please input length <= $max.',
			'validator.isEmail': 'Please input as email.',
			'validator.isSamePasswords': 'Password and confirm password must be equal.',
			'messageBox.info': 'Information',
			'messageBox.warning': 'Warning',
			'messageBox.error': 'Error',
			'messageBox.question': 'Question',
			'waitBox.message': 'Please wait...',
			'serviceRunner.message': 'Network error!',
			'imageChooser.upload': 'Upload',
			'imageChooser.reset': 'Reset',
			'imageChooser.revert': 'Revert',
			'searchBar.open': 'Open search...',
			'searchBar.hint': 'Search...',
			'paginator.first': 'Go to first page.',
			'paginator.previous': 'Go to previous page.',
			'paginator.next': 'Go to next page.',
			'paginator.last': 'Go to last page.',
			'paginator.go': 'Go',
			'appBar.changeIcon': 'Change Icon',
			'appBar.changeName': 'Change Name',
			'appBar.changePassword': 'Change Password',
			'appBar.exit': 'Exit',
			'drawerUi.title': 'Hello',
			'drawerUi.home': 'Home',
			'drawerUi.accounts': 'Accounts',
			'drawerUi.settings': 'Settings',
			'drawerUi.exit': 'Exit',
			'beginPage.title': 'Moonville',
			'beginPage.email': 'Email',
			'beginPage.password': 'Password',
			'beginPage.remember': 'Remember Login',
			'beginPage.forgotPassword': 'Forgot password?',
			'beginPage.ok': 'Login',
			'beginPage.or': '- or -',
			'beginPage.signUp': 'Sign Up',
			'signUpPage.title': 'Sign Up',
			'signUpPage.email': 'Email',
			'signUpPage.password': 'Password',
			'signUpPage.confirmPassword': 'Confirm Password',
			'signUpPage.ok': 'Register',
			'signUpPage.confirm': 'Please confirm the signup by email!',
			'forgotPasswordPage.title': 'Forgot Password',
			'forgotPasswordPage.email': 'Email',
			'forgotPasswordPage.ok': 'Send Email',
			'forgotPasswordPage.check': 'Please check email for your instruction!',
			'dashboardPage.title': 'Dashboard',
			'dashboardPage.role': 'Role',
			'dashboardPage.name': 'Name',
			'dashboardPage.locale': 'Locale',
			'dashboardPage.signup': 'Signup',
			'changeIconPage.title': 'Change Icon',
			'changeIconPage.icon': 'Current Icon',
			'changeIconPage.ok': 'Change Icon',
			'changeNamePage.title': 'Change Current Name',
			'changeNamePage.name': 'Current Name',
			'changeNamePage.ok': 'Change Name',
			'changePasswordPage.title': 'Change Current Password',
			'changePasswordPage.password': 'Password',
			'changePasswordPage.confirmPassword': 'Confirm Password',
			'changePasswordPage.ok': 'Change Password',
			'changePasswordPage.confirm': 'You have to logout, then login again with new password!',
			'accountsPage.title': 'Accounts',
			'accountsPage.sortBy.id': 'Id',
			'accountsPage.sortBy.emailAsc': 'Email ASC',
			'accountsPage.sortBy.emailDesc': 'Email DESC',
			'accountsPage.sortBy.signUpAsc': 'Signup ASC',
			'accountsPage.sortBy.signUpDesc': 'Signup DESC',
			'accountsPage.trash': 'Resigned',
			'accountEditPage.title': ({required Object name}) => 'Edit $name',
			'accountEditPage.role': 'Role',
			'accountEditPage.name': 'Name',
			'accountEditPage.locale': 'Locale',
			'accountEditPage.disabled': 'Disabled',
			'accountEditPage.resigned': 'Resigned',
			'accountEditPage.signup': 'Signup',
			'accountEditPage.disable': 'Disable',
			'accountEditPage.ok': 'Save',
			'settingsPage.title': 'Settings',
			'settingsPage.locale': 'Change Locale',
			'settingsPage.color': 'Change Color Theme',
		};
	}
}

extension on _StringsTh {
	Map<String, dynamic> _buildFlatMap() {
		return {
			'app': 'หมู่บ้านพระจันทร์',
			'switchLocale.en': 'สลับภาษาเป็น English',
			'switchLocale.th': 'สลับภาษาเป็น ไทย',
			'common.close': 'ปิด',
			'common.ok': 'ตกลง',
			'common.cancel': 'ยกเลิก',
			'common.yes': 'ใช่',
			'common.no': 'ไม่ใช่',
			'common.retry': 'ลองใหม่',
			'common.name': 'ชื่อ',
			'common.value': 'ค่า',
			'common.create': 'สร้าง',
			'common.createMore': 'สร้าง...',
			'common.update': 'บันทึก',
			'common.updateMore': 'บันทึก...',
			'common.remove': 'ลบ',
			'common.removeMore': 'ลบ...',
			'question.areYouSureToExit': 'คุณแน่ใจที่จะออกจากโปรแกรมนี้หรือไม่?',
			'question.areYouSureToDelete': 'คุณแน่ใจที่จะลบข้อมูลนี้หรือไม่?',
			'question.areYouSureToLeave': 'คุณแน่ใจที่จะออกจากหน้านี้โดยไม่เซฟข้อมูล?',
			'validator.isMinInt': ({required Object min}) => 'กรอกข้อมูล เป็นเลขจำนวนเต็ม, อย่างน้อย >= $min.',
			'validator.isMaxInt': ({required Object max}) => 'กรอกข้อมูล เป็นเลขจำนวนเต็ม, อย่างมาก <= $max.',
			'validator.isPositiveInt': 'กรอกข้อมูล เป็นเลขจำนวนเต็มบวก',
			'validator.isPositiveOrZeroInt': 'กรอกข้อมูล เป็นเลขจำนวนเต็มบวกหรือศูนย์',
			'validator.isNegativeInt': 'กรอกข้อมูล เป็นเลขจำนวนเต็มลบ',
			'validator.isNegativeOrZeroInt': 'กรอกข้อมูล เป็นเลขจำนวนเต็มลบหรือศูนย์',
			'validator.isMinFloat': ({required Object min}) => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยม, อย่างน้อย >= $min.',
			'validator.isMaxFloat': ({required Object max}) => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยม, อย่างมาก <= $max.',
			'validator.isPositiveFloat': 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมบวก',
			'validator.isPositiveOrZeroFloat': 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมบวกหรือศูนย์',
			'validator.isNegativeFloat': 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมลบ',
			'validator.isNegativeOrZeroFloat': 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมลบหรือศูนย์',
			'validator.isMoney': 'กรอกข้อมูล เป็นเลขจำนวนเงิน.',
			'validator.isMinLength': ({required Object min}) => 'กรอกข้อมูล ความยาว >= $min',
			'validator.isMaxLength': ({required Object max}) => 'กรอกข้อมูล ความยาว <= $max',
			'validator.isEmail': 'กรอกข้อมูล เป็นอีเมล',
			'validator.isSamePasswords': 'รหัสผ่าน และ ยืนยันรหัสผ่าน ต้องเหมือนกัน',
			'messageBox.info': 'ข้อมูลข่าวสาร',
			'messageBox.warning': 'แจ้งเตือน',
			'messageBox.error': 'เกิดข้อผิดพลาด',
			'messageBox.question': 'คำถาม',
			'waitBox.message': 'โปรดรอสักครู่...',
			'serviceRunner.message': 'เกิดข้อผิดพลาดบนเน็ตเวิร์ค!',
			'imageChooser.upload': 'อัพโหลด',
			'imageChooser.reset': 'รีเซ็ต',
			'imageChooser.revert': 'ย้อนกลับ',
			'searchBar.open': 'เปิดการค้นหา...',
			'searchBar.hint': 'ค้นหา...',
			'paginator.first': 'ไปยังหน้าแรก',
			'paginator.previous': 'ไปยังหน้าที่แล้ว',
			'paginator.next': 'ไปยังหน้าถัดไป',
			'paginator.last': 'ไปยังหน้าสุดท้าย',
			'paginator.go': 'ไป',
			'appBar.changeIcon': 'เปลี่ยน Icon',
			'appBar.changeName': 'เปลี่ยนชื่อ',
			'appBar.changePassword': 'เปลี่ยนรหัสผ่าน',
			'appBar.exit': 'ออกจากระบบ',
			'drawerUi.title': 'สวัสดี',
			'drawerUi.home': 'เริ่มต้น',
			'drawerUi.accounts': 'บัญชีผู้ใช้',
			'drawerUi.settings': 'การตั้งค่า',
			'drawerUi.exit': 'ออกจากระบบ',
			'beginPage.title': 'หมู่บ้านพระจันทร์',
			'beginPage.email': 'อีเมล',
			'beginPage.password': 'รหัสผ่าน',
			'beginPage.remember': 'จำรหัสผ่าน',
			'beginPage.forgotPassword': 'ลืมรหัสผ่าน?',
			'beginPage.ok': 'เข้าสู่ระบบ',
			'beginPage.or': '- หรือ -',
			'beginPage.signUp': 'สมัครสมาชิก',
			'signUpPage.title': 'สมัครสมาชิก',
			'signUpPage.email': 'อีเมล',
			'signUpPage.password': 'รหัสผ่าน',
			'signUpPage.confirmPassword': 'ยืนยันรหัสผ่าน',
			'signUpPage.ok': 'ลงทะเบียน',
			'signUpPage.confirm': 'โปรดยืนยันการสมัครสมาชิกทางอีเมล!',
			'forgotPasswordPage.title': 'ลืมรหัสผ่าน',
			'forgotPasswordPage.email': 'อีเมล',
			'forgotPasswordPage.ok': 'ส่งอีเมล',
			'forgotPasswordPage.check': 'โปรดเช็คอีเมลสำหรับคำแนะนำต่อไป!',
			'dashboardPage.title': 'กระดานของคุณ',
			'dashboardPage.role': 'ประเภท',
			'dashboardPage.name': 'ชื่อ',
			'dashboardPage.locale': 'ภาษา',
			'dashboardPage.signup': 'สมัครสมาชิก',
			'changeIconPage.title': 'เปลี่ยนรูป Icon',
			'changeIconPage.icon': 'Icon ปัจจุบัน',
			'changeIconPage.ok': 'เปลี่ยนรูป Icon',
			'changeNamePage.title': 'เปลี่ยนชื่อ',
			'changeNamePage.name': 'ชื่อปัจจุบัน',
			'changeNamePage.ok': 'เปลี่ยนชื่อ',
			'changePasswordPage.title': 'เปลี่ยนรหัสผ่าน',
			'changePasswordPage.password': 'รหัสผ่าน',
			'changePasswordPage.confirmPassword': 'ยืนยันรหัสผ่าน',
			'changePasswordPage.ok': 'เปลี่ยนรหัสผ่าน',
			'changePasswordPage.confirm': 'คุณต้องออกจากระบบ แล้วเข้าระบบใหม่ ด้วยรหัสผ่านใหม่!',
			'accountsPage.title': 'บัญชีผู้ใช้',
			'accountsPage.sortBy.id': 'Id',
			'accountsPage.sortBy.emailAsc': 'อีเมล น้อยไปมาก',
			'accountsPage.sortBy.emailDesc': 'อีเมล มากไปน้อย',
			'accountsPage.sortBy.signUpAsc': 'วันที่สมัคร น้อยไปมาก',
			'accountsPage.sortBy.signUpDesc': 'วันที่สมัคร มากไปน้อย',
			'accountsPage.trash': 'ลาออกจากระบบ',
			'accountEditPage.title': ({required Object name}) => 'แก้ไข $name',
			'accountEditPage.role': 'ประเภท',
			'accountEditPage.name': 'ชื่อ',
			'accountEditPage.locale': 'ภาษา',
			'accountEditPage.disabled': 'ถูกปิดการทำงาน',
			'accountEditPage.resigned': 'ลาออกจากระบบ',
			'accountEditPage.signup': 'สมัครสมาชิก',
			'accountEditPage.disable': 'ปิดการทำงาน',
			'accountEditPage.ok': 'บันทึก',
			'settingsPage.title': 'การตั้งค่า',
			'settingsPage.locale': 'เปลี่ยนภาษา',
			'settingsPage.color': 'เปลี่ยนธีมสี',
		};
	}
}
