/// Spring `PagedModel` — `{content: [], page: {size, number, totalElements, totalPages}}`.
class Page<T> {
  const Page({
    required this.content,
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });

  factory Page.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromItem) {
    final page = (json['page'] as Map?)?.cast<String, dynamic>() ?? const {};
    final content = (json['content'] as List? ?? const [])
        .map((e) => fromItem((e as Map).cast<String, dynamic>()))
        .toList();
    return Page(
      content: content,
      size: (page['size'] as num?)?.toInt() ?? content.length,
      number: (page['number'] as num?)?.toInt() ?? 0,
      totalElements: (page['totalElements'] as num?)?.toInt() ?? content.length,
      totalPages: (page['totalPages'] as num?)?.toInt() ?? 1,
    );
  }

  const Page.empty() : this(content: const [], size: 0, number: 0, totalElements: 0, totalPages: 0);

  final List<T> content;
  final int size;
  final int number;
  final int totalElements;
  final int totalPages;

  bool get hasMore => number + 1 < totalPages;
  bool get isEmpty => content.isEmpty;
}
