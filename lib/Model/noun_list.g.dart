// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noun_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NounItemAdapter extends TypeAdapter<NounItem> {
  @override
  final int typeId = 0;

  @override
  NounItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NounItem(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NounItem obj) {
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
      other is NounItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
