import '../integration_interfaces.dart';
import '../integration_models.dart';

class LinemanDeliveryAdapter implements DeliveryIntegrationProvider {
  LinemanDeliveryAdapter({
    this.platformLabel = 'Lineman',
  });

  final String platformLabel;

  @override
  String get platformName => platformLabel;

  @override
  Future<List<DeliveryOrderRecord>> fetchOrders(DateTime from, DateTime to) async {
    return [];
  }

  @override
  Future<Map<String, double>> fetchGpRates() async {
    return {};
  }

  @override
  Future<List<PromotionImpactRecord>> fetchCampaignImpact(
    DateTime from,
    DateTime to,
  ) async {
    return [];
  }
}
