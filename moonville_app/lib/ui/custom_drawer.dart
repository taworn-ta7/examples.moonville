import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';
import '../styles.dart';
import '../app_shared.dart';
import '../pages.dart';

/// A customized Drawer.
class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final tr = t.drawerUi;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppShared.instance().currentTheme,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // icon
                _buildImage(context),
                Styles.betweenVertical(),

                // name
                ListTile(
                  title: Text(tr.title),
                  subtitle: Text(AppShared.instance().client.user!.name),
                ),
              ],
            ),
          ),

          // home
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(tr.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, Pages.dashboard);
            },
          ),

          // accounts
          ListTile(
            leading: const Icon(Icons.group),
            title: Text(tr.accounts),
            onTap: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, Pages.accounts);
            },
          ),

          // settings
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(tr.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, Pages.settings);
            },
          ),

          // exit
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(tr.exit),
            onTap: () {
              AppShared.instance().logout(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final icon = AppShared.instance().client.user?.icon;
    if (icon != null) {
      return Image.memory(
        icon,
        width: 64,
        height: 64,
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(
        'assets/default-profile-icon.png',
        width: 64,
        height: 64,
        fit: BoxFit.contain,
      );
    }
  }
}
