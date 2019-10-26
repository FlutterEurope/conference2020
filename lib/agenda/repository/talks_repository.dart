import 'package:conferenceapp/model/author.dart';
import 'package:conferenceapp/model/room.dart';
import 'package:conferenceapp/model/talk.dart';

abstract class TalkRepository {
  List<Talk> get talks;
}

class MockTalksRepository implements TalkRepository {
  @override
  List<Talk> get talks => _talks;
}

final roomA = Room('A', 100);
final roomB = Room('B', 150);
final _authorA = Author(
  'John',
  'Doe',
  'Bio',
  'Developer',
  'OrestesGaolin',
  'email@example.com',
  'https://picsum.photos/id/659/300/300',
);
final _authorB = Author(
  'Anna',
  'Smith',
  'Short Bio',
  'Developer',
  'TwitterHandle',
  'email@example.com',
  'https://picsum.photos/id/593/300/300',
);
final _authorC = Author(
  'Johnathan',
  'Smith-Doe',
  'Bio',
  'Manager',
  'TwitterHandle',
  'email@example.com',
  'https://picsum.photos/id/64/300/300',
);

final _dur45 = Duration(minutes: 45);
final _dur30 = Duration(minutes: 30);

final _talks = <Talk>[
  Talk('Making the most out of your Flutter development', [_authorA, _authorB],
      DateTime(2020, 1, 23, 9, 0), _dur45, roomA, 1),
  Talk('Architect Patterns on Flutter', [_authorC, _authorB],
      DateTime(2020, 1, 23, 9, 0), _dur45, roomB, 2),
  Talk('How incorporate Flutter to an app with several millions of users',
      [_authorA], DateTime(2020, 1, 23, 10, 0), _dur45, roomA, 1),
  Talk('Accessibility on Flutter', [_authorB], DateTime(2020, 1, 23, 10, 0),
      _dur45, roomB, 3),
  Talk('Title 5', [_authorC], DateTime(2020, 1, 23, 11, 0), _dur45, roomA, 1),
  Talk('Title 6', [_authorA], DateTime(2020, 1, 23, 11, 0), _dur45, roomB, 2),
  Talk('Title 7', [_authorC], DateTime(2020, 1, 23, 12, 0), _dur45, roomA, 1),
  Talk('Title 8', [_authorB], DateTime(2020, 1, 23, 12, 0), _dur45, roomB, 2),
  Talk('Title 9', [_authorC], DateTime(2020, 1, 23, 13, 0), _dur45, roomA, 1),
  Talk('Title 10', [_authorB], DateTime(2020, 1, 23, 13, 0), _dur45, roomB, 3),
  Talk('Title 11', [_authorC], DateTime(2020, 1, 23, 15, 0), _dur45, roomA, 1),
  Talk('Title 12', [_authorB], DateTime(2020, 1, 23, 15, 0), _dur45, roomB, 3),
  Talk('Title 13', [_authorC], DateTime(2020, 1, 23, 16, 0), _dur45, roomA, 1),
  Talk('Title 14', [_authorB], DateTime(2020, 1, 23, 16, 0), _dur45, roomB, 3),
  Talk('Title 15', [_authorC], DateTime(2020, 1, 23, 17, 0), _dur45, roomA, 1),
  Talk('Title 16', [_authorB], DateTime(2020, 1, 23, 17, 0), _dur45, roomB, 2),
  //Day2
  Talk('Title 17', [_authorC], DateTime(2020, 1, 24, 9, 0), _dur45, roomA, 1),
  Talk('Title 18', [_authorB], DateTime(2020, 1, 24, 9, 0), _dur45, roomB, 1)
];
