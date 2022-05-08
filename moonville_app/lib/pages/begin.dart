import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:moonville_client_dart/moonville_client_models.dart' as models;
import 'package:moonville_client_dart/moonville_client_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../i18n/strings.g.dart';
import '../validators/validate.dart';
import '../widgets/service_runner.dart';
import '../loggings.dart';
import '../styles.dart';
import '../embed.dart';
import '../app_shared.dart';
import '../pages.dart';
import '../pages/accounts/sign_up.dart';
import '../pages/accounts/forgot_password.dart';

/// BeginPage class.
class BeginPage extends StatefulWidget {
  const BeginPage({Key? key}) : super(key: key);

  @override
  _BeginState createState() => _BeginState();
}

/// _BeginState internal class.
class _BeginState extends State<BeginPage> {
  static final log = Logger('BeginPage');

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailText;
  late TextEditingController _passwordText;
  late bool _obscurePassword;
  late bool _isRememberChecked;
  late Timer _initTimer;

  @override
  void initState() {
    super.initState();
    _emailText = TextEditingController();
    _passwordText = TextEditingController();
    _obscurePassword = true;
    _isRememberChecked = false;
    _initTimer = Timer(const Duration(), _handleInit);
    log.fine('$this initState()');
  }

  @override
  void dispose() {
    log.fine('$this dispose()');
    _initTimer.cancel();
    _passwordText.dispose();
    _emailText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.beginPage;
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/app.png'),
        title: Text(tr.title),
        actions: [
          // Thai language
          IconButton(
            icon: Image.asset('assets/locales/th.png'),
            tooltip: t.switchLocale.th,
            onPressed: () => setState(
              () => AppShared.instance().changeLocale(context, 'th'),
            ),
          ),

          // English language
          IconButton(
            icon: Image.asset('assets/locales/en.png'),
            tooltip: t.switchLocale.en,
            onPressed: () => setState(
              () => AppShared.instance().changeLocale(context, 'en'),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Styles.around(
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // email
                TextFormField(
                  decoration: InputDecoration(
                    border: Styles.inputBorder(),
                    counterText: "",
                    labelText: tr.email,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  maxLength: models.AccountUser.emailMax,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[ \t]')),
                  ],
                  validator: (value) => checkValidate([
                    () => FieldValidators.checkEmail(value),
                  ]),
                  controller: _emailText,
                ),
                Styles.betweenVertical(),

                // password
                TextFormField(
                  decoration: InputDecoration(
                    border: Styles.inputBorder(),
                    counterText: "",
                    labelText: tr.password,
                    prefixIcon: const Icon(Icons.lock_rounded),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }),
                      child: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                  maxLength: models.AccountUser.passwordMax,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) => checkValidate([
                    () => FieldValidators.checkMinLength(
                        value, models.AccountUser.passwordMin),
                    () => FieldValidators.checkMaxLength(
                        value, models.AccountUser.passwordMax),
                  ]),
                  obscureText: _obscurePassword,
                  controller: _passwordText,
                ),

                Row(
                  children: [
                    // remember login
                    Checkbox(
                      value: _isRememberChecked,
                      onChanged: (value) => setState(() {
                        _isRememberChecked = value!;
                      }),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: Styles.linkButton(),
                          child: Text(tr.remember),
                          onPressed: () => setState(() {
                            _isRememberChecked = !_isRememberChecked;
                          }),
                        ),
                      ),
                    ),

                    // forgot password
                    TextButton(
                      style: Styles.linkButton(),
                      child: Text(tr.forgotPassword),
                      onPressed: () => _forgotPassword(),
                    ),
                  ],
                ),
                Styles.betweenVertical(),

                // login
                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: Styles.buttonPadding(Text(tr.ok)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                ),
                Styles.betweenVertical(),

                // - or -
                Container(
                  alignment: Alignment.center,
                  child: Text(tr.or),
                ),
                Styles.betweenVertical(),

                // signup
                ElevatedButton.icon(
                  icon: const Icon(Icons.app_registration),
                  label: Styles.buttonPadding(Text(tr.signUp)),
                  onPressed: () {
                    _signup();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------

  /// Go to signup page.
  Future<void> _signup() async {
    await Pages.switchPage(context, const SignUpPage());
  }

  /// Go to forgot password page.
  Future<void> _forgotPassword() async {
    await Pages.switchPage(
      context,
      ForgotPasswordPage(
        email: _emailText.text,
      ),
    );
  }

  /// Login to system.
  Future<void> _login() async {
    final shared = AppShared.instance();
    final client = shared.client;

    // convert data to JSON
    final json = client.formatJson({
      'login': {
        'email': _emailText.text.trim(),
        'password': _passwordText.text,
      },
    }, noLog: false);

    // call REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        try {
          return RestResult(
            await http.put(
              client.getUri('authen/login'),
              headers: client.headers,
              body: json,
            ),
          );
        } catch (ex) {
          return RestResult.error(ex.toString());
        }
      },
    );
    if (rest == null) return;

    // get result
    final item = models.AccountUser.fromJson(rest.json['user']);
    log.finer('user: $item');

    // perform login task
    AppShared.instance().login(context, item, rest.json['token']);

    // load profile icon
    final icon = await _loadProfileIcon();
    if (icon != null) item.icon = icon;

    // save login
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('user.remember', _isRememberChecked);
    if (_isRememberChecked) {
      await prefs.setString('user.email', client.user!.email);
      await prefs.setString('user.password', _passwordText.text);
    } else {
      await prefs.remove('user.email');
      await prefs.remove('user.password');
    }

    // switch page
    await Navigator.pushNamed(context, Pages.dashboard);
  }

