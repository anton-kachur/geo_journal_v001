// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SoundingDBClasses.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoundingDescriptionAdapter extends TypeAdapter<SoundingDescription> {
  @override
  final int typeId = 4;

  @override
  SoundingDescription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoundingDescription(
      fields[0] as dynamic,
      fields[1] as dynamic,
      fields[2] as dynamic,
      fields[3] as dynamic,
      fields[4] as dynamic,
      image: fields[5] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, SoundingDescription obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.depth)
      ..writeByte(1)
      ..write(obj.qc)
      ..writeByte(2)
      ..write(obj.fs)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.projectNumber)
      ..writeByte(5)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoundingDescriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
