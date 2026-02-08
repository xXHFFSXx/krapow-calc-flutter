class UserScope {
  final String userId;
  final String businessId;

  const UserScope({
    required this.userId,
    required this.businessId,
  });
}

class SyncMetadata {
  final DateTime lastSyncedAt;
  final String deviceId;

  const SyncMetadata({
    required this.lastSyncedAt,
    required this.deviceId,
  });
}
