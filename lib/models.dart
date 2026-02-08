class Ingredient {
  String id;
  String name;
  double price;
  String unit;

  Ingredient({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
  });
}

class Packaging {
  String id;
  String name;
  double price;

  Packaging({required this.id, required this.name, required this.price});
}

class FixedCost {
  String id;
  String name;
  double amount;

  FixedCost({required this.id, required this.name, required this.amount});
}

class MenuItemData {
  String ingId;
  double quantity;

  MenuItemData({required this.ingId, required this.quantity});
}

class Menu {
  String id;
  String name;
  List<MenuItemData> items;

  Menu({required this.id, required this.name, required this.items});
}

class CostBreakdown {
  final double ingredientCost;
  final double packagingCost;
  final double fixedCostPerDish;
  final double wasteCost;
  final double totalCost;

  const CostBreakdown({
    required this.ingredientCost,
    required this.packagingCost,
    required this.fixedCostPerDish,
    required this.wasteCost,
    required this.totalCost,
  });
}

class PricingResult {
  final double dineInPrice;
  final double deliveryPrice;
  final double netProfitPerDish;

  const PricingResult({
    required this.dineInPrice,
    required this.deliveryPrice,
    required this.netProfitPerDish,
  });
}

class BreakEvenResult {
  final double breakEvenPerMenu;
  final double dailyBreakEven;
  final double promotionAdjustedBreakEven;

  const BreakEvenResult({
    required this.breakEvenPerMenu,
    required this.dailyBreakEven,
    required this.promotionAdjustedBreakEven,
  });
}

class PromotionImpact {
  final double effectivePrice;
  final double netProfitPerDish;
  final double breakEvenQuantity;
  final double priceDrop;

  const PromotionImpact({
    required this.effectivePrice,
    required this.netProfitPerDish,
    required this.breakEvenQuantity,
    required this.priceDrop,
  });
}

class PromotionCostSummary {
  final double basePrice;
  final double promoPrice;
  final double totalCost;
  final double profitChange;

  const PromotionCostSummary({
    required this.basePrice,
    required this.promoPrice,
    required this.totalCost,
    required this.profitChange,
  });
}

class PromotionSimulationResult {
  final PromotionImpact impact;
  final PromotionCostSummary summary;

  const PromotionSimulationResult({
    required this.impact,
    required this.summary,
  });
}

class PlatformPricing {
  final String platformName;
  final double gpRate;
  final double recommendedListedPrice;
  final double netProfitAtBasePrice;

  const PlatformPricing({
    required this.platformName,
    required this.gpRate,
    required this.recommendedListedPrice,
    required this.netProfitAtBasePrice,
  });
}

class PricingIntelligenceResult {
  final double baseDineInPrice;
  final List<PlatformPricing> platformPricing;

  const PricingIntelligenceResult({
    required this.baseDineInPrice,
    required this.platformPricing,
  });
}
