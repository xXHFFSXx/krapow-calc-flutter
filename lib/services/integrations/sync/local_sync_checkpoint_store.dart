import '../../../data/persistence/entities.dart';
import '../../../data/persistence/local_storage_repository.dart';
import 'sync_checkpoint.dart';

class LocalSyncCheckpointStore implements SyncCheckpointStore {
  LocalSyncCheckpointStore({
    required LocalStorageRepository storage,
  }) : _storage = storage;

  final LocalStorageRepository _storage;

  String _buildKey(String providerKey, String scopeKey) {
    return '${Uri.encodeComponent(providerKey)}|${Uri.encodeComponent(scopeKey)}';
  }

  String _buildLegacyKey(String providerKey, String scopeKey) {
    return '$providerKey::$scopeKey';
  }

  @override
  Future<SyncCheckpoint?> loadCheckpoint({
    required String providerKey,
    required String scopeKey,
  }) async {
    final key = _buildKey(providerKey, scopeKey);
    final entity =
        _storage.loadSyncCheckpoint(key) ??
        _storage.loadSyncCheckpoint(_buildLegacyKey(providerKey, scopeKey));
    if (entity == null) {
      return null;
    }
    return SyncCheckpoint(
      providerKey: providerKey,
      scopeKey: scopeKey,
      lastSyncedAt: entity.lastSyncedAt,
    );
  }

  @override
  Future<void> saveCheckpoint(SyncCheckpoint checkpoint) async {
    final key = _buildKey(checkpoint.providerKey, checkpoint.scopeKey);
    await _storage.saveSyncCheckpoint(
      SyncCheckpointEntity(
        providerKey: key,
        lastSyncedAt: checkpoint.lastSyncedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
        status: 'ok',
      ),
    );
  }
}
