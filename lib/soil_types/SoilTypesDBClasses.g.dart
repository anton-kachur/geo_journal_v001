// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SoilTypesDBClasses.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoilDescriptionAdapter extends TypeAdapter<SoilDescription> {
  @override
  final int typeId = 0;

  @override
  SoilDescription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoilDescription(
      fields[0] as dynamic,
      fields[1] as dynamic,
      image: fields[2] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, SoilDescription obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoilDescriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
