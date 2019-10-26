import 'package:conferenceapp/agenda/repository/talks_repository.dart';
import 'package:conferenceapp/model/author.dart';
import 'package:conferenceapp/model/room.dart';
import 'package:conferenceapp/model/talk.dart';

class MockTalksRepository implements TalkRepository {
  @override
  List<Talk> get talks => _talks;
}

final roomA = Room('A', 150, 0);
final roomB = Room('B', 100, 1);

final _authors = [
  Author(
    'John',
    'Doe',
    'Bio',
    'Developer',
    'OrestesGaolin',
    'email@example.com',
    'https://firebasestorage.googleapis.com/v0/b/flutter-europe-tst.appspot.com/o/casual-contemporary-facial-expression-1816593.jpg?alt=media',
  ),
  Author(
    'Anna',
    'Smith',
    'Short Bio',
    'Developer',
    'TwitterHandle',
    'email@example.com',
    'https://picsum.photos/id/593/300/300',
  ),
  Author(
    'Johnathan',
    'Smith-Doe',
    'Bio',
    'Manager',
    'TwitterHandle',
    'email@example.com',
    'https://picsum.photos/id/64/300/300',
  ),
  Author(
    'Anna',
    'Doe',
    'Bio',
    'Mobile Developer',
    'FlutterDev',
    'email@example.com',
    'https://firebasestorage.googleapis.com/v0/b/flutter-europe-tst.appspot.com/o/adult-beautiful-black-shirt-1727280.jpg?alt=media',
  ),
];

final _dur45 = Duration(minutes: 45);
final _dur30 = Duration(minutes: 30);

final _talks = <Talk>[
  Talk(
      'Making the most out of your Flutter development',
      [_authors[0], _authors[1]],
      DateTime(2020, 1, 23, 9, 0),
      _dur45,
      roomA,
      1),
  Talk('Architect Patterns on Flutter', [_authors[2], _authors[1]],
      DateTime(2020, 1, 23, 9, 0), _dur45, roomB, 2),
  Talk('How incorporate Flutter to an app with several millions of users',
      [_authors[0]], DateTime(2020, 1, 23, 10, 0), _dur45, roomA, 1),
  Talk('Accessibility on Flutter', [_authors[1]], DateTime(2020, 1, 23, 10, 0),
      _dur45, roomB, 3),
  Talk(
      'Title 5', [_authors[2]], DateTime(2020, 1, 23, 11, 0), _dur45, roomA, 1),
  Talk(
      'Title 6', [_authors[0]], DateTime(2020, 1, 23, 11, 0), _dur45, roomB, 2),
  Talk(
      'Title 7', [_authors[2]], DateTime(2020, 1, 23, 12, 0), _dur45, roomA, 1),
  Talk(
      'Title 8', [_authors[1]], DateTime(2020, 1, 23, 12, 0), _dur45, roomB, 2),
  Talk(
      'Title 9', [_authors[2]], DateTime(2020, 1, 23, 13, 0), _dur45, roomA, 1),
  Talk('Title 10', [_authors[1]], DateTime(2020, 1, 23, 13, 0), _dur45, roomB,
      3),
  Talk('Title 11', [_authors[2]], DateTime(2020, 1, 23, 15, 0), _dur45, roomA,
      1),
  Talk('Title 12', [_authors[1]], DateTime(2020, 1, 23, 15, 0), _dur45, roomB,
      3),
  Talk('Title 13', [_authors[2]], DateTime(2020, 1, 23, 16, 0), _dur45, roomA,
      1),
  Talk('Title 14', [_authors[1]], DateTime(2020, 1, 23, 16, 0), _dur45, roomB,
      3),
  Talk('Title 15', [_authors[2]], DateTime(2020, 1, 23, 17, 0), _dur45, roomA,
      1),
  Talk('Title 16', [_authors[1]], DateTime(2020, 1, 23, 17, 0), _dur45, roomB,
      2),
  //Day2
  Talk(
      'Title 17', [_authors[2]], DateTime(2020, 1, 24, 9, 0), _dur45, roomA, 1),
  Talk('Title 18', [_authors[1]], DateTime(2020, 1, 24, 9, 0), _dur45, roomB, 1)
];
