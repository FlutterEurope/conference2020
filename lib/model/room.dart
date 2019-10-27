import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class Room {
  final String name;
  final int capacity;
  final int id;

  Room(this.name, this.capacity, this.id);
  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);
}
