class IntegrationSource {
  final String id;
  final String name;
  final String type;

  const IntegrationSource({
    required this.id,
    required this.name,
    required this.type,
  });
}

class SalesRecord {
  final String externalId;
  final String menuId;
  final int quantity;
  final double totalRevenue;
  final DateTime recordedAt;

  const SalesRecord({
    required this.externalId,
    required this.menuId,
    required this.quantity,
    required this.totalRevenue,
    required this.recordedAt,
  });
}

class MenuSyncRecord {
  final String externalMenuId;
  final String name;
  final double price;

  const MenuSyncRecord({
    required this.externalMenuId,
    required this.name,
    required this.price,
  });
}

class DeliveryOrderRecord {
  final String externalOrderId;
  final double grossAmount;
  final double gpRate;
  final double netRevenue;
  final DateTime orderedAt;

  const DeliveryOrderRecord({
    required this.externalOrderId,
    required this.grossAmount,
    required this.gpRate,
    required this.netRevenue,
    required this.orderedAt,
  });
}

class PromotionImpactRecord {
  final String campaignId;
  final double discountPercent;
  final double netProfitImpact;

  const PromotionImpactRecord({
    required this.campaignId,
    required this.discountPercent,
    required this.netProfitImpact,
  });
}

class SupplierPriceRecord {
  final String supplierId;
  final String ingredientName;
  final double price;
  final String unit;
  final DateTime recordedAt;

  const SupplierPriceRecord({
    required this.supplierId,
    required this.ingredientName,
    required this.price,
    required this.unit,
    required this.recordedAt,
  });
}

class SupplierComparison {
  final String ingredientName;
  final List<SupplierPriceRecord> offers;

  const SupplierComparison({
    required this.ingredientName,
    required this.offers,
  });
}

class ReorderSuggestion {
  final String ingredientName;
  final int recommendedQuantity;
  final String reason;

  const ReorderSuggestion({
    required this.ingredientName,
    required this.recommendedQuantity,
    required this.reason,
  });
}

class BenchmarkMetric {
  final String metricKey;
  final double value;
  final String region;

  const BenchmarkMetric({
    required this.metricKey,
    required this.value,
    required this.region,
  });
}

class MarketTrendPoint {
  final DateTime date;
  final double indexValue;

  const MarketTrendPoint({
    required this.date,
    required this.indexValue,
  });
}

class AnonymizedAggregate {
  final String category;
  final double aggregatedValue;
  final DateTime periodStart;

  const AnonymizedAggregate({
    required this.category,
    required this.aggregatedValue,
    required this.periodStart,
  });
}
