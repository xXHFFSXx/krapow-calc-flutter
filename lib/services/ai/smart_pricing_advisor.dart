import '../../models.dart';
import '../cost_calculation_service.dart';
import '../pricing_recommendation_service.dart';
import '../promotion_simulation_service.dart';
import 'ai_models.dart';

class SmartPricingAdvisor {
  const SmartPricingAdvisor({
    this.costService = const CostCalculationService(),
    this.pricingService = const PricingRecommendationService(),
    this.promotionService = const PromotionSimulationService(),
  });

  final CostCalculationService costService;
  final PricingRecommendationService pricingService;
  final PromotionSimulationService promotionService;

  PricingSuggestion suggestPrice({
    required Menu menu,
    required List<Ingredient> ingredients,
    required List<Packaging> packaging,
    required List<FixedCost> fixedCosts,
    required double estimatedMonthlyDishes,
    required double currentPrice,
    required double targetMarginPercent,
  }) {
    final breakdown = costService.calculateTotalCost(
      items: menu.items,
      ingredients: ingredients,
      packaging: packaging,
      fixedCosts: fixedCosts,
      estimatedMonthlyDishes: estimatedMonthlyDishes,
    );
    final suggestedPrice = pricingService.calculateSuggestedPrice(
      totalCost: breakdown.totalCost,
      targetMarginPercent: targetMarginPercent,
    );
    // Guard against zero or negative current price to avoid NaN/Infinity.
    final marginChange =
        currentPrice > 0 ? ((suggestedPrice - currentPrice) / currentPrice) * 100 : 0.0;
    final reason = suggestedPrice > currentPrice
        ? 'เพิ่มราคานิดหน่อยเพื่อให้กำไรตามเป้าหมาย'
        : 'ราคาปัจจุบันสูงกว่าที่จำเป็นสำหรับกำไรเป้าหมาย';

    return PricingSuggestion(
      currentPrice: currentPrice,
      suggestedPrice: suggestedPrice,
      marginChangePercent: marginChange,
      reason: reason,
    );
  }

  DecisionInsight buildMarginInsight({
    required double currentMarginPercent,
    required double targetMarginPercent,
  }) {
    if (currentMarginPercent >= targetMarginPercent) {
      return const DecisionInsight(
        title: 'กำไรเข้าเป้า',
        message: 'อัตรากำไรตอนนี้อยู่ในระดับที่ต้องการแล้ว',
        severity: InsightSeverity.info,
      );
    }

    return DecisionInsight(
      title: 'กำไรยังต่ำกว่าเป้า',
      message: 'ลองเพิ่มราคาขายหรือปรับปริมาณวัตถุดิบให้พอดีขึ้น',
      severity: InsightSeverity.warning,
      actionLabel: 'ดูคำแนะนำราคาใหม่',
    );
  }

  PromotionRiskAssessment assessPromotionRisk({
    required Menu menu,
    required List<Ingredient> ingredients,
    required List<Packaging> packaging,
    required List<FixedCost> fixedCosts,
    required double estimatedMonthlyDishes,
    required double targetMarginPercent,
    required double discountPercent,
    required double totalFixedCosts,
  }) {
    final result = promotionService.simulatePercentageDiscount(
      items: menu.items,
      ingredients: ingredients,
      packaging: packaging,
      fixedCosts: fixedCosts,
      estimatedMonthlyDishes: estimatedMonthlyDishes,
      targetMarginPercent: targetMarginPercent,
      discountPercent: discountPercent,
      totalFixedCosts: totalFixedCosts,
    );
    final isRisky = result.impact.netProfitPerDish < 0;
    final note = isRisky
        ? 'กำไรติดลบหลังทำโปรโมชัน ลองลดส่วนลดหรือเพิ่มยอดขายขั้นต่ำ'
        : 'โปรโมชันนี้ยังมีกำไรอยู่';

    return PromotionRiskAssessment(
      promoPrice: result.impact.effectivePrice,
      expectedProfit: result.impact.netProfitPerDish,
      isRisky: isRisky,
      note: note,
    );
  }
}
