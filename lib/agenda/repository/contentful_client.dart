import 'package:conferenceapp/model/agenda.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:contentful/contentful.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class ContentfulClient {
  final String space;
  final String apiKey;

  const ContentfulClient(this.space, this.apiKey);

  Future<List<Talk>> fetchTalks() async {
    try {
      final _client = Client(space, apiKey);

      final data = await _client.getEntries<AgendaFields>(
        {
          'content_type': 'programme',
          'limit': '100',
        },
        AgendaFields.fromJson,
      );

      return data.items.map<Talk>((talk) => Talk.fromContentful(talk)).toList();
    } catch (e) {
      print(e);
      return List<Talk>();
    }
  }
}
