import 'package:conferenceapp/model/talk.dart';
import 'package:flutter/material.dart';

class AgendaLayoutHelper with ChangeNotifier {
  bool _compact;
  bool _hasHeightsCalculated = false;
  int _talksCount;

  AgendaLayoutHelper(this._compact);

  isCompact() => _compact;
  hasHeightsCalculated() => _hasHeightsCalculated;

  void toggleCompact() {
    _compact = !_compact;
    notifyListeners();
  }

  void finishHeightsCalculation() {
    _hasHeightsCalculated = true;
    notifyListeners();
  }

  void checkIfNotifyAboutHeight() {
    if (_compactTalkHeights.length == _talksCount &&
        _normalTalkHeights.length == _talksCount) {
      finishHeightsCalculation();
    }
  }

  final _compactTalkHeights = Map<String, double>();
  final _normalTalkHeights = Map<String, double>();

  double compactHeight(Talk talk, Talk nextTalk) {
    try {
      final heightT = _compactTalkHeights[talk.id];
      if (nextTalk == null) {
        return heightT;
      }
      final heightN = _compactTalkHeights[nextTalk.id];
      if (heightT > heightN == true) {
        return heightT;
      } else {
        return heightN;
      }
    } catch (e) {
      return 100;
    }
  }

  double normalHeight(Talk talk, Talk nextTalk) {
    try {
      final heightT = _normalTalkHeights[talk.id];
      if (nextTalk == null) {
        return heightT;
      }
      final heightN = _normalTalkHeights[nextTalk.id];
      return heightT + heightN;
    } catch (e) {
      return 100;
    }
  }

  double bottomPositionOfSecondTalkCardWhenCompact(
      String talkId, String nextTalkId) {
    if (_compactTalkHeights[talkId] < _compactTalkHeights[nextTalkId]) {
      return 0;
    }
    if (_compactTalkHeights[talkId] > _compactTalkHeights[nextTalkId]) {
      return _compactTalkHeights[talkId] - _compactTalkHeights[nextTalkId];
    }
    return 0;
  }

  double bottomPositionOfFirstTalkCardWhenCompact(
      String talkId, String nextTalkId) {
    if (nextTalkId == null) {
      return 0;
    }
    if (_compactTalkHeights[talkId] < _compactTalkHeights[nextTalkId]) {
      return _compactTalkHeights[nextTalkId] - _compactTalkHeights[talkId];
    }
    if (_compactTalkHeights[talkId] > _compactTalkHeights[nextTalkId]) {
      return 0;
    }
    return 0;
  }

  double bottomPositionOfFirstTalkCardWhenNormal(
      String talkId, String nextTalkId) {
    if (nextTalkId == null) {
      return 0;
    }
    return _normalTalkHeights[nextTalkId];
  }

  void setTalksCount(int length) {
    _talksCount = length;
  }

  void setCompactTalkHeight(String id, double height) {
    _compactTalkHeights[id] = height;
    checkIfNotifyAboutHeight();
  }

  void setNormalTalkHeight(String id, double height) {
    _normalTalkHeights[id] = height;
    checkIfNotifyAboutHeight();
  }

  double normalTalkHeight(String id) {
    return _normalTalkHeights[id];
  }
}
