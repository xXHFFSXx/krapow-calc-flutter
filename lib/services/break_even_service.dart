import '../models.dart';

class BreakEvenService {
  const BreakEvenService();

  /// Break-even per menu item:
  /// Fixed costs / contribution per dish.
  double calculateBreakEvenPerMenu({
    required double totalFixedCosts,
    required double sellingPrice,
    required double variableCost,
  }) {
    final contribution = sellingPrice - variableCost;
    if (contribution <= 0) return double.infinity;
    return totalFixedCosts / contribution;
  }

  /// Daily overall break-even:
  /// Monthly fixed costs / (days open * average contribution per dish).
  double calculateDailyBreakEven({
    required double totalFixedCosts,
    required int daysOpenPerMonth,
    required double averageContributionPerDish,
  }) {
    if (daysOpenPerMonth <= 0 || averageContributionPerDish <= 0) {
      return double.infinity;
    }
    return totalFixedCosts / (daysOpenPerMonth * averageContributionPerDish);
  }

  /// Promotion-adjusted break-even:
  /// Replace selling price with discounted price (or effective price).
  double calculatePromotionAdjustedBreakEven({
    required double totalFixedCosts,
    required double promoEffectivePrice,
    required double variableCost,
  }) {
    final contribution = promoEffectivePrice - variableCost;
    if (contribution <= 0) return double.infinity;
    return totalFixedCosts / contribution;
  }

  BreakEvenResult calculateSummary({
    required double totalFixedCosts,
    required double sellingPrice,
    required double variableCost,
    required int daysOpenPerMonth,
    required double averageContributionPerDish,
    required double promoEffectivePrice,
  }) {
    return BreakEvenResult(
      breakEvenPerMenu: calculateBreakEvenPerMenu(
        totalFixedCosts: totalFixedCosts,
        sellingPrice: sellingPrice,
        variableCost: variableCost,
      ),
      dailyBreakEven: calculateDailyBreakEven(
        totalFixedCosts: totalFixedCosts,
        daysOpenPerMonth: daysOpenPerMonth,
        averageContributionPerDish: averageContributionPerDish,
      ),
      promotionAdjustedBreakEven: calculatePromotionAdjustedBreakEven(
        totalFixedCosts: totalFixedCosts,
        promoEffectivePrice: promoEffectivePrice,
        variableCost: variableCost,
      ),
    );
  }
}
