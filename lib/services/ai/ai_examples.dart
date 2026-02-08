import '../../models.dart';
import 'menu_intelligence_service.dart';
import 'predictive_analytics_service.dart';
import 'smart_alert_service.dart';
import 'smart_pricing_advisor.dart';

void aiDecisionSupportExample({
  required Menu menu,
  required List<Menu> menus,
  required List<Ingredient> ingredients,
  required List<Packaging> packaging,
  required List<FixedCost> fixedCosts,
}) {
  const pricingAdvisor = SmartPricingAdvisor();
  const analyticsService = PredictiveAnalyticsService();
  const menuService = MenuIntelligenceService();
  const alertService = SmartAlertService();

  pricingAdvisor.suggestPrice(
    menu: menu,
    ingredients: ingredients,
    packaging: packaging,
    fixedCosts: fixedCosts,
    estimatedMonthlyDishes: 1200,
    currentPrice: 60,
    targetMarginPercent: 20,
  );

  analyticsService.buildProfitForecast(
    menus: menus,
    ingredients: ingredients,
    packaging: packaging,
    fixedCosts: fixedCosts,
    estimatedMonthlyDishes: 1200,
    targetMarginPercent: 20,
  );

  menuService.buildMenuInsights(
    menus: menus,
    ingredients: ingredients,
    packaging: packaging,
    fixedCosts: fixedCosts,
    estimatedMonthlyDishes: 1200,
    targetMarginPercent: 20,
  );

  alertService.buildCostAnomalyAlerts(
    ingredients: ingredients,
    previousPrices: {for (final ingredient in ingredients) ingredient.id: ingredient.price},
    spikeThresholdPercent: 10,
  );
}
