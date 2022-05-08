// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AccountsDBClasses.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAccountDescriptionAdapter
    extends TypeAdapter<UserAccountDescription> {
  @override
  final int typeId = 111;

  @override
  UserAccountDescription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAccountDescription(
      fields[0] as dynamic,
      fields[1] as dynamic,
      fields[2] as dynamic,
      fields[3] as dynamic,
      fields[4] as dynamic,
      fields[5] as dynamic,
      fields[6] as dynamic,
      (fields[7] as List).cast<ProjectDescription>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserAccountDescription obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.login)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.position)
      ..writeByte(5)
      ..write(obj.isRegistered)
      ..writeByte(6)
      ..write(obj.isAdmin)
      ..writeByte(7)
      ..write(obj.projects);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAccountDescriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
