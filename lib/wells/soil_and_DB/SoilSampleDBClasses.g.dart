// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SoilSampleDBClasses.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoilForWellDescriptionAdapter
    extends TypeAdapter<SoilForWellDescription> {
  @override
  final int typeId = 16;

  @override
  SoilForWellDescription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoilForWellDescription(
      fields[0] as dynamic,
      fields[1] as dynamic,
      fields[2] as dynamic,
      fields[3] as dynamic,
      fields[4] as dynamic,
      fields[5] as dynamic,
      image: fields[6] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, SoilForWellDescription obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.depthStart)
      ..writeByte(2)
      ..write(obj.depthEnd)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.wellNumber)
      ..writeByte(5)
      ..write(obj.projectNumber)
      ..writeByte(6)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoilForWellDescriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
