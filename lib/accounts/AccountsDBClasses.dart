import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Hive class for saving accounts
**************************************************************** */
@HiveType(typeId: 1)
class AccountDescription {
  @HiveField(0)
  var login;
  @HiveField(1)
  var password;
  @HiveField(2)
  var email;
  @HiveField(3)
  var phoneNumber;
  
  AccountDescription(this.login, this.password, this.email, this.phoneNumber);

  @override
  String toString() {
    return '${this.login}  ${this.password}\n${this.email}\n${this.phoneNumber}';
  }
}


/* ***************************************************************
  Class for creating page of soil sample with description
**************************************************************** */
class AccountDescriptionPage extends StatelessWidget{
  var login;
  var password;
  var email;
  var phoneNumber;
  
  AccountDescriptionPage(this.login, this.password, this.email, this.phoneNumber);


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.brown, title: Text(login)),

      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Text('$password \n $email \n $phoneNumber'),
      )
    );
  }
}


class AccountDescriptionAdapter extends TypeAdapter<AccountDescription>{
  @override
  final typeId = 1;

  @override
  AccountDescription read(BinaryReader reader) {
    final login = reader.readString();
    final password = reader.readString();
    final email = reader.readString();
    final phoneNumber = reader.readString();
    return AccountDescription(login, password, email, phoneNumber);
  }

  @override
  void write(BinaryWriter writer, AccountDescription obj) {
    writer.writeString(obj.login);
    writer.writeString(obj.password);
    writer.writeString(obj.email);
    writer.writeString(obj.phoneNumber);
  }
}