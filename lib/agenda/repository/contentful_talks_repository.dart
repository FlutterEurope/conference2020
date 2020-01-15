import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/utils/contentful_client.dart';
import 'package:flutter/foundation.dart';

import 'file_storage.dart';

class ContentfulTalksRepository {
  final FileStorage fileStorage;
  final ContentfulClient client;
  final Duration cacheDuration;

  const ContentfulTalksRepository({
    @required this.fileStorage,
    @required this.client,
    @required this.cacheDuration,
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

    return lastModified
        .isBefore(DateTime.now().subtract(cacheDuration ?? Duration(hours: 2)));
  }

  Future<List<Talk>> fetchTalks() async {
    final talks = await client.fetchTalks();

    fileStorage.saveItems(talks);

    return talks;
  }

  Future saveTalks(List<Talk> todos) {
    return Future.wait<dynamic>([
      fileStorage.saveItems(todos),
    ]);
  }
}
