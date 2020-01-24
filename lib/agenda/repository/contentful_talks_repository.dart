import 'package:conferenceapp/common/logger.dart';
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

  Future<List<Talk>> loadTalks([bool force = false]) async {
    try {
      final cached = await fileStorage.loadItems();
      if ((force || await cacheExpired())) {
        return fetchTalks();
      } else {
        return cached;
      }
    } catch (e, s) {
      logger.errorException(e, s);
      return fetchTalks();
    }
  }

  Future<bool> cacheExpired() async {
    final lastModified = await fileStorage.lastModified();

    return lastModified
        .isBefore(DateTime.now().subtract(cacheDuration ?? Duration(hours: 2)));
  }

  Future<List<Talk>> fetchTalks() async {
    try {
      final talks = await client.fetchTalks();

      await fileStorage.saveItems(talks);

      return talks;
    } catch (e, s) {
      logger.errorException(e, s);
      return List<Talk>();
    }
  }

  Future saveTalks(List<Talk> talks) {
    return Future.wait<dynamic>([
      fileStorage.saveItems(talks),
    ]);
  }
}
