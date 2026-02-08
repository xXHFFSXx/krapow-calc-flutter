import 'integration_models.dart';

abstract class PosIntegrationProvider {
  String get providerName;
  Future<List<SalesRecord>> fetchSales(DateTime from, DateTime to);
  Future<List<MenuSyncRecord>> fetchMenus();
}

abstract class DeliveryIntegrationProvider {
  String get platformName;
  Future<List<DeliveryOrderRecord>> fetchOrders(DateTime from, DateTime to);
  Future<Map<String, double>> fetchGpRates();
  Future<List<PromotionImpactRecord>> fetchCampaignImpact(DateTime from, DateTime to);
}

abstract class SupplierIntegrationProvider {
  String get supplierName;
  Future<List<SupplierPriceRecord>> fetchIngredientPrices();
}

abstract class MarketDataProvider {
  String get sourceName;
  Future<List<BenchmarkMetric>> fetchBenchmarks();
  Future<List<MarketTrendPoint>> fetchTrends();
}
