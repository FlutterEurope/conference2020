import 'package:conferenceapp/model/agenda.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'room.g.dart';

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class Room extends Equatable {
  final String name;
  final String id;

  Room(this.name, this.id);
  factory Room.fromContentfulType(TalkType type) {
    // todo handle other
    return Room(type == TalkType.beginner ? 'Blue' : 'Orange', '$type');
  }
  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);

  @override
  List<Object> get props => [id];
}
