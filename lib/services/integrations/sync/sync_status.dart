enum SyncOutcome {
  success,
  partial,
  failed,
}

class SyncStatus {
  final String providerKey;
  final String scopeKey;
  final SyncOutcome outcome;
  final DateTime startedAt;
  final DateTime finishedAt;
  final String? message;

  const SyncStatus({
    required this.providerKey,
    required this.scopeKey,
    required this.outcome,
    required this.startedAt,
    required this.finishedAt,
    this.message,
  });
}
