/// Query pagination, order, searching and data in trash or not.
class QueryPage {
  int page;
  String order;
  String search;
  bool trash;

  QueryPage({
    this.page = 0,
    this.order = '',
    this.search = '',
    this.trash = false,
  });

  void toQueryString(Map<String, String> map) {
    if (page > 0) map.addAll({'page': page.toString()});
    if (order.trim().isNotEmpty) map.addAll({'order': order});
    if (search.trim().isNotEmpty) map.addAll({'search': search});
    if (trash) map.addAll({'trash': '1'});
  }
}
