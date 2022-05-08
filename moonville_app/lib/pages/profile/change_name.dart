import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moonville_client_dart/moonville_client_models.dart' as models;
import 'package:moonville_client_dart/moonville_client_dart.dart';
import '../../i18n/strings.g.dart';
import '../../validators/validate.dart';
import '../../widgets/service_runner.dart';
import '../../loggings.dart';
import '../../styles.dart';
import '../../app_shared.dart';
import '../../pages.dart';
import '../../ui/custom_app_bar.dart';

/// ChangeNamePage class.
class ChangeNamePage extends StatefulWidget {
  const ChangeNamePage({Key? key}) : super(key: key);

  @override
  _ChangeNameState createState() => _ChangeNameState();
}

/// _ChangeNameState internal class.
class _ChangeNameState extends State<ChangeNamePage> {
  static final log = Logger('ChangeNamePage');
  static final shared = AppShared.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameText;

  @override
  void initState() {
    super.initState();
    _nameText = TextEditingController(text: shared.client.user!.name);
    log.fine('$this initState()');
  }

  @override
  void dispose() {
    log.fine('$this dispose()');
    _nameText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.changeNamePage;
    return Scaffold(
      appBar: CustomAppBar(
        title: tr.title,
      ),
      body: WillPopScope(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Styles.around(
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name
                  TextFormField(
                    decoration: InputDecoration(
                      border: Styles.inputBorder(),
                      labelText: tr.name,
                      prefixIcon: const Icon(Icons.face),
                    ),
                    maxLength: models.AccountUser.nameMax,
                    keyboardType: TextInputType.name,
                    validator: (value) => checkValidate([
                      () => FieldValidators.checkMinLength(value, 1),
                    ]),
                    controller: _nameText,
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
        onWillPop: _beforeBack,
      ),
    );
  }

  // ----------------------------------------------------------------------

  /// Before leave page.
  Future<bool> _beforeBack() async {
    final isChanged = _nameText.text != shared.client.user!.name;
    return Pages.beforeBack(context, isChanged);
  }

  // ----------------------------------------------------------------------

  /// Save data.
  Future<void> _save() async {
    final shared = AppShared.instance();
    final client = shared.client;

    // convert data to JSON
    final json = client.formatJson({
      'user': {
        'name': _nameText.text,
      },
    });

    // call REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        try {
          return RestResult(
            await http.put(
              client.getUri('profile/name'),
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

    // update client user
    client.update(item);

    // go back
    Navigator.pop(context, true);
  }
}
