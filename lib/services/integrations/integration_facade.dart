import 'integration_models.dart';
import 'integration_orchestrator.dart';
import 'sync/sync_checkpoint.dart';
import 'sync/sync_coordinator.dart';

class IntegrationFacade {
  IntegrationFacade({
    required IntegrationOrchestrator orchestrator,
    required SyncCheckpointStore checkpointStore,
  }) : _coordinator = SyncCoordinator(
          orchestrator: orchestrator,
          checkpointStore: checkpointStore,
        );

  final SyncCoordinator _coordinator;

  Future<SyncResult> syncAll({
    required String scopeKey,
    required DateTime from,
    required DateTime to,
  }) {
    return _coordinator.sync(
      scopeKey: scopeKey,
      window: SyncWindow(from: from, to: to),
    );
  }

  List<SalesRecord> normalizeSales(List<SalesRecord> records) {
    return records;
  }
}
