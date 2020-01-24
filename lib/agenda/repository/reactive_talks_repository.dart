// Forked from The Flutter Architecture Sample https://github.com/brianegan/flutter_architecture_samples

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// below:

// Copyright (c) 2017, Flutter Architecture Sample Authors.
// All rights reserved.

// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the <organization> nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
import 'dart:async';

import 'package:conferenceapp/model/talk.dart';
import 'package:rxdart/rxdart.dart';

import 'contentful_talks_repository.dart';
import 'talks_repository.dart';

class ReactiveTalksRepository implements TalkRepository {
  final ContentfulTalksRepository _repository;
  final BehaviorSubject<List<Talk>> _subject;
  bool _loaded = false;

  ReactiveTalksRepository({
    ContentfulTalksRepository repository,
    List<Talk> seedValue,
  })  : this._repository = repository,
        this._subject = BehaviorSubject<List<Talk>>.seeded(seedValue);

  Future<void> addNewTalk(Talk talk) async {
    _subject.add(List.unmodifiable([]
      ..addAll(_subject.value ?? [])
      ..add(talk)));

    await _repository.saveTalks(_subject.value);
  }

  Future<void> deleteTalk(List<String> idList) async {
    _subject.add(
      List<Talk>.unmodifiable(_subject.value.fold<List<Talk>>(
        <Talk>[],
        (prev, entity) {
          return idList.contains(entity.id) ? prev : (prev..add(entity));
        },
      )),
    );

    await _repository.saveTalks(_subject.value);
  }

  @override
  Stream<List<Talk>> talks() {
    if (!_loaded) _loadTodos();

    return _subject.stream;
  }

  @override
  Stream<Talk> talk(String id) {
    StreamTransformer<List<Talk>, Talk> transform =
        StreamTransformer.fromHandlers(
      handleData: (List<Talk> data, EventSink<Talk> sink) {
        sink.add(data.firstWhere((t) => t.id == id, orElse: () => null));
      },
      handleError: (Object error, StackTrace stacktrace, EventSink sink) {
        sink.addError('Something went wrong: $error');
      },
      handleDone: (EventSink<Talk> sink) => sink.close(),
    );

    return talks().transform(transform);
  }

  @override
  void refresh() {
    _repository.loadTalks(true).then((entities) {
      _subject.add(List<Talk>.unmodifiable(
        []..addAll(entities),
      ));
    });
  }

  void _loadTodos() {
    _loaded = true;

    _repository.loadTalks().then((entities) {
      _subject.add(List<Talk>.unmodifiable(
        []..addAll(_subject.value ?? [])..addAll(entities),
      ));
    });
  }

  Future<void> updateTodo(Talk update) async {
    _subject.add(
      List<Talk>.unmodifiable(_subject.value.fold<List<Talk>>(
        <Talk>[],
        (prev, entity) => prev..add(entity.id == update.id ? update : entity),
      )),
    );

    await _repository.saveTalks(_subject.value);
  }
}
