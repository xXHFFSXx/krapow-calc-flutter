import '../models.dart';
import 'cost_calculation_service.dart';
import 'pricing_recommendation_service.dart';

class PricingIntelligenceService {
  const PricingIntelligenceService({
    this.costService = const CostCalculationService(),
    this.pricingService = const PricingRecommendationService(),
  });

  final CostCalculationService costService;
  final PricingRecommendationService pricingService;

  /// Example usage:
  /// final result = service.buildPlatformPricing(
  ///   items: menu.items,
  ///   ingredients: ingredients,
  ///   packaging: packaging,
  ///   fixedCosts: fixedCosts,
  ///   estimatedMonthlyDishes: 1200,
  ///   targetMarginPercent: 20,
  ///   platformGpRates: {
  ///     'Grab': 0.33,
  ///     'Lineman': 0.30,
  ///     'Robinhood': 0.15,
  ///     'ShopeeFood': 0.32,
  ///   },
  /// );
  PricingIntelligenceResult buildPlatformPricing({
    required List<MenuItemData> items,
    required List<Ingredient> ingredients,
    required List<Packaging> packaging,
    required List<FixedCost> fixedCosts,
    required double estimatedMonthlyDishes,
    required double targetMarginPercent,
    required Map<String, double> platformGpRates,
    double wastePercent = 0,
  }) {
    final breakdown = costService.calculateTotalCost(
      items: items,
      ingredients: ingredients,
      packaging: packaging,
      fixedCosts: fixedCosts,
      estimatedMonthlyDishes: estimatedMonthlyDishes,
      wastePercent: wastePercent,
    );
    final baseDineInPrice = pricingService.calculateSuggestedPrice(
      totalCost: breakdown.totalCost,
      targetMarginPercent: targetMarginPercent,
    );

    final platformPricing = platformGpRates.entries.map((entry) {
      final recommendedListedPrice = costService.calculateDeliveryPrice(
        dineInPrice: baseDineInPrice,
        gpRate: entry.value,
      );
      final netProfitAtBasePrice =
          (baseDineInPrice * (1 - entry.value)) - breakdown.totalCost;

      return PlatformPricing(
        platformName: entry.key,
        gpRate: entry.value,
        recommendedListedPrice: recommendedListedPrice,
        netProfitAtBasePrice: netProfitAtBasePrice,
      );
    }).toList();

    return PricingIntelligenceResult(
      baseDineInPrice: baseDineInPrice,
      platformPricing: platformPricing,
    );
  }
}
