import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../i18n/strings.g.dart';

/// A set of widgets to go to various page.
class Paginator extends StatefulWidget {
  final int pageIndex;
  final int pageCount;
  final void Function(int pageIndex, int pageCount)? onPageRefresh;

  const Paginator({
    Key? key,
    required this.pageIndex,
    required this.pageCount,
    required this.onPageRefresh,
  }) : super(key: key);

  @override
  _PaginatorState createState() => _PaginatorState();
}

class _PaginatorState extends State<Paginator> {
  late TextEditingController _pageText;

  @override
  void initState() {
    super.initState();
    _pageText = TextEditingController();
  }

  @override
  void dispose() {
    _pageText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    _pageText.text = (widget.pageIndex + 1).toString();

    return Row(
      children: [
        // first
        IconButton(
          icon: const Icon(Icons.first_page),
          tooltip: t.paginator.first,
          onPressed: () {
            if (widget.pageCount > 0 && widget.pageIndex > 0) {
              widget.onPageRefresh?.call(0, widget.pageCount);
            }
          },
        ),

        // previous
        IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: t.paginator.previous,
          onPressed: () {
            if (widget.pageCount > 0 && widget.pageIndex > 0) {
              widget.onPageRefresh
                  ?.call(widget.pageIndex - 1, widget.pageCount);
            }
          },
        ),

        // go to
        SizedBox(
          width: 50,
          child: TextField(
            decoration: const InputDecoration(
              counterText: '',
            ),
            maxLength: 10,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d{0,10}'),
              ),
            ],
            controller: _pageText,
          ),
        ),
        Text(' / ${widget.pageCount}'),
        TextButton(
          child: Text(t.paginator.go),
          onPressed: () {
            // get page [1, page count]
            var page = int.tryParse(_pageText.text);
            if (page != null) {
              if (page < 1) {
                page = 1;
              } else if (page > widget.pageCount) {
                page = widget.pageCount;
              }

              // render text
              _pageText.text = '$page';
              widget.onPageRefresh?.call(page - 1, widget.pageCount);
            } else {
              _pageText.text = '${widget.pageIndex + 1}';
            }
          },
        ),

        // next
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          tooltip: t.paginator.next,
          onPressed: () {
            if (widget.pageCount > 0 &&
                widget.pageIndex < widget.pageCount - 1) {
              widget.onPageRefresh
                  ?.call(widget.pageIndex + 1, widget.pageCount);
            }
          },
        ),

        // last
        IconButton(
          icon: const Icon(Icons.last_page),
          tooltip: t.paginator.last,
          onPressed: () {
            if (widget.pageCount > 0 &&
                widget.pageIndex < widget.pageCount - 1) {
              widget.onPageRefresh
                  ?.call(widget.pageCount - 1, widget.pageCount);
            }
          },
        ),
      ],
    );
  }
}
