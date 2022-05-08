import 'dart:async';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../i18n/strings.g.dart';
import '../widgets/message_box.dart';
import '../widgets/search_bar.dart';
import '../app_shared.dart';
import '../pages.dart';
import '../pages/profile/change_icon.dart';
import '../pages/profile/change_name.dart';
import '../pages/profile/change_password.dart';

enum TopRightMenu {
  changeIcon,
  changeName,
  changePassword,
  logout,
}

/// A customized AppBar.
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool withMoreMenu;
  final void Function(TopRightMenu menu, Object? result)? onResult;
  final bool searchBox;
  final void Function(String value)? onSearchTextChanged;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.withMoreMenu = false,
    this.onResult,
    this.searchBox = false,
    this.onSearchTextChanged,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late TextEditingController _searchText;

  @override
  void initState() {
    super.initState();
    _searchText = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _searchText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      actions: _buildActionList(context),
    );
  }

  /// Build popup menu button list.
  Widget _buildPopupMenu(BuildContext context) {
    final tr = t.appBar;
    return PopupMenuButton(
      icon: _buildImage(context),

      // item list
      itemBuilder: (context) {
        List<PopupMenuEntry<TopRightMenu>> list = [];
        if (widget.withMoreMenu) {
          // change icon
          list.add(PopupMenuItem(
            value: TopRightMenu.changeIcon,
            child: ListTile(
              leading: const Icon(Icons.face),
              title: Text(tr.changeIcon),
            ),
          ));

          // change name
          list.add(PopupMenuItem(
            value: TopRightMenu.changeName,
            child: ListTile(
              leading: const Icon(Icons.face),
              title: Text(tr.changeName),
            ),
          ));

          // change password
          list.add(PopupMenuItem(
            value: TopRightMenu.changePassword,
            child: ListTile(
              leading: const Icon(Icons.password),
              title: Text(tr.changePassword),
            ),
          ));
        }

        // logout
        list.add(PopupMenuItem(
          value: TopRightMenu.logout,
          child: ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(tr.exit),
          ),
        ));
        return list;
      },

      // events
      onSelected: (value) async {
        // change icon
        if (value == TopRightMenu.changeIcon) {
          final answer = await Pages.switchPage(
            context,
            const ChangeIconPage(),
          );
          if (answer != null) {
            widget.onResult?.call(TopRightMenu.changeIcon, answer);
          }
        }

        // change name
        else if (value == TopRightMenu.changeName) {
          final answer = await Pages.switchPage(
            context,
            const ChangeNamePage(),
          );
          if (answer != null) {
            widget.onResult?.call(TopRightMenu.changeName, answer);
          }
        }

        // change password
        else if (value == TopRightMenu.changePassword) {
          await Pages.switchPage(
            context,
            const ChangePasswordPage(),
          );
        }

        // logout
        else if (value == TopRightMenu.logout) {
          final answer = await MessageBox.question(
            context,
            t.question.areYouSureToExit,
            MessageBoxOptions(
              button0Negative: true,
            ),
          );
          if (answer == true) {
            await _exit(context);
          }
        }
      },
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      tooltip: t.searchBar.open,
      onPressed: () => Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: SearchBar(
            searchText: _searchText,
            onChanged: (text) => widget.onSearchTextChanged?.call(text),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActionList(BuildContext context) {
    final actions = <Widget>[];
    if (widget.searchBox) {
      actions.add(_buildSearchButton(context));
    }
    actions.add(_buildPopupMenu(context));
    return actions;
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

  // ----------------------------------------------------------------------

  /// Exit from system.
  Future<void> _exit(BuildContext context) async {
    AppShared.instance().logout(context);
  }
}
