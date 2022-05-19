import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moonville_client_dart/moonville_client_models.dart' as models;
import 'package:moonville_client_dart/moonville_client_dart.dart';
import '../base/formatter.dart';
import '../i18n/strings.g.dart';
import '../widgets/service_runner.dart';
import '../loggings.dart';
import '../styles.dart';
import '../app_shared.dart';
import '../ui/custom_app_bar.dart';

/// AccountEditPage class.
class AccountEditPage extends StatefulWidget {
  final models.AccountUser item;

  const AccountEditPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _AccountEditState createState() => _AccountEditState();
}

/// _AccountEditState internal class.
class _AccountEditState extends State<AccountEditPage> {
  static final log = Logger('AccountEditPage');

  // widgets
  final _formKey = GlobalKey<FormState>();
  late bool _isDisabled;

  @override
  void initState() {
    super.initState();
    _isDisabled = widget.item.disabled != null;
    log.fine("$this initState()");
  }

  @override
  void dispose() {
    log.fine("$this dispose()");
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.accountEditPage;
    return Scaffold(
      appBar: CustomAppBar(
        title: tr.title(name: widget.item.email),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Styles.around(
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // icon
                _buildImage(context),
                Styles.betweenVertical(),

                // email
                Text(widget.item.email, style: Styles.titleTextStyle()),
                Styles.betweenVertical(),

                // data table
                DataTable(
                  columns: <DataColumn>[
                    DataColumn(label: Text(t.common.name)),
                    DataColumn(label: Text(t.common.value)),
                  ],
                  rows: <DataRow>[
                    DataRow(cells: <DataCell>[
                      DataCell(Text(tr.role)),
                      DataCell(Text(widget.item.role)),
                    ]),
                    DataRow(cells: <DataCell>[
                      DataCell(Text(tr.name)),
                      DataCell(Text(widget.item.name)),
                    ]),
                    DataRow(cells: <DataCell>[
                      DataCell(Text(tr.locale)),
                      DataCell(Text(widget.item.locale)),
                    ]),
                    DataRow(cells: <DataCell>[
                      DataCell(Text(tr.disabled)),
                      DataCell(Text(widget.item.disabled != null
                          ? Formatter.dateTimeFormat
                              .format(widget.item.disabled!)
                          : '')),
                    ]),
                    DataRow(cells: <DataCell>[
                      DataCell(Text(tr.resigned)),
                      DataCell(Text(widget.item.resigned != null
                          ? Formatter.dateTimeFormat
                              .format(widget.item.resigned!)
                          : '')),
                    ]),
                    DataRow(cells: <DataCell>[
                      DataCell(Text(tr.signup)),
                      DataCell(Text(Formatter.dateTimeFormat
                          .format(widget.item.createdAt!))),
                    ]),
                  ],
                ),
                Styles.betweenVertical(),

                // disabled
                CheckboxListTile(
                  title: Text(tr.disable),
                  secondary: const Icon(Icons.disabled_by_default),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _isDisabled,
                  onChanged: (value) => setState(() {
                    _isDisabled = value!;
                  }),
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

  Widget _buildImage(BuildContext context) {
    final icon = widget.item.icon;
    if (icon != null) {
      return Image.memory(
        icon,
        width: 128,
        height: 128,
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(
        'assets/default-profile-icon.png',
        width: 128,
        height: 128,
        fit: BoxFit.contain,
      );
    }
  }

  // ----------------------------------------------------------------------

  /// Save data.
  Future<void> _save() async {
    if (_isDisabled == (widget.item.disabled != null)) {
      Navigator.pop(context);
      return;
    }

    final shared = AppShared.instance();
    final client = shared.client;

    // convert data to JSON
    final json = client.formatJson({
      'user': {
        'disabled': _isDisabled,
      },
    });

    // call REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        try {
          return RestResult(
            await http.put(
              client.getUri('accounts/users/disable/${widget.item.email}'),
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
    log.finer("user: $item");

    // update client user
    client.update(item);

    // go back
    Navigator.pop(context, true);
  }
}
