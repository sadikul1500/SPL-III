// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColorItemAdapter extends TypeAdapter<ColorItem> {
  @override
  final int typeId = 1;

  @override
  ColorItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColorItem(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ColorItem obj) {
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
      other is ColorItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
