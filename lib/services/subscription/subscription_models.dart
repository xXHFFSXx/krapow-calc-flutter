class SubscriptionPlan {
  final String id;
  final String name;
  final bool isPro;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.isPro,
  });
}

class FeatureGateStatus {
  final String featureKey;
  final bool isEnabled;
  final String? upgradeMessage;

  const FeatureGateStatus({
    required this.featureKey,
    required this.isEnabled,
    this.upgradeMessage,
  });
}

class SubscriptionState {
  final SubscriptionPlan plan;
  final DateTime updatedAt;

  const SubscriptionState({
    required this.plan,
    required this.updatedAt,
  });
}
