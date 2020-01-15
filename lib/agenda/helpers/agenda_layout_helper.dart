import 'package:conferenceapp/utils/analytics.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgendaLayoutHelper with ChangeNotifier {
  bool _compact = true;
  bool _hasHeightsCalculated = false;
  int _talksCount;

  AgendaLayoutHelper(this._compact);

  bool isCompact() => _compact;
  bool hasHeightsCalculated() => _hasHeightsCalculated;

  Future toggleCompact() async {
    _compact = !_compact;

    final paramValue = _compact ? 'compact' : 'normal';
    analytics.logEvent(
      name: 'agenda_layout_toggle',
      parameters: {'target': paramValue},
    );
    analytics.setUserProperty(name: 'agenda_mode', value: paramValue);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('agenda_mode', paramValue);

    notifyListeners();
  }

  void finishHeightsCalculation() {
    _hasHeightsCalculated = true;
    notifyListeners();
  }

  void checkIfNotifyAboutHeight() {
    if (_compactTalkHeights.length >= _talksCount &&
        _normalTalkHeights.length >= _talksCount) {
      finishHeightsCalculation();
    }
  }

  final _compactTalkHeights = Map<String, double>();
  final _normalTalkHeights = Map<String, double>();

  double compactHeight(Talk talk, Talk nextTalk) {
    try {
      if (talk == null && nextTalk != null) {
        return _compactTalkHeights[nextTalk.id];
      }
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
      if (talk == null && nextTalk != null) {
        return _normalTalkHeights[nextTalk.id];
      }
      if (talk != null) {
        final heightT = _normalTalkHeights[talk.id];
        if (nextTalk == null) {
          return heightT;
        }
        final heightN = _normalTalkHeights[nextTalk.id];
        return heightT + heightN;
      }
    } catch (e) {}
    return 100;
  }

  double bottomPositionOfSecondTalkCardWhenCompact(
      String talkId, String nextTalkId) {
    if (talkId == null && nextTalkId != null) {
      return 0;
    }
    if (talkId != null && nextTalkId == null) {
      return 0;
    }
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
    if (id == null) {
      return 0;
    }
    return _normalTalkHeights[id];
  }
}
