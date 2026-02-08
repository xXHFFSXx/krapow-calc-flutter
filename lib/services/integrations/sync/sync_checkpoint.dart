class SyncCheckpoint {
  final String providerKey;
  final String scopeKey;
  final DateTime? lastSyncedAt;

  const SyncCheckpoint({
    required this.providerKey,
    required this.scopeKey,
    required this.lastSyncedAt,
  });
}

abstract class SyncCheckpointStore {
  Future<SyncCheckpoint?> loadCheckpoint({
    required String providerKey,
    required String scopeKey,
  });

  Future<void> saveCheckpoint(SyncCheckpoint checkpoint);
}
