import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Hive class for saving accounts
**************************************************************** */
@HiveType(typeId: 12)
class UserAccountDescription {
  @HiveField(0)
  var login;
  @HiveField(1)
  var password;
  @HiveField(2)
  var email;
  @HiveField(3)
  var phoneNumber;
  @HiveField(4)
  var position;
  @HiveField(5)
  var isRegistered;
  @HiveField(6)
  var isAdmin;
  
  UserAccountDescription(
    this.login, this.password, 
    this.email, this.phoneNumber,
    this.position, this.isRegistered, 
    this.isAdmin  
  );

  get getLogin => this.login;

  @override
  String toString() {
    return '${this.login}  ${this.password}\n${this.email}\n${this.phoneNumber}\n${this.position}\nRegistered: ${this.isRegistered}\nIs admin: ${this.isAdmin}';
  }
}


class UserAccountDescriptionAdapter extends TypeAdapter<UserAccountDescription>{
  @override
  final typeId = 12;

  @override
  UserAccountDescription read(BinaryReader reader) {
    final login = reader.readString();
    final password = reader.readString();
    final email = reader.readString();
    final phoneNumber = reader.readString();
    final position = reader.readString();
    final isRegistered = reader.readBool();
    final isAdmin = reader.readBool();
    return UserAccountDescription(login, password, email, phoneNumber, position, isRegistered, isAdmin);
  }

  @override
  void write(BinaryWriter writer, UserAccountDescription obj) {
    writer.writeString(obj.login);
    writer.writeString(obj.password);
    writer.writeString(obj.email);
    writer.writeString(obj.phoneNumber);
    writer.writeString(obj.position);
    writer.writeBool(obj.isRegistered);
    writer.writeBool(obj.isAdmin);
  }
}