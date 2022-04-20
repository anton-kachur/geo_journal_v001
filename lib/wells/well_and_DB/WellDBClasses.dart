import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Hive class for saving wells
**************************************************************** */
@HiveType(typeId: 5)
class WellDescription {
  @HiveField(0)
  var number;
  @HiveField(1)
  var date;
  @HiveField(2)
  var latitude;
  @HiveField(3)
  var longtitude;
  @HiveField(4)
  var projectNumber;

  WellDescription(this.number, this.date, this.latitude, this.longtitude, this.projectNumber);

  @override
  String toString() {
    return '${this.number}\n${this.date}\n${this.latitude}\n${this.longtitude}';
  }
}


class WellDescriptionAdapter extends TypeAdapter<WellDescription>{
  @override
  final typeId = 5;


  @override
  WellDescription read(BinaryReader reader) {
    final number = reader.readString();
    final date = reader.readString();
    final latitude = reader.readDouble();
    final longtitude = reader.readDouble();
    final projectNumber = reader.readString();

    return WellDescription(number, date, latitude, longtitude, projectNumber);
  }


  @override
  void write(BinaryWriter writer, WellDescription obj) {
    writer.writeString(obj.number);
    writer.writeString(obj.date);
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longtitude);
    writer.writeString(obj.projectNumber);
  }
}