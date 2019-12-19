import 'package:conferenceapp/model/talk.dart';

import 'contentful_client.dart';
import 'file_storage.dart';

class ContentfulTalksRepository {
  final FileStorage fileStorage;
  final ContentfulClient client;

  const ContentfulTalksRepository({
    this.fileStorage,
    this.client,
  });

  Future<List<Talk>> loadTodos() async {
    try {
      return await fileStorage.loadTodos();
    } catch (e) {
      final todos = await client.fetchTalks();

      fileStorage.saveItems(todos);

      return todos;
    }
  }

  Future saveTalks(List<Talk> todos) {
    return Future.wait<dynamic>([
      fileStorage.saveItems(todos),
    ]);
  }
}
