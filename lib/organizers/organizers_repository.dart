import 'package:conferenceapp/model/organizer.dart';
import 'package:conferenceapp/utils/contentful_client.dart';

class OrganizersRepository {
  final ContentfulClient client;

  OrganizersRepository(this.client);
  Future<List<Organizer>> fetchOrganizers() async {
    try {
      final organizers = await client.fetchOrganizers();
      organizers..sort();
      return organizers;
    } catch (e) {
      print(e);
      return List<Organizer>();
    }
  }
}
