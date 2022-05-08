import 'package:flutter/material.dart';
import '../base/formatter.dart';
import '../i18n/strings.g.dart';
import '../loggings.dart';
import '../styles.dart';
import '../app_shared.dart';
import '../ui/custom_app_bar.dart';
import '../ui/custom_drawer.dart';

/// DashboardPage class.
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

/// _DashboardState internal class.
class _DashboardState extends State<DashboardPage> {
  static final log = Logger('DashboardPage');

  @override
  void initState() {
    super.initState();
    log.fine('$this initState()');
  }

  @override
  void dispose() {
    log.fine('$this dispose()');
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.dashboardPage;
    final user = AppShared.instance().client.user!;
    return Scaffold(
      appBar: CustomAppBar(
        title: tr.title,
        withMoreMenu: true,
        onResult: (menu, result) => setState(() {}),
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Styles.around(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // icon
              _buildImage(context),
              Styles.betweenVertical(),

              // email
              Text(user.email, style: Styles.titleTextStyle()),
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
                    DataCell(Text(user.role)),
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text(tr.name)),
                    DataCell(Text(user.name)),
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text(tr.locale)),
                    DataCell(Text(user.locale)),
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text(tr.signup)),
                    DataCell(
                        Text(Formatter.dateTimeFormat.format(user.createdAt!))),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final icon = AppShared.instance().client.user?.icon;
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
}
