import 'package:conferenceapp/model/sponsor.dart';
import 'package:conferenceapp/utils/contentful_client.dart';

class SponsorsRepository {
  final ContentfulClient client;

  SponsorsRepository(this.client);
  Future<List<Sponsor>> fetchSponsors() async {
    try {
      final sponsors = await client.fetchSponsors();
      return sponsors;
    } catch (e) {
      print(e);
      return List<Sponsor>();
    }
  }
}
