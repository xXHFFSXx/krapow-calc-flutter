import 'subscription_models.dart';

class SubscriptionRepository {
  SubscriptionState _state = SubscriptionState(
    plan: const SubscriptionPlan(id: 'free', name: 'Free', isPro: false),
    updatedAt: DateTime.now(),
  );

  Future<SubscriptionState> load() async {
    return _state;
  }

  Future<void> save(SubscriptionState state) async {
    _state = state;
  }
}
