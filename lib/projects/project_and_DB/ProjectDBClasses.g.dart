// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProjectDBClasses.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectDescriptionAdapter extends TypeAdapter<ProjectDescription> {
  @override
  final int typeId = 3;

  @override
  ProjectDescription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectDescription(
      fields[0] as dynamic,
      fields[1] as dynamic,
      fields[2] as dynamic,
      fields[3] as dynamic,
      (fields[4] as List).cast<WellDescription>(),
      (fields[5] as List).cast<SoundingDescription>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProjectDescription obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.wells)
      ..writeByte(5)
      ..write(obj.soundings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectDescriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
