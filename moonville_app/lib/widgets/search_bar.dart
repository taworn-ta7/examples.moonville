import 'dart:async';
import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';

// Toggled search bar.
class SearchBar extends StatefulWidget {
  static const defaultSearchDelay = 1500;

  final int searchDelay;
  final TextEditingController searchText;
  final void Function(String value)? onChanged;

  const SearchBar({
    Key? key,
    this.searchDelay = defaultSearchDelay,
    required this.searchText,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchBar> {
  Timer? _searchTimer;
  String _lastSend = '';

  @override
  void initState() {
    super.initState();
    _lastSend = '';
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(0x00, 0x00, 0x00, 0x00),
        appBar: AppBar(
          title: Container(
            width: double.infinity,
            height: kToolbarHeight - 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      widget.searchText.text = '';
                      _delayChanged(widget.searchText.text);
                    },
                  ),
                  hintText: t.searchBar.hint,
                  hintStyle: const TextStyle(
                    textBaseline: TextBaseline.ideographic,
                  ),
                  border: InputBorder.none,
                ),
                controller: widget.searchText,
                onChanged: (text) => _delayChanged(text),
              ),
            ),
          ),
        ),
        body: Container(
          color: const Color.fromARGB(0x80, 0x80, 0x80, 0x80),
        ),
      ),
      onWillPop: () async {
        _searchTimer?.cancel();
        _searchTimer = Timer(
          const Duration(),
          () => widget.onChanged?.call(widget.searchText.text),
        );
        return true;
      },
    );
  }

  void _delayChanged(String text) {
    // reset old timer, if set
    _searchTimer?.cancel();

    // set delay timer
    _searchTimer = Timer(
      Duration(milliseconds: widget.searchDelay >= 1 ? widget.searchDelay : 1),
      () {
        _lastSend = widget.searchText.text;
        widget.onChanged?.call(_lastSend);
      },
    );
  }
}
