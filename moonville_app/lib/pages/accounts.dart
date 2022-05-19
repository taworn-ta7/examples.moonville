import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moonville_client_dart/moonville_client_models.dart' as models;
import 'package:moonville_client_dart/moonville_client_dart.dart';
import '../i18n/strings.g.dart';
import '../widgets/paginator.dart';
import '../widgets/service_runner.dart';
import '../loggings.dart';
import '../app_shared.dart';
import '../pages.dart';
import '../ui/custom_app_bar.dart';
import '../ui/custom_drawer.dart';
import './account_edit.dart';

/// AccountsPage class.
class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  _AccountsState createState() => _AccountsState();
}

/// _AccountsState internal class.
class _AccountsState extends State<AccountsPage> {
  static final log = Logger('AccountsPage');

  // data
  final items = <models.AccountUser>[];

  // page
  int _pageCount = 0;
  int _pageIndex = 0;

  // order
  final tr = t.accountsPage.sortBy;
  final Map<String, String> _orderingMap = {
    '': t.accountsPage.sortBy.id,
    'email+': t.accountsPage.sortBy.emailAsc,
    'email-': t.accountsPage.sortBy.emailDesc,
    'createdAt+': t.accountsPage.sortBy.signUpAsc,
    'createdAt-': t.accountsPage.sortBy.signUpDesc,
  };
  String _orderingSelected = '';

  // search
  String _searchText = '';

  // trash
  bool _isTrashed = false;

  // initial timer handler
  late Timer _initTimer;

  // loading icon in background, with items[_loadingIndex]
  int _loadingIndex = 0;

  // loading background handler
  Timer? _loadTimer;

  @override
  void initState() {
    super.initState();
    _initTimer = Timer(const Duration(), _handleInit);
    _loadTimer = null;
    log.fine("$this initState()");
  }

  @override
  void dispose() {
    log.fine("$this dispose()");
    _loadTimer?.cancel();
    _initTimer.cancel();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.accountsPage;
    return Scaffold(
      appBar: CustomAppBar(
        title: tr.title,
        searchBox: true,
        onSearchTextChanged: (text) {
          setState(() {
            _searchText = text;
            _pageIndex = 0;
          });
          _refresh();
        },
      ),
      drawer: const CustomDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                // ordering
                Flexible(
                  flex: 1,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    items: _orderingMap
                        .map((value, text) {
                          return MapEntry(
                            value,
                            DropdownMenuItem<String>(
                              value: value,
                              child: Text(text),
                            ),
                          );
                        })
                        .values
                        .toList(),
                    value: _orderingSelected,
                    onChanged: (value) {
                      setState(() {
                        _orderingSelected = value ??= '';
                      });
                      _refresh();
                    },
                  ),
                ),

                // trash only
                IconButton(
                  icon: Icon(_isTrashed ? Icons.delete : Icons.description),
                  tooltip: tr.trash,
                  onPressed: () => setState(() {
                    _isTrashed = !_isTrashed;
                    _refresh();
                  }),
                ),
              ],
            ),
          ),

          // list view
          Expanded(
            child: RefreshIndicator(
              child: ListView(
                children: items.map((item) {
                  return ListTile(
                    leading: item.icon == null
                        ? Image.asset('assets/default-profile-icon.png')
                        : Image.memory(item.icon!),
                    title: Text(item.email),
                    subtitle: Text(item.name),
                    trailing: Icon(
                        (item.disabled != null) || (item.resigned != null)
                            ? Icons.disabled_by_default
                            : Icons.run_circle),
                    onTap: () => _editItem(item),
                  );
                }).toList(),
              ),
              onRefresh: _refresh,
            ),
          ),

          // paginator
          Container(
            alignment: Alignment.bottomLeft,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            child: Paginator(
              pageIndex: _pageIndex,
              pageCount: _pageCount,
              onPageRefresh: (pageIndex, pageCount) {
                _pageIndex = pageIndex;
                _refresh();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------

  Future<void> _handleInit() async {
    await _refresh();
  }

  Future<void> _refresh() async {
    final shared = AppShared.instance();
    final client = shared.client;

    // call REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        try {
          final query = <String, String>{};
          QueryPage(
            page: _pageIndex,
            order: _orderingSelected,
            search: _searchText,
            trash: _isTrashed,
          ).toQueryString(query);
          return RestResult(
            await http.get(
              client.getUri('accounts/users', query),
              headers: client.headers,
            ),
          );
        } catch (ex) {
          return RestResult.error(ex.toString());
        }
      },
    );
    if (rest == null) return;

    // get result
    final list = rest.json['users'];
    log.finer("find all, count: ${list.length}");
    items.clear();
    for (var i = 0; i < list.length; i++) {
      final item = models.AccountUser.fromJson(list[i]);
      log.finer("#$i: $item");
      items.add(item);
    }

    // update paginate
    final paginate = rest.json['paginate'];
    _pageIndex = paginate['pageIndex'];
    _pageCount = paginate['pageCount'];
    log.finer("page: ${_pageIndex + 1}/$_pageCount");

    // refresh UI
    setState(() {});

    // load icons in background
    _loadingIndex = 0;
    _loadTimer = Timer(const Duration(milliseconds: 1), _handleLoad);
  }

  Future<void> _handleLoad() async {
    if (_loadingIndex < items.length) {
      final shared = AppShared.instance();
      final client = shared.client;
      final item = items[_loadingIndex];
      final rest = await RestAccountUsers.getIcon(client, email: item.email);
      if (rest.data != null) {
        setState(() {
          item.icon = rest.data;
        });
      }
      _loadingIndex++;
      _loadTimer = Timer(const Duration(milliseconds: 1), _handleLoad);
    }
  }

  // ----------------------------------------------------------------------

  Future<void> _editItem(models.AccountUser o) async {
    final shared = AppShared.instance();
    final client = shared.client;

    // call REST
    late final models.AccountUser data;
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        final rd = await RestAccountUsers.get(
          client,
          email: o.email,
          withIcon: true,
          errorIcon: false,
        );
        if (rd.ok) data = rd.data!;
        return rd.rest;
      },
    );
    if (rest == null) return;

    // call editing page
    final answer = await Pages.switchPage(
      context,
      AccountEditPage(item: data),
    );
    if (answer != null) {
      _refresh();
    }
  }
}
