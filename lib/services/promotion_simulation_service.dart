import '../models.dart';
import 'break_even_service.dart';
import 'cost_calculation_service.dart';
import 'pricing_recommendation_service.dart';

class PromotionSimulationService {
  const PromotionSimulationService({
    this.costService = const CostCalculationService(),
    this.pricingService = const PricingRecommendationService(),
    this.breakEvenService = const BreakEvenService(),
  });

  final CostCalculationService costService;
  final PricingRecommendationService pricingService;
  final BreakEvenService breakEvenService;

  /// Example usage:
  /// final result = service.simulatePercentageDiscount(
  ///   items: menu.items,
  ///   ingredients: ingredients,
  ///   packaging: packaging,
  ///   fixedCosts: fixedCosts,
  ///   estimatedMonthlyDishes: 1200,
  ///   targetMarginPercent: 20,
  ///   discountPercent: 10,
  ///   totalFixedCosts: 7600,
  /// );
  PromotionSimulationResult simulatePercentageDiscount({
    required List<MenuItemData> items,
    required List<Ingredient> ingredients,
    required List<Packaging> packaging,
    required List<FixedCost> fixedCosts,
    required double estimatedMonthlyDishes,
    required double targetMarginPercent,
    required double discountPercent,
    required double totalFixedCosts,
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
    final basePrice = pricingService.calculateSuggestedPrice(
      totalCost: breakdown.totalCost,
      targetMarginPercent: targetMarginPercent,
    );
    final promoPrice = basePrice * (1 - (discountPercent / 100));

    return _buildResult(
      basePrice: basePrice,
      promoPrice: promoPrice,
      breakdown: breakdown,
      totalFixedCosts: totalFixedCosts,
    );
  }

  /// Buy 1 Get 1: effective price per dish is half of base price.
  PromotionSimulationResult simulateBuyOneGetOne({
    required List<MenuItemData> items,
    required List<Ingredient> ingredients,
    required List<Packaging> packaging,
    required List<FixedCost> fixedCosts,
    required double estimatedMonthlyDishes,
    required double targetMarginPercent,
    required double totalFixedCosts,
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
    final basePrice = pricingService.calculateSuggestedPrice(
      totalCost: breakdown.totalCost,
      targetMarginPercent: targetMarginPercent,
    );
    final promoPrice = basePrice / 2;

    return _buildResult(
      basePrice: basePrice,
      promoPrice: promoPrice,
      breakdown: breakdown,
      totalFixedCosts: totalFixedCosts,
    );
  }

  /// Bundle pricing: use bundle price and quantity to compute effective price per dish.
  PromotionSimulationResult simulateBundlePricing({
    required List<MenuItemData> items,
    required List<Ingredient> ingredients,
    required List<Packaging> packaging,
    required List<FixedCost> fixedCosts,
    required double estimatedMonthlyDishes,
    required double targetMarginPercent,
    required double bundlePrice,
    required int bundleQuantity,
    required double totalFixedCosts,
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
    final basePrice = pricingService.calculateSuggestedPrice(
      totalCost: breakdown.totalCost,
      targetMarginPercent: targetMarginPercent,
    );
    final promoPrice = bundleQuantity > 0 ? bundlePrice / bundleQuantity : 0;

    return _buildResult(
      basePrice: basePrice,
      promoPrice: promoPrice,
      breakdown: breakdown,
      totalFixedCosts: totalFixedCosts,
    );
  }

  /// Delivery platform campaign:
  /// 1) apply campaign discount, then
  /// 2) apply platform GP cut to get net revenue per dish.
  PromotionSimulationResult simulatePlatformCampaign({
    required List<MenuItemData> items,
    required List<Ingredient> ingredients,
    required List<Packaging> packaging,
    required List<FixedCost> fixedCosts,
    required double estimatedMonthlyDishes,
    required double targetMarginPercent,
    required double campaignDiscountPercent,
    required double gpRate,
    required double totalFixedCosts,
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
    final basePrice = pricingService.calculateSuggestedPrice(
      totalCost: breakdown.totalCost,
      targetMarginPercent: targetMarginPercent,
    );
    final discountedPrice = basePrice * (1 - (campaignDiscountPercent / 100));
    final promoPrice = discountedPrice * (1 - gpRate);

    return _buildResult(
      basePrice: basePrice,
      promoPrice: promoPrice,
      breakdown: breakdown,
      totalFixedCosts: totalFixedCosts,
    );
  }

  PromotionSimulationResult _buildResult({
    required double basePrice,
    required double promoPrice,
    required CostBreakdown breakdown,
    required double totalFixedCosts,
  }) {
    final variableCost = breakdown.ingredientCost + breakdown.packagingCost;
    final breakEvenQuantity = breakEvenService.calculatePromotionAdjustedBreakEven(
      totalFixedCosts: totalFixedCosts,
      promoEffectivePrice: promoPrice,
      variableCost: variableCost,
    );
    final baseProfit = basePrice - breakdown.totalCost;
    final promoProfit = promoPrice - breakdown.totalCost;

    return PromotionSimulationResult(
      impact: PromotionImpact(
        effectivePrice: promoPrice,
        netProfitPerDish: promoProfit,
        breakEvenQuantity: breakEvenQuantity,
        priceDrop: basePrice - promoPrice,
      ),
      summary: PromotionCostSummary(
        basePrice: basePrice,
        promoPrice: promoPrice,
        totalCost: breakdown.totalCost,
        profitChange: promoProfit - baseProfit,
      ),
    );
  }
}
