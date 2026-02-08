import '../../models.dart';
import '../cost_calculation_service.dart';
import 'ai_models.dart';

class SmartAlertService {
  const SmartAlertService({this.costService = const CostCalculationService()});

  final CostCalculationService costService;

  List<AlertMessage> buildCostAnomalyAlerts({
    required List<Ingredient> ingredients,
    required Map<String, double> previousPrices,
    required double spikeThresholdPercent,
  }) {
    final alerts = <AlertMessage>[];
    for (final ingredient in ingredients) {
      final previous = previousPrices[ingredient.id];
      if (previous == null || previous <= 0) continue;
      final changePercent = ((ingredient.price - previous) / previous) * 100;
      if (changePercent >= spikeThresholdPercent) {
        alerts.add(
          AlertMessage(
            title: 'ต้นทุนวัตถุดิบสูงผิดปกติ',
            message: '${ingredient.name} ราคาขึ้น ${changePercent.toStringAsFixed(0)}%',
            severity: InsightSeverity.warning,
          ),
        );
      }
    }
    return alerts;
  }

  List<AlertMessage> buildProfitDropAlerts({
    required List<Menu> menus,
    required List<Ingredient> ingredients,
    required List<Packaging> packaging,
    required List<FixedCost> fixedCosts,
    required double estimatedMonthlyDishes,
    required double targetMarginPercent,
    required double minimumProfitPerDish,
  }) {
    final alerts = <AlertMessage>[];
    for (final menu in menus) {
      final breakdown = costService.calculateTotalCost(
        items: menu.items,
        ingredients: ingredients,
        packaging: packaging,
        fixedCosts: fixedCosts,
        estimatedMonthlyDishes: estimatedMonthlyDishes,
      );
      final price = breakdown.totalCost * (1 + targetMarginPercent / 100);
      final profit = price - breakdown.totalCost;
      if (profit < minimumProfitPerDish) {
        alerts.add(
          AlertMessage(
            title: 'กำไรต่อจานต่ำ',
            message: '${menu.name} กำไรต่ำกว่า ${minimumProfitPerDish.toStringAsFixed(0)} บาท',
            severity: InsightSeverity.warning,
          ),
        );
      }
    }
    return alerts;
  }

  AlertMessage buildPromotionRiskAlert({
    required String promoName,
    required double profitPerDish,
  }) {
    final isNegative = profitPerDish < 0;
    return AlertMessage(
      title: 'โปรโมชันเสี่ยงขาดทุน',
      message: isNegative
          ? '$promoName ทำให้กำไรติดลบ ลองลดส่วนลดหรือเพิ่มยอดขายขั้นต่ำ'
          : '$promoName ยังมีกำไรอยู่',
      severity: isNegative ? InsightSeverity.critical : InsightSeverity.info,
    );
  }
}
