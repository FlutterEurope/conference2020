import 'author.dart';
import 'room.dart';

class Talk {
  final String title;
  final List<Author> authors;
  final DateTime dateTime;
  final Duration duration;
  final Room room;
  final int level;

  Talk(this.title, this.authors, this.dateTime, this.duration, this.room, this.level);
}
