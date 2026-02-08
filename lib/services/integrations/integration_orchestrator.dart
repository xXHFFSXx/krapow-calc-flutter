import 'integration_interfaces.dart';
import 'integration_models.dart';

class IntegrationOrchestrator {
  IntegrationOrchestrator({
    this.posProviders = const [],
    this.deliveryProviders = const [],
    this.supplierProviders = const [],
    this.marketProviders = const [],
  });

  final List<PosIntegrationProvider> posProviders;
  final List<DeliveryIntegrationProvider> deliveryProviders;
  final List<SupplierIntegrationProvider> supplierProviders;
  final List<MarketDataProvider> marketProviders;

  Future<List<SalesRecord>> collectSales(DateTime from, DateTime to) async {
    final results = <SalesRecord>[];
    for (final provider in posProviders) {
      results.addAll(await provider.fetchSales(from, to));
    }
    return results;
  }

  Future<List<MenuSyncRecord>> collectMenus() async {
    final results = <MenuSyncRecord>[];
    for (final provider in posProviders) {
      results.addAll(await provider.fetchMenus());
    }
    return results;
  }

  Future<List<DeliveryOrderRecord>> collectDeliveryOrders(DateTime from, DateTime to) async {
    final results = <DeliveryOrderRecord>[];
    for (final provider in deliveryProviders) {
      results.addAll(await provider.fetchOrders(from, to));
    }
    return results;
  }

  Future<List<SupplierPriceRecord>> collectSupplierPrices() async {
    final results = <SupplierPriceRecord>[];
    for (final provider in supplierProviders) {
      results.addAll(await provider.fetchIngredientPrices());
    }
    return results;
  }

  Future<List<BenchmarkMetric>> collectBenchmarks() async {
    final results = <BenchmarkMetric>[];
    for (final provider in marketProviders) {
      results.addAll(await provider.fetchBenchmarks());
    }
    return results;
  }
}
