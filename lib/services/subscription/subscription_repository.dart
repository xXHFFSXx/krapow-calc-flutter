import 'package:hive_flutter/hive_flutter.dart';

import 'subscription_models.dart';
import 'subscription_storage.dart';

class SubscriptionRepository {
  static const _boxName = 'subscription_state';
  static const _stateKey = 'current';
  static bool _hiveInitialized = false;

  SubscriptionState _state = SubscriptionState(
    plan: const SubscriptionPlan(id: 'free', name: 'Free', isPro: false),
    updatedAt: DateTime.now(),
  );

  Future<SubscriptionState> load() async {
    final box = await _openBox();
    final entity = box.get(_stateKey);
    if (entity == null) {
      return _state;
    }
    _state = SubscriptionState(
      plan: SubscriptionPlan(
        id: entity.planId,
        name: entity.planName,
        isPro: entity.isPro,
      ),
      updatedAt: entity.updatedAt,
    );
    return _state;
  }

  Future<void> save(SubscriptionState state) async {
    _state = state;
    final box = await _openBox();
    await box.put(
      _stateKey,
      SubscriptionStateEntity(
        planId: state.plan.id,
        planName: state.plan.name,
        isPro: state.plan.isPro,
        updatedAt: state.updatedAt,
      ),
    );
  }

  Future<Box<SubscriptionStateEntity>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      if (!_hiveInitialized) {
        await Hive.initFlutter();
        _hiveInitialized = true;
      }
      if (!Hive.isAdapterRegistered(SubscriptionStateEntityAdapter().typeId)) {
        Hive.registerAdapter(SubscriptionStateEntityAdapter());
      }
      await Hive.openBox<SubscriptionStateEntity>(_boxName);
    }
    return Hive.box<SubscriptionStateEntity>(_boxName);
  }
}
