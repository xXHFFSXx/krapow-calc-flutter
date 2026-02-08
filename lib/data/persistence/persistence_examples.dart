import '../../models.dart';
import '../../services/cost_calculation_service.dart';
import '../../services/pricing_recommendation_service.dart';
import 'local_storage_repository.dart';

/// Example usage:
/// final storage = LocalStorageRepository();
/// await storage.init();
/// await storage.saveIngredients(ingredients);
/// final savedIngredients = storage.loadIngredients();
///
/// final costService = CostCalculationService();
/// final pricingService = PricingRecommendationService();
/// final breakdown = costService.calculateTotalCost(
///   items: menu.items,
///   ingredients: savedIngredients,
///   packaging: packaging,
///   fixedCosts: fixedCosts,
///   estimatedMonthlyDishes: 1200,
/// );
/// final price = pricingService.calculateSuggestedPrice(
///   totalCost: breakdown.totalCost,
///   targetMarginPercent: 20,
/// );
void persistenceIntegrationExample({
  required LocalStorageRepository storage,
  required Menu menu,
  required List<Ingredient> ingredients,
  required List<Packaging> packaging,
  required List<FixedCost> fixedCosts,
}) {
  storage.saveIngredients(ingredients);
}
