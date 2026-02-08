import '../../models.dart';

class ReceiptOcrService {
  const ReceiptOcrService();

  /// Placeholder for OCR integration.
  /// In production, this would accept a file/image and use ML Kit to extract text.
  Future<ReceiptOcrResult> parseText(String rawText) async {
    final lines = rawText
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final items = <ReceiptLineItem>[];

    for (final line in lines) {
      final parts = line.split(RegExp(r'\s+'));
      if (parts.length < 2) continue;
      final price = double.tryParse(parts.last.replaceAll(',', ''));
      if (price == null) continue;

      final name = parts.sublist(0, parts.length - 1).join(' ');
      items.add(ReceiptLineItem(name: name, price: price));
    }

    return ReceiptOcrResult(items: items);
  }

  /// Suggest ingredient price updates by matching OCR names to existing ingredients.
  List<IngredientPriceSuggestion> buildSuggestions({
    required ReceiptOcrResult result,
    required List<Ingredient> ingredients,
  }) {
    final suggestions = <IngredientPriceSuggestion>[];

    for (final item in result.items) {
      final match = ingredients.firstWhere(
        (ingredient) => ingredient.name.contains(item.name),
        orElse: () => Ingredient(id: 'unknown', name: '', price: 0, unit: ''),
      );
      if (match.id == 'unknown') continue;

      final change = item.price - match.price;
      suggestions.add(
        IngredientPriceSuggestion(
          ingredientId: match.id,
          ingredientName: match.name,
          oldPrice: match.price,
          newPrice: item.price,
          priceChange: change,
        ),
      );
    }

    return suggestions;
  }
}

class ReceiptLineItem {
  final String name;
  final double price;

  const ReceiptLineItem({
    required this.name,
    required this.price,
  });
}

class ReceiptOcrResult {
  final List<ReceiptLineItem> items;

  const ReceiptOcrResult({required this.items});
}

class IngredientPriceSuggestion {
  final String ingredientId;
  final String ingredientName;
  final double oldPrice;
  final double newPrice;
  final double priceChange;

  const IngredientPriceSuggestion({
    required this.ingredientId,
    required this.ingredientName,
    required this.oldPrice,
    required this.newPrice,
    required this.priceChange,
  });
}
