import '../integration_interfaces.dart';
import '../integration_models.dart';

class SupplierStubAdapter implements SupplierIntegrationProvider {
  SupplierStubAdapter({
    this.supplierLabel = 'Stub Supplier',
  });

  final String supplierLabel;

  @override
  String get supplierName => supplierLabel;

  @override
  Future<List<SupplierPriceRecord>> fetchIngredientPrices() async {
    return [];
  }
}
