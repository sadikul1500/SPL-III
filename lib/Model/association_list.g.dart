// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'association_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssociationItemAdapter extends TypeAdapter<AssociationItem> {
  @override
  final int typeId = 3;

  @override
  AssociationItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssociationItem(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AssociationItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.meaning)
      ..writeByte(2)
      ..write(obj.dir)
      ..writeByte(3)
      ..write(obj.audio)
      ..writeByte(4)
      ..write(obj.video);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssociationItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
