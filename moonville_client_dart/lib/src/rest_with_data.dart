import './rest_result.dart';

/// REST template data.
class RestWithData<T extends Object> {
  /// REST result
  final RestResult rest;

  /// REST data
  final T? data;

  /// Constructor.
  RestWithData({
    required this.rest,
    required this.data,
  });

  /// Check if it's ok or not.
  bool get ok => rest.ok;
}
