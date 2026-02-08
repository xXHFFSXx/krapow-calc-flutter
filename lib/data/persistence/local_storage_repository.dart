import 'package:hive_flutter/hive_flutter.dart';

import '../../models.dart';
import 'entities.dart';

class LocalStorageRepository {
  LocalStorageRepository();

  static const _ingredientsBox = 'ingredients';
  static const _menusBox = 'menus';
  static const _fixedCostsBox = 'fixed_costs';
  static const _packagingBox = 'packaging';
  static const _pricingProfilesBox = 'pricing_profiles';
  static const _salesLogsBox = 'sales_logs';
  static const _promotionsBox = 'promotion_configs';

  Future<void> init() async {
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
    ]);
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
  }

  Future<void> saveIngredients(List<Ingredient> ingredients) async {
    final box = Hive.box<IngredientEntity>(_ingredientsBox);
    await box.clear();
    for (final ingredient in ingredients) {
      final entity = IngredientEntity(
        id: ingredient.id,
        name: ingredient.name,
        price: ingredient.price,
        unit: ingredient.unit,
        updatedAt: DateTime.now(),
        priceHistory: [IngredientPriceEntry(price: ingredient.price, recordedAt: DateTime.now())],
      );
      await box.put(entity.id, entity);
    }
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
    await box.clear();
    for (final menu in menus) {
      final items = menu.items
          .map((item) => MenuItemEntity(ingredientId: item.ingId, quantity: item.quantity))
          .toList();
      await box.put(menu.id, MenuEntity(id: menu.id, name: menu.name, items: items));
    }
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
    await box.clear();
    for (final cost in fixedCosts) {
      await box.put(cost.id, FixedCostEntity(id: cost.id, name: cost.name, amount: cost.amount));
    }
  }

  List<FixedCost> loadFixedCosts() {
    final box = Hive.box<FixedCostEntity>(_fixedCostsBox);
    return box.values
        .map((entity) => FixedCost(id: entity.id, name: entity.name, amount: entity.amount))
        .toList();
  }

  Future<void> savePackaging(List<Packaging> packaging) async {
    final box = Hive.box<PackagingEntity>(_packagingBox);
    await box.clear();
    for (final item in packaging) {
      await box.put(item.id, PackagingEntity(id: item.id, name: item.name, price: item.price));
    }
  }

  List<Packaging> loadPackaging() {
    final box = Hive.box<PackagingEntity>(_packagingBox);
    return box.values
        .map((entity) => Packaging(id: entity.id, name: entity.name, price: entity.price))
        .toList();
  }

  Future<void> savePricingProfiles(List<PricingProfileEntity> profiles) async {
    final box = Hive.box<PricingProfileEntity>(_pricingProfilesBox);
    await box.clear();
    for (final profile in profiles) {
      await box.put(profile.id, profile);
    }
  }

  List<PricingProfileEntity> loadPricingProfiles() {
    final box = Hive.box<PricingProfileEntity>(_pricingProfilesBox);
    return box.values.toList();
  }

  Future<void> saveSalesLogs(List<SalesLogEntity> logs) async {
    final box = Hive.box<SalesLogEntity>(_salesLogsBox);
    await box.clear();
    for (final log in logs) {
      await box.put(log.id, log);
    }
  }

  List<SalesLogEntity> loadSalesLogs() {
    final box = Hive.box<SalesLogEntity>(_salesLogsBox);
    return box.values.toList();
  }

  Future<void> savePromotionConfigs(List<PromotionConfigEntity> configs) async {
    final box = Hive.box<PromotionConfigEntity>(_promotionsBox);
    await box.clear();
    for (final config in configs) {
      await box.put(config.id, config);
    }
  }

  List<PromotionConfigEntity> loadPromotionConfigs() {
    final box = Hive.box<PromotionConfigEntity>(_promotionsBox);
    return box.values.toList();
  }
}
