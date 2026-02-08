import 'package:hive/hive.dart';

class IngredientEntity {
  IngredientEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.updatedAt,
    required this.priceHistory,
  });

  final String id;
  final String name;
  final double price;
  final String unit;
  final DateTime updatedAt;
  final List<IngredientPriceEntry> priceHistory;
}

class IngredientPriceEntry {
  IngredientPriceEntry({required this.price, required this.recordedAt});

  final double price;
  final DateTime recordedAt;
}

class MenuEntity {
  MenuEntity({required this.id, required this.name, required this.items});

  final String id;
  final String name;
  final List<MenuItemEntity> items;
}

class MenuItemEntity {
  MenuItemEntity({required this.ingredientId, required this.quantity});

  final String ingredientId;
  final double quantity;
}

class FixedCostEntity {
  FixedCostEntity({required this.id, required this.name, required this.amount});

  final String id;
  final String name;
  final double amount;
}

class PackagingEntity {
  PackagingEntity({required this.id, required this.name, required this.price});

  final String id;
  final String name;
  final double price;
}

class PricingProfileEntity {
  PricingProfileEntity({
    required this.id,
    required this.name,
    required this.targetMarginPercent,
    required this.platformGpRates,
  });

  final String id;
  final String name;
  final double targetMarginPercent;
  final Map<String, double> platformGpRates;
}

class SalesLogEntity {
  SalesLogEntity({
    required this.id,
    required this.menuId,
    required this.quantity,
    required this.totalRevenue,
    required this.recordedAt,
  });

  final String id;
  final String menuId;
  final int quantity;
  final double totalRevenue;
  final DateTime recordedAt;
}

class PromotionConfigEntity {
  PromotionConfigEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.discountPercent,
    required this.bundlePrice,
    required this.bundleQuantity,
    required this.gpRate,
  });

  final String id;
  final String name;
  final String type;
  final double discountPercent;
  final double bundlePrice;
  final int bundleQuantity;
  final double gpRate;
}

class IngredientEntityAdapter extends TypeAdapter<IngredientEntity> {
  @override
  final int typeId = 10;

  @override
  IngredientEntity read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final price = reader.readDouble();
    final unit = reader.readString();
    final updatedAt = DateTime.parse(reader.readString());
    final historyLength = reader.readInt();
    final history = List.generate(historyLength, (_) => reader.read() as IngredientPriceEntry);
    return IngredientEntity(
      id: id,
      name: name,
      price: price,
      unit: unit,
      updatedAt: updatedAt,
      priceHistory: history,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientEntity obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeDouble(obj.price)
      ..writeString(obj.unit)
      ..writeString(obj.updatedAt.toIso8601String())
      ..writeInt(obj.priceHistory.length);
    for (final entry in obj.priceHistory) {
      writer.write(entry);
    }
  }
}

class IngredientPriceEntryAdapter extends TypeAdapter<IngredientPriceEntry> {
  @override
  final int typeId = 11;

  @override
  IngredientPriceEntry read(BinaryReader reader) {
    final price = reader.readDouble();
    final recordedAt = DateTime.parse(reader.readString());
    return IngredientPriceEntry(price: price, recordedAt: recordedAt);
  }

  @override
  void write(BinaryWriter writer, IngredientPriceEntry obj) {
    writer
      ..writeDouble(obj.price)
      ..writeString(obj.recordedAt.toIso8601String());
  }
}

class MenuEntityAdapter extends TypeAdapter<MenuEntity> {
  @override
  final int typeId = 12;

  @override
  MenuEntity read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final itemsLength = reader.readInt();
    final items = List.generate(itemsLength, (_) => reader.read() as MenuItemEntity);
    return MenuEntity(id: id, name: name, items: items);
  }

  @override
  void write(BinaryWriter writer, MenuEntity obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeInt(obj.items.length);
    for (final item in obj.items) {
      writer.write(item);
    }
  }
}

class MenuItemEntityAdapter extends TypeAdapter<MenuItemEntity> {
  @override
  final int typeId = 13;

  @override
  MenuItemEntity read(BinaryReader reader) {
    final ingredientId = reader.readString();
    final quantity = reader.readDouble();
    return MenuItemEntity(ingredientId: ingredientId, quantity: quantity);
  }

  @override
  void write(BinaryWriter writer, MenuItemEntity obj) {
    writer
      ..writeString(obj.ingredientId)
      ..writeDouble(obj.quantity);
  }
}

class FixedCostEntityAdapter extends TypeAdapter<FixedCostEntity> {
  @override
  final int typeId = 14;

  @override
  FixedCostEntity read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final amount = reader.readDouble();
    return FixedCostEntity(id: id, name: name, amount: amount);
  }

  @override
  void write(BinaryWriter writer, FixedCostEntity obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeDouble(obj.amount);
  }
}

class PackagingEntityAdapter extends TypeAdapter<PackagingEntity> {
  @override
  final int typeId = 15;

  @override
  PackagingEntity read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final price = reader.readDouble();
    return PackagingEntity(id: id, name: name, price: price);
  }

  @override
  void write(BinaryWriter writer, PackagingEntity obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeDouble(obj.price);
  }
}

class PricingProfileEntityAdapter extends TypeAdapter<PricingProfileEntity> {
  @override
  final int typeId = 16;

  @override
  PricingProfileEntity read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final targetMarginPercent = reader.readDouble();
    final platformGpRates = (reader.readMap()).cast<String, double>();
    return PricingProfileEntity(
      id: id,
      name: name,
      targetMarginPercent: targetMarginPercent,
      platformGpRates: platformGpRates,
    );
  }

  @override
  void write(BinaryWriter writer, PricingProfileEntity obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeDouble(obj.targetMarginPercent)
      ..writeMap(obj.platformGpRates);
  }
}

class SalesLogEntityAdapter extends TypeAdapter<SalesLogEntity> {
  @override
  final int typeId = 17;

  @override
  SalesLogEntity read(BinaryReader reader) {
    final id = reader.readString();
    final menuId = reader.readString();
    final quantity = reader.readInt();
    final totalRevenue = reader.readDouble();
    final recordedAt = DateTime.parse(reader.readString());
    return SalesLogEntity(
      id: id,
      menuId: menuId,
      quantity: quantity,
      totalRevenue: totalRevenue,
      recordedAt: recordedAt,
    );
  }

  @override
  void write(BinaryWriter writer, SalesLogEntity obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.menuId)
      ..writeInt(obj.quantity)
      ..writeDouble(obj.totalRevenue)
      ..writeString(obj.recordedAt.toIso8601String());
  }
}

class PromotionConfigEntityAdapter extends TypeAdapter<PromotionConfigEntity> {
  @override
  final int typeId = 18;

  @override
  PromotionConfigEntity read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final type = reader.readString();
    final discountPercent = reader.readDouble();
    final bundlePrice = reader.readDouble();
    final bundleQuantity = reader.readInt();
    final gpRate = reader.readDouble();
    return PromotionConfigEntity(
      id: id,
      name: name,
      type: type,
      discountPercent: discountPercent,
      bundlePrice: bundlePrice,
      bundleQuantity: bundleQuantity,
      gpRate: gpRate,
    );
  }

  @override
  void write(BinaryWriter writer, PromotionConfigEntity obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeString(obj.type)
      ..writeDouble(obj.discountPercent)
      ..writeDouble(obj.bundlePrice)
      ..writeInt(obj.bundleQuantity)
      ..writeDouble(obj.gpRate);
  }
}
