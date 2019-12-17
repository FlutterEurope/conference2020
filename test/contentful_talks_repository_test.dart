import 'package:conferenceapp/agenda/repository/contentful_client.dart';
import 'package:test/test.dart';

void main() {
  group('Contentful response tests', () {
    setUp(() {
      //
    });

    test('Response json is parsed correctly', () async {
      final client = ContentfulClient(
          'lpivpmxs5lb8', '9RqfrB4E8Sn1RxQwazeM3wfmgeVKvUAOXmycw9XShTc');
      final data = await client.fetchTalks();
      print(data);
    });

    test('Fetching ticket yields TicketDataFilledState', () async {
//
    });

    tearDown(() {});
  });
}
