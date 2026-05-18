import 'metric_item.dart';

class LatestMetrics {
  const LatestMetrics({
    required this.metrics,
  });

  final Map<String, MetricItem> metrics;

  factory LatestMetrics.fromJson(Map<String, dynamic> json) {
    final rawMetrics = json['metrics'] is Map<String, dynamic>
        ? json['metrics'] as Map<String, dynamic>
        : <String, dynamic>{};

    final parsed = <String, MetricItem>{};
    rawMetrics.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        parsed[key] = MetricItem.fromJson(value);
      }
    });

    return LatestMetrics(metrics: parsed);
  }

  MetricItem? byType(String type) {
    return metrics[type];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'metrics': metrics.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}
