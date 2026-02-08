import '../models.dart';

class CostCalculationService {
  const CostCalculationService();

  /// Ingredient cost per dish with optional waste/spoilage adjustment.
  /// wastePercent example: 0.05 for 5% waste.
  double calculateIngredientCost({
    required List<MenuItemData> items,
    required List<Ingredient> ingredients,
    double wastePercent = 0,
  }) {
    final baseCost = items.fold(0.0, (sum, item) {
      final ingredient = ingredients.firstWhere(
        (ing) => ing.id == item.ingId,
        orElse: () => Ingredient(id: 'unknown', name: 'Unknown', price: 0, unit: '-'),
      );
      return sum + (ingredient.price * item.quantity);
    });

    // Waste/spoilage adjustment: add a small % of ingredient cost.
    return baseCost * (1 + wastePercent);
  }

  /// Sum of packaging items per dish.
  double calculatePackagingCost(List<Packaging> packaging) {
    return packaging.fold(0.0, (sum, item) => sum + item.price);
  }

  /// Fixed cost allocation per dish.
  /// totalFixed / estimatedMonthlyDishes.
  double calculateFixedCostPerDish({
    required List<FixedCost> fixedCosts,
    required double estimatedMonthlyDishes,
  }) {
    final totalFixed = fixedCosts.fold(0.0, (sum, item) => sum + item.amount);
    if (estimatedMonthlyDishes <= 0) return 0;
    return totalFixed / estimatedMonthlyDishes;
  }

  /// Consolidated cost breakdown for a dish.
  CostBreakdown calculateTotalCost({
    required List<MenuItemData> items,
    required List<Ingredient> ingredients,
    required List<Packaging> packaging,
    required List<FixedCost> fixedCosts,
    required double estimatedMonthlyDishes,
    double wastePercent = 0,
  }) {
    final ingredientCost = calculateIngredientCost(
      items: items,
      ingredients: ingredients,
      wastePercent: wastePercent,
    );
    final packagingCost = calculatePackagingCost(packaging);
    final fixedCostPerDish = calculateFixedCostPerDish(
      fixedCosts: fixedCosts,
      estimatedMonthlyDishes: estimatedMonthlyDishes,
    );
    final wasteCost = ingredientCost - (ingredientCost / (1 + wastePercent));
    final totalCost = ingredientCost + packagingCost + fixedCostPerDish;

    return CostBreakdown(
      ingredientCost: ingredientCost,
      packagingCost: packagingCost,
      fixedCostPerDish: fixedCostPerDish,
      wasteCost: wasteCost,
      totalCost: totalCost,
    );
  }

  /// Delivery GP commission impact.
  /// For a given dine-in price, return required delivery price to cover GP.
  double calculateDeliveryPrice({
    required double dineInPrice,
    required double gpRate,
  }) {
    if (gpRate >= 1) return dineInPrice;
    return dineInPrice / (1 - gpRate);
  }
}
