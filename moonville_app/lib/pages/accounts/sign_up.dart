import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:moonville_client_dart/moonville_client_models.dart' as models;
import 'package:moonville_client_dart/moonville_client_dart.dart';
import '../../i18n/strings.g.dart';
import '../../validators/validate.dart';
import '../../widgets/message_box.dart';
import '../../widgets/service_runner.dart';
import '../../loggings.dart';
import '../../styles.dart';
import '../../app_shared.dart';

/// SignUpPage class.
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

/// _SignUpState internal class.
class _SignUpState extends State<SignUpPage> {
  static final log = Logger('SignUpPage');

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailText;
  late TextEditingController _passwordText;
  late TextEditingController _confirmPasswordText;
  late bool _obscurePassword;
  late bool _obscureConfirmPassword;

  @override
  void initState() {
    super.initState();
    _emailText = TextEditingController();
    _passwordText = TextEditingController();
    _confirmPasswordText = TextEditingController();
    _obscurePassword = true;
    _obscureConfirmPassword = true;
    log.fine('$this initState()');
  }

  @override
  void dispose() {
    log.fine('$this dispose()');
    _confirmPasswordText.dispose();
    _passwordText.dispose();
    _emailText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.signUpPage;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.title),
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
                Styles.betweenVertical(),

                // confirm password
                TextFormField(
                  decoration: InputDecoration(
                    border: Styles.inputBorder(),
                    labelText: tr.confirmPassword,
                    prefixIcon: const Icon(Icons.lock_rounded),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      }),
                      child: Icon(_obscureConfirmPassword
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
                    () => value == _passwordText.text
                        ? null
                        : t.validator.isSamePasswords,
                  ]),
                  obscureText: _obscureConfirmPassword,
                  controller: _confirmPasswordText,
                ),
                Styles.betweenVertical(),

                // register
                ElevatedButton.icon(
                  icon: const Icon(Icons.app_registration),
                  label: Styles.buttonPadding(Text(tr.ok)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _save();
                    }
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

  /// Save from UI to service.
  Future<void> _save() async {
    final shared = AppShared.instance();
    final client = shared.client;

    // convert data to JSON
    final json = client.formatJson({
      'user': {
        'email': _emailText.text.trim(),
        'password': _passwordText.text,
        'confirmPassword': _confirmPasswordText.text,
        'locale': AppShared.instance().currentLocale.languageCode,
      },
    });

    // call REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        try {
          return RestResult(
            await http.post(
              client.getUri('accounts/signup'),
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
    final item = rest.json['user'];
    log.finer('signup: $item');

    // remind user to confirm signup
    await MessageBox.info(context, t.signUpPage.confirm);
    Navigator.pop(context);
  }
}
