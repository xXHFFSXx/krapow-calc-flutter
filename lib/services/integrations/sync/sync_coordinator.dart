import '../integration_models.dart';
import '../integration_orchestrator.dart';
import 'sync_checkpoint.dart';
import 'sync_deduper.dart';
import 'sync_status.dart';

class SyncWindow {
  final DateTime from;
  final DateTime to;

  const SyncWindow({
    required this.from,
    required this.to,
  });
}

class SyncResult {
  final List<SalesRecord> sales;
  final List<MenuSyncRecord> menus;
  final List<DeliveryOrderRecord> deliveryOrders;
  final List<SupplierPriceRecord> supplierPrices;
  final List<BenchmarkMetric> benchmarks;
  final List<SyncStatus> statuses;

  const SyncResult({
    required this.sales,
    required this.menus,
    required this.deliveryOrders,
    required this.supplierPrices,
    required this.benchmarks,
    required this.statuses,
  });
}

class SyncCoordinator {
  SyncCoordinator({
    required this.orchestrator,
    required this.checkpointStore,
  });

  final IntegrationOrchestrator orchestrator;
  final SyncCheckpointStore checkpointStore;

  Future<SyncResult> sync({
    required String scopeKey,
    required SyncWindow window,
  }) async {
    final statuses = <SyncStatus>[];
    final startedAt = DateTime.now();
    final sales = await orchestrator.collectSales(window.from, window.to);
    final menus = await orchestrator.collectMenus();
    final deliveryOrders =
        await orchestrator.collectDeliveryOrders(window.from, window.to);
    final supplierPrices = await orchestrator.collectSupplierPrices();
    final benchmarks = await orchestrator.collectBenchmarks();

    statuses.add(
      SyncStatus(
        providerKey: 'orchestrator',
        scopeKey: scopeKey,
        outcome: SyncOutcome.success,
        startedAt: startedAt,
        finishedAt: DateTime.now(),
      ),
    );

    await checkpointStore.saveCheckpoint(
      SyncCheckpoint(
        providerKey: 'orchestrator',
        scopeKey: scopeKey,
        lastSyncedAt: window.to,
      ),
    );

    return SyncResult(
      sales: SyncDeduper<SalesRecord>(
        identityFor: (record) => record.externalId,
      ).dedupe(sales),
      menus: SyncDeduper<MenuSyncRecord>(
        identityFor: (record) => record.externalMenuId,
      ).dedupe(menus),
      deliveryOrders: SyncDeduper<DeliveryOrderRecord>(
        identityFor: (record) => record.externalOrderId,
      ).dedupe(deliveryOrders),
      supplierPrices: supplierPrices,
      benchmarks: benchmarks,
      statuses: statuses,
    );
  }
}
