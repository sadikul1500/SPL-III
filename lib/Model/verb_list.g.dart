// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verb_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VerbItemAdapter extends TypeAdapter<VerbItem> {
  @override
  final int typeId = 4;

  @override
  VerbItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VerbItem(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VerbItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.meaning)
      ..writeByte(2)
      ..write(obj.dir)
      ..writeByte(3)
      ..write(obj.audio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerbItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
