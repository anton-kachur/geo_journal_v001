// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WellDBClasses.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WellDescriptionAdapter extends TypeAdapter<WellDescription> {
  @override
  final int typeId = 5;

  @override
  WellDescription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WellDescription(
      fields[0] as dynamic,
      fields[1] as dynamic,
      fields[2] as dynamic,
      fields[3] as dynamic,
      fields[4] as dynamic,
      (fields[5] as List).cast<SoilForWellDescription>(),
      image: fields[6] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, WellDescription obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longtitude)
      ..writeByte(4)
      ..write(obj.projectNumber)
      ..writeByte(5)
      ..write(obj.samples)
      ..writeByte(6)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WellDescriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
