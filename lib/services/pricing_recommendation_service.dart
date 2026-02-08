import '../models.dart';
import 'cost_calculation_service.dart';

class PricingRecommendationService {
  const PricingRecommendationService({
    this.costService = const CostCalculationService(),
  });

  final CostCalculationService costService;

  /// Suggested selling price based on target margin.
  /// targetMarginPercent example: 20 for 20%.
  double calculateSuggestedPrice({
    required double totalCost,
    required double targetMarginPercent,
  }) {
    return totalCost * (1 + (targetMarginPercent / 100));
  }

  /// Delivery vs dine-in pricing with GP rate impact.
  PricingResult calculatePricing({
    required CostBreakdown breakdown,
    required double targetMarginPercent,
    required double gpRate,
  }) {
    final dineInPrice = calculateSuggestedPrice(
      totalCost: breakdown.totalCost,
      targetMarginPercent: targetMarginPercent,
    );
    final deliveryPrice = costService.calculateDeliveryPrice(
      dineInPrice: dineInPrice,
      gpRate: gpRate,
    );

    // Net profit per dish (dine-in): price - total cost.
    final netProfitPerDish = dineInPrice - breakdown.totalCost;

    return PricingResult(
      dineInPrice: dineInPrice,
      deliveryPrice: deliveryPrice,
      netProfitPerDish: netProfitPerDish,
    );
  }
}
