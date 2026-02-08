import '../integration_interfaces.dart';
import '../integration_models.dart';

class PosStubAdapter implements PosIntegrationProvider {
  PosStubAdapter({
    this.providerLabel = 'Stub POS',
  });

  final String providerLabel;

  @override
  String get providerName => providerLabel;

  @override
  Future<List<SalesRecord>> fetchSales(DateTime from, DateTime to) async {
    return [];
  }

  @override
  Future<List<MenuSyncRecord>> fetchMenus() async {
    return [];
  }
}
