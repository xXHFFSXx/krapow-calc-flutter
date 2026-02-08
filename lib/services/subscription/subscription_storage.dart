import 'package:hive/hive.dart';

class SubscriptionStateEntity {
  SubscriptionStateEntity({
    required this.planId,
    required this.planName,
    required this.isPro,
    required this.updatedAt,
  });

  final String planId;
  final String planName;
  final bool isPro;
  final DateTime updatedAt;
}

class SubscriptionStateEntityAdapter extends TypeAdapter<SubscriptionStateEntity> {
  @override
  final int typeId = 20;

  @override
  SubscriptionStateEntity read(BinaryReader reader) {
    final planId = reader.readString();
    final planName = reader.readString();
    final isPro = reader.readBool();
    final updatedAt = DateTime.parse(reader.readString());
    return SubscriptionStateEntity(
      planId: planId,
      planName: planName,
      isPro: isPro,
      updatedAt: updatedAt,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionStateEntity obj) {
    writer
      ..writeString(obj.planId)
      ..writeString(obj.planName)
      ..writeBool(obj.isPro)
      ..writeString(obj.updatedAt.toIso8601String());
  }
}
