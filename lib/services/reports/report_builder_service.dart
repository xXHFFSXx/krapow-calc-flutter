import '../../models.dart';
import '../cost_calculation_service.dart';
import '../pricing_recommendation_service.dart';
import 'report_models.dart';

class ReportBuilderService {
  const ReportBuilderService({
    this.costService = const CostCalculationService(),
    this.pricingService = const PricingRecommendationService(),
  });

  final CostCalculationService costService;
  final PricingRecommendationService pricingService;

  ProfitSummaryReport buildProfitSummary({
    required String periodLabel,
    required double totalRevenue,
    required double totalCost,
  }) {
    return ProfitSummaryReport(
      periodLabel: periodLabel,
      totalRevenue: totalRevenue,
      totalCost: totalCost,
      netProfit: totalRevenue - totalCost,
    );
  }

  List<CostBreakdownReport> buildCostBreakdownReports({
    required List<Menu> menus,
    required List<Ingredient> ingredients,
    required List<Packaging> packaging,
    required List<FixedCost> fixedCosts,
    required double estimatedMonthlyDishes,
  }) {
    return menus.map((menu) {
      final breakdown = costService.calculateTotalCost(
        items: menu.items,
        ingredients: ingredients,
        packaging: packaging,
        fixedCosts: fixedCosts,
        estimatedMonthlyDishes: estimatedMonthlyDishes,
      );
      return CostBreakdownReport(
        menuName: menu.name,
        ingredientCost: breakdown.ingredientCost,
        packagingCost: breakdown.packagingCost,
        fixedCostPerDish: breakdown.fixedCostPerDish,
        totalCost: breakdown.totalCost,
      );
    }).toList();
  }

  List<MenuProfitabilityReport> buildMenuProfitabilityReports({
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
      return MenuProfitabilityReport(
        menuName: menu.name,
        price: price,
        profitPerDish: price - breakdown.totalCost,
      );
    }).toList();
  }
}
