import 'package:hive_flutter/hive_flutter.dart';

import '../../models.dart';
import 'entities.dart';

class LocalStorageRepository {
  LocalStorageRepository();

  bool _initialized = false;

  static const _ingredientsBox = 'ingredients';
  static const _menusBox = 'menus';
  static const _fixedCostsBox = 'fixed_costs';
  static const _packagingBox = 'packaging';
  static const _pricingProfilesBox = 'pricing_profiles';
  static const _salesLogsBox = 'sales_logs';
  static const _promotionsBox = 'promotion_configs';
  static const _syncCheckpointBox = 'sync_checkpoints';

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    await Hive.initFlutter();
    _registerAdapters();
    await Future.wait([
      Hive.openBox<IngredientEntity>(_ingredientsBox),
      Hive.openBox<MenuEntity>(_menusBox),
      Hive.openBox<FixedCostEntity>(_fixedCostsBox),
      Hive.openBox<PackagingEntity>(_packagingBox),
      Hive.openBox<PricingProfileEntity>(_pricingProfilesBox),
      Hive.openBox<SalesLogEntity>(_salesLogsBox),
      Hive.openBox<PromotionConfigEntity>(_promotionsBox),
      Hive.openBox<SyncCheckpointEntity>(_syncCheckpointBox),
    ]);
    _initialized = true;
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(IngredientPriceEntryAdapter().typeId)) {
      Hive.registerAdapter(IngredientPriceEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(IngredientEntityAdapter().typeId)) {
      Hive.registerAdapter(IngredientEntityAdapter());
    }
    if (!Hive.isAdapterRegistered(MenuItemEntityAdapter().typeId)) {
      Hive.registerAdapter(MenuItemEntityAdapter());
    }
    if (!Hive.isAdapterRegistered(MenuEntityAdapter().typeId)) {
      Hive.registerAdapter(MenuEntityAdapter());
    }
    if (!Hive.isAdapterRegistered(FixedCostEntityAdapter().typeId)) {
      Hive.registerAdapter(FixedCostEntityAdapter());
    }
    if (!Hive.isAdapterRegistered(PackagingEntityAdapter().typeId)) {
      Hive.registerAdapter(PackagingEntityAdapter());
    }
    if (!Hive.isAdapterRegistered(PricingProfileEntityAdapter().typeId)) {
      Hive.registerAdapter(PricingProfileEntityAdapter());
    }
    if (!Hive.isAdapterRegistered(SalesLogEntityAdapter().typeId)) {
      Hive.registerAdapter(SalesLogEntityAdapter());
    }
    if (!Hive.isAdapterRegistered(PromotionConfigEntityAdapter().typeId)) {
      Hive.registerAdapter(PromotionConfigEntityAdapter());
    }
    if (!Hive.isAdapterRegistered(SyncCheckpointEntityAdapter().typeId)) {
      Hive.registerAdapter(SyncCheckpointEntityAdapter());
    }
  }

  Future<void> saveIngredients(List<Ingredient> ingredients) async {
    final box = Hive.box<IngredientEntity>(_ingredientsBox);
    final now = DateTime.now();
    final entries = {
      for (final ingredient in ingredients)
        ingredient.id: IngredientEntity(
          id: ingredient.id,
          name: ingredient.name,
          price: ingredient.price,
          unit: ingredient.unit,
          updatedAt: now,
          priceHistory: [IngredientPriceEntry(price: ingredient.price, recordedAt: now)],
        ),
    };
    await _replaceBoxContents(box, entries);
  }

  List<Ingredient> loadIngredients() {
    final box = Hive.box<IngredientEntity>(_ingredientsBox);
    return box.values
        .map((entity) => Ingredient(
              id: entity.id,
              name: entity.name,
              price: entity.price,
              unit: entity.unit,
            ))
        .toList();
  }

  Future<void> saveMenus(List<Menu> menus) async {
    final box = Hive.box<MenuEntity>(_menusBox);
    final entries = {
      for (final menu in menus)
        menu.id: MenuEntity(
          id: menu.id,
          name: menu.name,
          items: menu.items
              .map((item) => MenuItemEntity(ingredientId: item.ingId, quantity: item.quantity))
              .toList(),
        ),
    };
    await _replaceBoxContents(box, entries);
  }

  List<Menu> loadMenus() {
    final box = Hive.box<MenuEntity>(_menusBox);
    return box.values
        .map((entity) => Menu(
              id: entity.id,
              name: entity.name,
              items: entity.items
                  .map((item) => MenuItemData(ingId: item.ingredientId, quantity: item.quantity))
                  .toList(),
            ))
        .toList();
  }

  Future<void> saveFixedCosts(List<FixedCost> fixedCosts) async {
    final box = Hive.box<FixedCostEntity>(_fixedCostsBox);
    final entries = {
      for (final cost in fixedCosts)
        cost.id: FixedCostEntity(id: cost.id, name: cost.name, amount: cost.amount),
    };
    await _replaceBoxContents(box, entries);
  }

  List<FixedCost> loadFixedCosts() {
    final box = Hive.box<FixedCostEntity>(_fixedCostsBox);
    return box.values
        .map((entity) => FixedCost(id: entity.id, name: entity.name, amount: entity.amount))
        .toList();
  }

  Future<void> savePackaging(List<Packaging> packaging) async {
    final box = Hive.box<PackagingEntity>(_packagingBox);
    final entries = {
      for (final item in packaging)
        item.id: PackagingEntity(id: item.id, name: item.name, price: item.price),
    };
    await _replaceBoxContents(box, entries);
  }

  List<Packaging> loadPackaging() {
    final box = Hive.box<PackagingEntity>(_packagingBox);
    return box.values
        .map((entity) => Packaging(id: entity.id, name: entity.name, price: entity.price))
        .toList();
  }

  Future<void> savePricingProfiles(List<PricingProfileEntity> profiles) async {
    final box = Hive.box<PricingProfileEntity>(_pricingProfilesBox);
    final entries = {for (final profile in profiles) profile.id: profile};
    await _replaceBoxContents(box, entries);
  }

  List<PricingProfileEntity> loadPricingProfiles() {
    final box = Hive.box<PricingProfileEntity>(_pricingProfilesBox);
    return box.values.toList();
  }

  Future<void> saveSalesLogs(List<SalesLogEntity> logs) async {
    final box = Hive.box<SalesLogEntity>(_salesLogsBox);
    final entries = {for (final log in logs) log.id: log};
    await _replaceBoxContents(box, entries);
  }

  List<SalesLogEntity> loadSalesLogs() {
    final box = Hive.box<SalesLogEntity>(_salesLogsBox);
    return box.values.toList();
  }

  Future<void> savePromotionConfigs(List<PromotionConfigEntity> configs) async {
    final box = Hive.box<PromotionConfigEntity>(_promotionsBox);
    final entries = {for (final config in configs) config.id: config};
    await _replaceBoxContents(box, entries);
  }

  List<PromotionConfigEntity> loadPromotionConfigs() {
    final box = Hive.box<PromotionConfigEntity>(_promotionsBox);
    return box.values.toList();
  }

  Future<void> saveSyncCheckpoint(SyncCheckpointEntity checkpoint) async {
    final box = Hive.box<SyncCheckpointEntity>(_syncCheckpointBox);
    await box.put(checkpoint.providerKey, checkpoint);
  }

  SyncCheckpointEntity? loadSyncCheckpoint(String providerKey) {
    final box = Hive.box<SyncCheckpointEntity>(_syncCheckpointBox);
    return box.get(providerKey);
  }

  Future<void> _replaceBoxContents<T>(
    Box<T> box,
    Map<dynamic, T> entries,
  ) async {
    final existingKeys = box.keys.toSet();
    await box.putAll(entries);
    final keysToDelete = existingKeys.difference(entries.keys.toSet());
    if (keysToDelete.isNotEmpty) {
      await box.deleteAll(keysToDelete);
    }
  }
}
