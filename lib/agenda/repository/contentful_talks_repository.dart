import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/utils/contentful_client.dart';

import 'file_storage.dart';

class ContentfulTalksRepository {
  final FileStorage fileStorage;
  final ContentfulClient client;

  const ContentfulTalksRepository({
    this.fileStorage,
    this.client,
  });

  Future<List<Talk>> loadTalks() async {
    try {
      final cached = await fileStorage.loadItems();
      if (await cacheExpired()) {
        return fetchTalks();
      } else {
        return cached;
      }
    } catch (e) {
      return fetchTalks();
    }
  }

  Future<bool> cacheExpired() async {
    final lastModified = await fileStorage.lastModified();

    return lastModified.isBefore(DateTime.now().subtract(Duration(hours: 6)));
  }

  Future<List<Talk>> fetchTalks() async {
    final todos = await client.fetchTalks();

    fileStorage.saveItems(todos);

    return todos;
  }

  Future saveTalks(List<Talk> todos) {
    return Future.wait<dynamic>([
      fileStorage.saveItems(todos),
    ]);
  }
}
