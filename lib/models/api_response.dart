class ApiResponse<T> {
  final List<T> list;
  final String? nextPageCursor;
  final String? error;

  ApiResponse({required this.list, this.nextPageCursor, this.error});

  bool get hasError => error != null;
}