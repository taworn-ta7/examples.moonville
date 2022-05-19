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

/// ForgotPasswordPage class.
class ForgotPasswordPage extends StatefulWidget {
  final String email;

  const ForgotPasswordPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

/// _ForgotPasswordState internal class.
class _ForgotPasswordState extends State<ForgotPasswordPage> {
  static final log = Logger('ForgotPasswordPage');

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailText;

  @override
  void initState() {
    super.initState();
    _emailText = TextEditingController(text: widget.email);
    log.fine("$this initState()");
  }

  @override
  void dispose() {
    log.fine("$this dispose()");
    _emailText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.forgotPasswordPage;
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

                // send email
                ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: Styles.buttonPadding(Text(tr.ok)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _sendEmail();
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

  /// Send email service.
  Future<void> _sendEmail() async {
    final shared = AppShared.instance();
    final client = shared.client;

    // convert data to JSON
    final json = client.formatJson({
      'user': {
        'email': _emailText.text.trim(),
      },
    });

    // call REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        try {
          return RestResult(
            await http.post(
              client.getUri('accounts/request-reset'),
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
    log.finer("reset: $item");

    // remind user to confirm signup
    await MessageBox.info(context, t.forgotPasswordPage.check);
    Navigator.pop(context);
  }
}
