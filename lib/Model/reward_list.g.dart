// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RewardItemAdapter extends TypeAdapter<RewardItem> {
  @override
  final int typeId = 5;

  @override
  RewardItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RewardItem(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RewardItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.video);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