  // ----------------------------------------------------------------------

  /// A time-consuming initialization.
  Future<void> _handleInit() async {
    if (!kIsWeb) {
      {
        final res = await http.get(Embed.uri(''));
        log.finer(
            '${res.request?.method} ${res.request?.url} ${res.statusCode}');
        log.finer('body: ${res.body}');
      }

      {
        final res = await http.post(Embed.uri('echo/ECHO'));
        log.finer(
            '${res.request?.method} ${res.request?.url} ${res.statusCode}');
        log.finer('body: ${res.body}');
      }

      {
        final res = await http.post(Embed.uri(''));
        log.finer(
            '${res.request?.method} ${res.request?.url} ${res.statusCode}');
        log.finer('body: ${res.body}');
      }
    }

    // load previous session
    final prefs = await SharedPreferences.getInstance();
    _isRememberChecked = prefs.getBool('user.remember') ?? false;
    if (_isRememberChecked) {
      _emailText.text = prefs.getString('user.email') ?? '';
      _passwordText.text = prefs.getString('user.password') ?? '';
    }
    setState(() {});

    // check last login
    if (_isRememberChecked) {
      final login = prefs.getBool('user.login') ?? false;
      if (login) {
        final shared = AppShared.instance();
        final client = shared.client;

        // convert data to JSON
        final json = client.formatJson({
          'login': {
            'email': _emailText.text.trim(),
            'password': _passwordText.text,
          },
        }, noLog: false);

        // call REST
        late final RestResult rest;
        try {
          rest = RestResult(
            await http.put(
              client.getUri('authen/login'),
              headers: client.headers,
              body: json,
            ),
          );
        } catch (ex) {
          rest = RestResult.error(ex.toString());
        }
        if (!rest.ok) return;

        // get result
        final item = models.AccountUser.fromJson(rest.json['user']);
        log.finer('user: $item');

        // perform login task
        AppShared.instance().login(context, item, rest.json['token']);

        // load profile icon
        final icon = await _loadProfileIcon();
        if (icon != null) item.icon = icon;

        // switch page
        await Navigator.pushNamed(context, Pages.dashboard);
      }
    }
  }

  // ----------------------------------------------------------------------

  Future<Uint8List?> _loadProfileIcon() async {
    final shared = AppShared.instance();
    final client = shared.client;

    // call REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        try {
          return RestResult(
            await http.get(
              client.getUri('profile/icon'),
              headers: client.headers,
            ),
          );
        } catch (ex) {
          return RestResult.error(ex.toString());
        }
      },
    );
    if (rest == null) return null;

    // return the result
    return rest.res!.bodyBytes;
  }
}
