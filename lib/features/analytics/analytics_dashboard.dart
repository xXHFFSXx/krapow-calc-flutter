import 'package:flutter/material.dart';

import '../../models.dart';
import '../ux/ux_helpers.dart';
import '../../services/break_even_service.dart';
import '../../services/cost_calculation_service.dart';
import '../../services/pricing_recommendation_service.dart';

class AnalyticsDashboard extends StatelessWidget {
  const AnalyticsDashboard({
    super.key,
    required this.menus,
    required this.ingredients,
    required this.packaging,
    required this.fixedCosts,
    required this.estimatedMonthlyDishes,
    required this.targetMarginPercent,
    required this.currentMonthlySales,
    required this.daysOpenPerMonth,
    this.wastePercent = 0,
  });

  final List<Menu> menus;
  final List<Ingredient> ingredients;
  final List<Packaging> packaging;
  final List<FixedCost> fixedCosts;
  final double estimatedMonthlyDishes;
  final double targetMarginPercent;
  final double currentMonthlySales;
  final int daysOpenPerMonth;
  final double wastePercent;

  @override
  Widget build(BuildContext context) {
    if (menus.isEmpty) {
      return EmptyStateCard(
        title: 'ยังไม่มีเมนูในระบบ',
        subtitle: 'เพิ่มเมนูแรกเพื่อดูสรุปกำไรและคุ้มทุนแบบง่าย',
      );
    }

    final costService = const CostCalculationService();
    final pricingService = const PricingRecommendationService();
    final breakEvenService = const BreakEvenService();

    final totalFixedCosts = fixedCosts.fold(0.0, (sum, item) => sum + item.amount);

    final menuInsights = menus.map((menu) {
      final breakdown = costService.calculateTotalCost(
        items: menu.items,
        ingredients: ingredients,
        packaging: packaging,
        fixedCosts: fixedCosts,
        estimatedMonthlyDishes: estimatedMonthlyDishes,
        wastePercent: wastePercent,
      );
      final price = pricingService.calculateSuggestedPrice(
        totalCost: breakdown.totalCost,
        targetMarginPercent: targetMarginPercent,
      );
      final profitPerDish = price - breakdown.totalCost;
      final variableCost = breakdown.ingredientCost + breakdown.packagingCost;
      final breakEvenPerMenu = breakEvenService.calculateBreakEvenPerMenu(
        totalFixedCosts: totalFixedCosts,
        sellingPrice: price,
        variableCost: variableCost,
      );

      return _MenuInsight(
        name: menu.name,
        profitPerDish: profitPerDish,
        breakEvenPerMenu: breakEvenPerMenu,
      );
    }).toList();

    menuInsights.sort((a, b) => b.profitPerDish.compareTo(a.profitPerDish));

    final estimatedMonthlyProfit = menuInsights.fold(
      0.0,
      (sum, item) => sum + (item.profitPerDish * (estimatedMonthlyDishes / menus.length)),
    );

    final monthlyProfitTrend = _buildMonthlyProfitTrend(
      estimatedMonthlyProfit: estimatedMonthlyProfit,
    );

    final breakEvenProgress = totalFixedCosts == 0
        ? 0.0
        : (currentMonthlySales / totalFixedCosts).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'สรุปกำไรแบบง่าย'),
        _buildProfitSummaryCard(context, estimatedMonthlyProfit),
        const SizedBox(height: 16),
        _buildSectionHeader(context, 'เมนูทำกำไรดี'),
        _buildBestMenus(context, menuInsights.take(3).toList()),
        const SizedBox(height: 16),
        _buildSectionHeader(context, 'กำไรต่อเมนู (เรียงจากมากไปน้อย)'),
        _buildProfitPerMenuList(context, menuInsights),
        const SizedBox(height: 16),
        _buildSectionHeader(context, 'ความคืบหน้าคุ้มทุน'),
        _buildBreakEvenProgress(context, breakEvenProgress),
        const SizedBox(height: 16),
        _buildSectionHeader(context, 'แนวโน้มกำไรรายเดือน'),
        _buildTrendChart(context, monthlyProfitTrend),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildProfitSummaryCard(BuildContext context, double estimatedMonthlyProfit) {
    final profitText = estimatedMonthlyProfit >= 0 ? 'กำไรโดยประมาณ' : 'ขาดทุนโดยประมาณ';
    final profitColor = estimatedMonthlyProfit >= 0 ? Colors.green : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(profitText, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            '${estimatedMonthlyProfit.toStringAsFixed(0)} บาท/เดือน',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: profitColor,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'ตัวเลขนี้ช่วยให้เห็นภาพรวม ไม่ใช่งบการเงิน',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBestMenus(BuildContext context, List<_MenuInsight> insights) {
    return Column(
      children: insights.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(item.name)),
              Text(
                '+${item.profitPerDish.toStringAsFixed(1)} ฿/จาน',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProfitPerMenuList(BuildContext context, List<_MenuInsight> insights) {
    return Column(
      children: insights.map((item) {
        final color = item.profitPerDish >= 0 ? Colors.green : Colors.redAccent;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(child: Text(item.name)),
              Text(
                '${item.profitPerDish.toStringAsFixed(1)} ฿',
                style: TextStyle(fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBreakEvenProgress(BuildContext context, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 10,
          color: Colors.deepOrange,
          backgroundColor: Colors.orange.shade100,
        ),
        const SizedBox(height: 8),
        Text(
          'ยอดขายตอนนี้ ${((progress) * 100).toStringAsFixed(0)}% ของเป้าคุ้มทุน',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTrendChart(BuildContext context, List<double> values) {
    final maxValue = values.fold<double>(0, (max, value) => value > max ? value : max);
    return Row(
      children: values.map((value) {
        final barHeight = maxValue == 0 ? 4.0 : (value / maxValue) * 60;
        final color = value >= 0 ? Colors.green : Colors.redAccent;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  List<double> _buildMonthlyProfitTrend({required double estimatedMonthlyProfit}) {
    // Simple visualization: show the last 4 weeks as a gentle trend.
    return [
      estimatedMonthlyProfit * 0.85,
      estimatedMonthlyProfit * 0.95,
      estimatedMonthlyProfit,
      estimatedMonthlyProfit * 1.05,
    ];
  }
}

class _MenuInsight {
  const _MenuInsight({
    required this.name,
    required this.profitPerDish,
    required this.breakEvenPerMenu,
  });

  final String name;
  final double profitPerDish;
  final double breakEvenPerMenu;
}
