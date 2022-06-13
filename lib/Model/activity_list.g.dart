// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityItemAdapter extends TypeAdapter<ActivityItem> {
  @override
  final int typeId = 2;

  @override
  ActivityItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityItem(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.meaning)
      ..writeByte(2)
      ..write(obj.video);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
