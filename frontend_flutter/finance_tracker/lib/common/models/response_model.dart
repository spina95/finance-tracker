class ResponseList<T> {
  final int count;
  final List<T> results;

  ResponseList({
    required this.count,
    required this.results,
  });

  factory ResponseList.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ResponseList<T>(
      count: json['count'],
      results: List<T>.from(json['results'].map((item) => fromJsonT(item))),
    );
  }
}
