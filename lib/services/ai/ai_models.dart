class InsightSeverity {
  static const String info = 'info';
  static const String warning = 'warning';
  static const String critical = 'critical';
}

class DecisionInsight {
  final String title;
  final String message;
  final String severity;
  final String? actionLabel;

  const DecisionInsight({
    required this.title,
    required this.message,
    required this.severity,
    this.actionLabel,
  });
}

class PricingSuggestion {
  final double currentPrice;
  final double suggestedPrice;
  final double marginChangePercent;
  final String reason;

  const PricingSuggestion({
    required this.currentPrice,
    required this.suggestedPrice,
    required this.marginChangePercent,
    required this.reason,
  });
}

class PromotionRiskAssessment {
  final double promoPrice;
  final double expectedProfit;
  final bool isRisky;
  final String note;

  const PromotionRiskAssessment({
    required this.promoPrice,
    required this.expectedProfit,
    required this.isRisky,
    required this.note,
  });
}

class ForecastPoint {
  final DateTime date;
  final double value;

  const ForecastPoint({required this.date, required this.value});
}

class ForecastResult {
  final List<ForecastPoint> profitForecast;
  final String assumption;

  const ForecastResult({
    required this.profitForecast,
    required this.assumption,
  });
}

class CostTrendResult {
  final String ingredientName;
  final List<ForecastPoint> trendPoints;
  final String summary;

  const CostTrendResult({
    required this.ingredientName,
    required this.trendPoints,
    required this.summary,
  });
}

class DemandEstimate {
  final String menuName;
  final int estimatedDailyOrders;
  final String assumption;

  const DemandEstimate({
    required this.menuName,
    required this.estimatedDailyOrders,
    required this.assumption,
  });
}

class MenuInsight {
  final String menuName;
  final double profitPerDish;
  final String recommendation;

  const MenuInsight({
    required this.menuName,
    required this.profitPerDish,
    required this.recommendation,
  });
}

class AlertMessage {
  final String title;
  final String message;
  final String severity;

  const AlertMessage({
    required this.title,
    required this.message,
    required this.severity,
  });
}
