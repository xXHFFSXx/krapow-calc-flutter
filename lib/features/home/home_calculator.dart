import 'dart:developer' as developer;

import '../../models.dart';

class MenuItemDetail {
  const MenuItemDetail({
    required this.rawItem,
    required this.name,
    required this.price,
    required this.unit,
    required this.cost,
  });

  final MenuItemData rawItem;
  final String name;
  final double price;
  final String unit;
  final double cost;

  String get ingId => rawItem.ingId;
  double get quantity => rawItem.quantity;
}

class MenuPricingData {
  const MenuPricingData({
    required this.menu,
    required this.detailedItems,
    required this.foodCost,
    required this.pkgCost,
    required this.hiddenCost,
    required this.totalCost,
    required this.sellingPrice,
    required this.deliveryPrice,
  });

  final Menu menu;
  final List<MenuItemDetail> detailedItems;
  final double foodCost;
  final double pkgCost;
  final double hiddenCost;
  final double totalCost;
  final double sellingPrice;
  final double deliveryPrice;
}

class HomeCalculator {
  const HomeCalculator();

  static double calculateHiddenCostPerBox({
    required List<FixedCost> fixedCosts,
    required double estimatedBoxes,
  }) {
    final totalFixed = fixedCosts.fold(0.0, (sum, item) => sum + item.amount);
    return estimatedBoxes > 0 ? totalFixed / estimatedBoxes : 0;
  }

  static double calculateTotalPackaging({
    required List<Packaging> packaging,
  }) {
    return packaging.fold(0.0, (sum, item) => sum + item.price);
  }

  static Ingredient getIngredientDetails({
    required List<Ingredient> ingredients,
    required String ingId,
  }) {
    return ingredients.firstWhere(
      (ingredient) => ingredient.id == ingId,
      orElse: () => Ingredient(id: 'unknown', name: 'Unknown', price: 0, unit: '-'),
    );
  }

  static MenuPricingData? buildMenuData({
    required String? selectedMenuId,
    required List<Menu> menus,
    required List<Ingredient> ingredients,
    required List<Packaging> packaging,
    required List<FixedCost> fixedCosts,
    required double estimatedBoxes,
    required double targetMargin,
  }) {
    if (selectedMenuId == null) return null;
    try {
      final menu = menus.firstWhere((menu) => menu.id == selectedMenuId);
      double foodCost = 0;
      final detailedItems = <MenuItemDetail>[];

      for (final item in menu.items) {
        final details = getIngredientDetails(
          ingredients: ingredients,
          ingId: item.ingId,
        );
        final cost = details.price * item.quantity;
        foodCost += cost;
        detailedItems.add(
          MenuItemDetail(
            rawItem: item,
            name: details.name,
            price: details.price,
            unit: details.unit,
            cost: cost,
          ),
        );
      }

      final pkgCost = calculateTotalPackaging(packaging: packaging);
      final hiddenCost = calculateHiddenCostPerBox(
        fixedCosts: fixedCosts,
        estimatedBoxes: estimatedBoxes,
      );
      final totalCost = foodCost + pkgCost + hiddenCost;

      final sellingPrice = totalCost * (1 + (targetMargin / 100));
      const gpRate = 0.33;
      final deliveryPrice = sellingPrice / (1 - gpRate);

      return MenuPricingData(
        menu: menu,
        detailedItems: detailedItems,
        foodCost: foodCost,
        pkgCost: pkgCost,
        hiddenCost: hiddenCost,
        totalCost: totalCost,
        sellingPrice: sellingPrice,
        deliveryPrice: deliveryPrice,
      );
    } catch (error) {
      developer.log('Failed to build menu data: $error', name: 'HomeCalculator');
      return null;
    }
  }
}
