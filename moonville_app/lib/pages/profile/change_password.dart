import 'package:flutter/material.dart';
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
import '../../ui/custom_app_bar.dart';

/// ChangePasswordPage class.
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

/// _ChangePasswordState internal class.
class _ChangePasswordState extends State<ChangePasswordPage> {
  static final log = Logger('ChangePasswordPage');

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _passwordText;
  late TextEditingController _confirmPasswordText;
  late bool _obscurePassword;
  late bool _obscureConfirmPassword;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.changePasswordPage;
    return Scaffold(
      appBar: CustomAppBar(
        title: tr.title,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Styles.around(
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                // ok
                ElevatedButton.icon(
                  icon: const Icon(Icons.update),
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

  /// Save data.
  Future<void> _save() async {
    final shared = AppShared.instance();
    final client = shared.client;

    // convert data to JSON
    final json = client.formatJson({
      'user': {
        'password': _passwordText.text,
        'confirmPassword': _confirmPasswordText.text,
      },
    });

    // call REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        try {
          return RestResult(
            await http.put(
              client.getUri('profile/password'),
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

    // logout
    await MessageBox.info(context, t.changePasswordPage.confirm);
    AppShared.instance().logout(context);
  }
}
