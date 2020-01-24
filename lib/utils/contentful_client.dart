import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/model/agenda.dart';
import 'package:conferenceapp/model/organizer.dart';
import 'package:conferenceapp/model/sponsor.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:contentful/contentful.dart';

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
      logger.errorException(e);
      return null;
    }
  }

  Future<List<Sponsor>> fetchSponsors() async {
    try {
      final _client = Client(space, apiKey);

      final data = await _client.getEntries<SponsorFields>(
        {
          'content_type': 'realSponsor',
          'limit': '100',
        },
        SponsorFields.fromJson,
      );

      return data.items.map((f) => f.fields).toList();
    } catch (e) {
      logger.errorException(e);
      return List<Sponsor>();
    }
  }

  Future<List<Organizer>> fetchOrganizers() async {
    try {
      final _client = Client(space, apiKey);

      final data = await _client.getEntries<OrganizerFields>(
        {
          'content_type': 'organizers',
          'limit': '100',
        },
        OrganizerFields.fromJson,
      );

      return data.items.map((f) => f.fields).toList();
    } catch (e) {
      logger.errorException(e);
      return List<Organizer>();
    }
  }
}
