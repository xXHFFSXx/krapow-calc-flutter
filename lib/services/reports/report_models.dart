class ProfitSummaryReport {
  final String periodLabel;
  final double totalRevenue;
  final double totalCost;
  final double netProfit;

  const ProfitSummaryReport({
    required this.periodLabel,
    required this.totalRevenue,
    required this.totalCost,
    required this.netProfit,
  });

  Map<String, dynamic> toJson() => {
        'periodLabel': periodLabel,
        'totalRevenue': totalRevenue,
        'totalCost': totalCost,
        'netProfit': netProfit,
      };
}

class CostBreakdownReport {
  final String menuName;
  final double ingredientCost;
  final double packagingCost;
  final double fixedCostPerDish;
  final double totalCost;

  const CostBreakdownReport({
    required this.menuName,
    required this.ingredientCost,
    required this.packagingCost,
    required this.fixedCostPerDish,
    required this.totalCost,
  });

  Map<String, dynamic> toJson() => {
        'menuName': menuName,
        'ingredientCost': ingredientCost,
        'packagingCost': packagingCost,
        'fixedCostPerDish': fixedCostPerDish,
        'totalCost': totalCost,
      };
}

class MenuProfitabilityReport {
  final String menuName;
  final double price;
  final double profitPerDish;

  const MenuProfitabilityReport({
    required this.menuName,
    required this.price,
    required this.profitPerDish,
  });

  Map<String, dynamic> toJson() => {
        'menuName': menuName,
        'price': price,
        'profitPerDish': profitPerDish,
      };
}
