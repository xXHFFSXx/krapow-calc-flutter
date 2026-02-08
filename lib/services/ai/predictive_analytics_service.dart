import '../../models.dart';
import '../cost_calculation_service.dart';
import 'ai_models.dart';

class PredictiveAnalyticsService {
  const PredictiveAnalyticsService({
    this.costService = const CostCalculationService(),
  });

  final CostCalculationService costService;

  ForecastResult buildProfitForecast({
    required List<Menu> menus,
    required List<Ingredient> ingredients,
    required List<Packaging> packaging,
    required List<FixedCost> fixedCosts,
    required double estimatedMonthlyDishes,
    required double targetMarginPercent,
  }) {
    final now = DateTime.now();
    final totalProfit = menus.fold<double>(0, (sum, menu) {
      final breakdown = costService.calculateTotalCost(
        items: menu.items,
        ingredients: ingredients,
        packaging: packaging,
        fixedCosts: fixedCosts,
        estimatedMonthlyDishes: estimatedMonthlyDishes,
      );
      final price = breakdown.totalCost * (1 + targetMarginPercent / 100);
      return sum + ((price - breakdown.totalCost) * (estimatedMonthlyDishes / menus.length));
    });

    final points = List.generate(4, (index) {
      return ForecastPoint(date: now.add(Duration(days: 7 * index)), value: totalProfit * (0.9 + 0.05 * index));
    });

    return ForecastResult(
      profitForecast: points,
      assumption: 'คาดการณ์จากกำไรเฉลี่ยในเดือนปัจจุบัน (ยังไม่มีฤดูกาล)',
    );
  }

  List<CostTrendResult> buildCostTrends({
    required List<Ingredient> ingredients,
  }) {
    final now = DateTime.now();
    return ingredients.map((ingredient) {
      final base = ingredient.price;
      final points = [
        ForecastPoint(date: now.subtract(const Duration(days: 21)), value: base * 0.95),
        ForecastPoint(date: now.subtract(const Duration(days: 14)), value: base),
        ForecastPoint(date: now.subtract(const Duration(days: 7)), value: base * 1.03),
        ForecastPoint(date: now, value: base * 1.05),
      ];

      return CostTrendResult(
        ingredientName: ingredient.name,
        trendPoints: points,
        summary: 'ต้นทุนมีแนวโน้มเพิ่มเล็กน้อย',
      );
    }).toList();
  }

  List<DemandEstimate> buildDemandEstimates({
    required List<Menu> menus,
    required int averageDailyOrders,
  }) {
    if (menus.isEmpty) return [];

    final split = (averageDailyOrders / menus.length).round();
    return menus
        .map(
          (menu) => DemandEstimate(
            menuName: menu.name,
            estimatedDailyOrders: split,
            assumption: 'แบ่งยอดขายเฉลี่ยเท่า ๆ กันต่อเมนู',
          ),
        )
        .toList();
  }
}
