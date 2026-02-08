import '../../models.dart';
import '../cost_calculation_service.dart';
import '../pricing_recommendation_service.dart';
import 'ai_models.dart';

class MenuIntelligenceService {
  const MenuIntelligenceService({
    this.costService = const CostCalculationService(),
    this.pricingService = const PricingRecommendationService(),
  });

  final CostCalculationService costService;
  final PricingRecommendationService pricingService;

  List<MenuInsight> buildMenuInsights({
    required List<Menu> menus,
    required List<Ingredient> ingredients,
    required List<Packaging> packaging,
    required List<FixedCost> fixedCosts,
    required double estimatedMonthlyDishes,
    required double targetMarginPercent,
  }) {
    return menus.map((menu) {
      final breakdown = costService.calculateTotalCost(
        items: menu.items,
        ingredients: ingredients,
        packaging: packaging,
        fixedCosts: fixedCosts,
        estimatedMonthlyDishes: estimatedMonthlyDishes,
      );
      final price = pricingService.calculateSuggestedPrice(
        totalCost: breakdown.totalCost,
        targetMarginPercent: targetMarginPercent,
      );
      final profitPerDish = price - breakdown.totalCost;
      final recommendation = profitPerDish <= 0
          ? 'กำไรติดลบ ลองปรับราคา/สูตร หรือย้ายเป็นเมนูเสริม'
          : 'เมนูกำไรดี สามารถดันยอดขายได้';

      return MenuInsight(
        menuName: menu.name,
        profitPerDish: profitPerDish,
        recommendation: recommendation,
      );
    }).toList();
  }
}
