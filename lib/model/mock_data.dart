import 'author.dart';
import 'room.dart';
import 'talk.dart';

final roomA = Room('A', 100);
final roomB = Room('B', 150);
final authorA = Author(
  'John',
  'Doe',
  'Bio',
  'Developer',
  'OrestesGaolin',
  'email@example.com',
  'https://picsum.photos/id/659/300/300',
);
final authorB = Author(
  'Anna',
  'Smith',
  'Short Bio',
  'Developer',
  'TwitterHandle',
  'email@example.com',
  'https://picsum.photos/id/593/300/300',
);
final authorC = Author(
  'Johnathan',
  'Smith-Doe',
  'Bio',
  'Manager',
  'TwitterHandle',
  'email@example.com',
  'https://picsum.photos/id/64/300/300',
);

final dur45 = Duration(minutes: 45);
final dur30 = Duration(minutes: 30);

final talks = <Talk>[
  Talk('Making the most out of your Flutter development', [authorA, authorB],
      DateTime(2020, 1, 23, 9, 0), dur45, roomA, 1),
  Talk('Architect Patterns on Flutter', [authorC, authorB],
      DateTime(2020, 1, 23, 9, 0), dur45, roomB, 2),
  Talk('How incorporate Flutter to an app with several millions of users',
      [authorA], DateTime(2020, 1, 23, 10, 0), dur45, roomA, 1),
  Talk('Accessibility on Flutter', [authorB], DateTime(2020, 1, 23, 10, 0),
      dur45, roomB, 3),
  Talk('Title 5', [authorC], DateTime(2020, 1, 23, 11, 0), dur45, roomA, 1),
  Talk('Title 6', [authorA], DateTime(2020, 1, 23, 11, 0), dur45, roomB, 2),
  Talk('Title 7', [authorC], DateTime(2020, 1, 23, 12, 0), dur45, roomA, 1),
  Talk('Title 8', [authorB], DateTime(2020, 1, 23, 12, 0), dur45, roomB, 2),
  Talk('Title 9', [authorC], DateTime(2020, 1, 23, 13, 0), dur45, roomA, 1),
  Talk('Title 10', [authorB], DateTime(2020, 1, 23, 13, 0), dur45, roomB, 3),
  Talk('Title 11', [authorC], DateTime(2020, 1, 23, 15, 0), dur45, roomA, 1),
  Talk('Title 12', [authorB], DateTime(2020, 1, 23, 15, 0), dur45, roomB, 3),
  Talk('Title 13', [authorC], DateTime(2020, 1, 23, 16, 0), dur45, roomA, 1),
  Talk('Title 14', [authorB], DateTime(2020, 1, 23, 16, 0), dur45, roomB, 3),
  Talk('Title 15', [authorC], DateTime(2020, 1, 23, 17, 0), dur45, roomA, 1),
  Talk('Title 16', [authorB], DateTime(2020, 1, 23, 17, 0), dur45, roomB, 2),
  //Day2
  Talk('Title 17', [authorC], DateTime(2020, 1, 24, 9, 0), dur45, roomA, 1),
  Talk('Title 18', [authorB], DateTime(2020, 1, 24, 9, 0), dur45, roomB, 1)
];
