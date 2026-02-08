import 'dart:developer' as developer;

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
      try {
        results.addAll(await provider.fetchSales(from, to));
      } catch (error) {
        developer.log(
          'POS provider ${provider.providerName} failed: $error',
          name: 'IntegrationOrchestrator',
        );
      }
    }
    return results;
  }

  Future<List<MenuSyncRecord>> collectMenus() async {
    final results = <MenuSyncRecord>[];
    for (final provider in posProviders) {
      try {
        results.addAll(await provider.fetchMenus());
      } catch (error) {
        developer.log(
          'POS menus provider ${provider.providerName} failed: $error',
          name: 'IntegrationOrchestrator',
        );
      }
    }
    return results;
  }

  Future<List<DeliveryOrderRecord>> collectDeliveryOrders(DateTime from, DateTime to) async {
    final results = <DeliveryOrderRecord>[];
    for (final provider in deliveryProviders) {
      try {
        results.addAll(await provider.fetchOrders(from, to));
      } catch (error) {
        developer.log(
          'Delivery provider ${provider.platformName} failed: $error',
          name: 'IntegrationOrchestrator',
        );
      }
    }
    return results;
  }

  Future<List<SupplierPriceRecord>> collectSupplierPrices() async {
    final results = <SupplierPriceRecord>[];
    for (final provider in supplierProviders) {
      try {
        results.addAll(await provider.fetchIngredientPrices());
      } catch (error) {
        developer.log(
          'Supplier provider ${provider.supplierName} failed: $error',
          name: 'IntegrationOrchestrator',
        );
      }
    }
    return results;
  }

  Future<List<BenchmarkMetric>> collectBenchmarks() async {
    final results = <BenchmarkMetric>[];
    for (final provider in marketProviders) {
      try {
        results.addAll(await provider.fetchBenchmarks());
      } catch (error) {
        developer.log(
          'Market provider ${provider.sourceName} failed: $error',
          name: 'IntegrationOrchestrator',
        );
      }
    }
    return results;
  }
}
