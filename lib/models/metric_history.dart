import 'metric_item.dart';

class MetricHistory {
  const MetricHistory({
    required this.items,
    required this.meta,
  });

  final List<MetricItem> items;
  final MetricHistoryMeta meta;

  factory MetricHistory.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] is List ? json['items'] as List<dynamic> : <dynamic>[];

    return MetricHistory(
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(MetricItem.fromJson)
          .toList(),
      meta: MetricHistoryMeta.fromJson(
        json['meta'] is Map<String, dynamic>
            ? json['meta'] as Map<String, dynamic>
            : <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class MetricHistoryMeta {
  const MetricHistoryMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.metricType,
  });

  final int page;
  final int limit;
  final int total;
  final String metricType;

  factory MetricHistoryMeta.fromJson(Map<String, dynamic> json) {
    return MetricHistoryMeta(
      page: _toInt(json['page']),
      limit: _toInt(json['limit']),
      total: _toInt(json['total']),
      metricType: (json['metricType'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'page': page,
      'limit': limit,
      'total': total,
      'metricType': metricType,
    };
  }
}

int _toInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
