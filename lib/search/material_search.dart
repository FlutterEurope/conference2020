// Forked from material_search package
// https://pub.dev/packages/material_search
// Licensed on MIT License by ian.naph@gmail.com
import 'dart:async';

import 'package:conferenceapp/common/logger.dart';
import 'package:flutter/material.dart';

typedef String FormFieldFormatter<T>(T v);
typedef bool MaterialSearchFilter<T>(T v, String c);
typedef int MaterialSearchSort<T>(T a, T b, String c);
typedef Future<List<MaterialSearchResult>> MaterialResultsFinder(String c);
typedef void OnSubmit(dynamic value);

class MaterialSearchResult<T> extends StatelessWidget {
  const MaterialSearchResult({
    Key key,
    this.value,
    this.title,
    this.subtitle,
    this.icon,
    this.criteria,
  }) : super(key: key);

  final T value;
  final String title;
  final String subtitle;
  final IconData icon;
  final String criteria;

  @override
  Widget build(BuildContext context) {
    final titleWidget = getResultWithEmphasis(
      context: context,
      word: title,
      criteria: criteria,
      style: Theme.of(context).textTheme.subhead,
    );
    final subtitleWidget = getResultWithEmphasis(
      context: context,
      word: subtitle,
      criteria: criteria,
      style: Theme.of(context).textTheme.subtitle,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: new Container(
        child: new Row(
          children: <Widget>[
            new Container(width: 70.0, child: new Icon(icon)),
            new Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  titleWidget,
                  if (subtitle != null) subtitleWidget,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//
  Widget getResultWithEmphasis({
    @required BuildContext context,
    @required String word,
    @required String criteria,
    @required TextStyle style,
  }) {
    final wordClean = word.toLowerCase().trim();
    final criteriaClean = criteria.toLowerCase().trim();

    if (word == null) return null;
    if (criteria.isNotEmpty && wordClean.contains(criteriaClean)) {
      final position = wordClean.indexOf(criteriaClean);
      String text0, text1, text2;
      if (position == 0) {
        text1 = word.substring(position, criteriaClean.length);
        text2 = word.substring(criteriaClean.length, word.length);
      }
      if (position > 0 && position < word.length) {
        text0 = word.substring(0, position);
        text1 = word.substring(position, position + criteriaClean.length);
        text2 = word.substring(position + criteriaClean.length, word.length);
      }
      if (position == word.length) {
        text0 = word.substring(0, position);
        text1 = word.substring(position, position + criteriaClean.length);
      }
      return RichText(
        text: TextSpan(
          style: style,
          children: <TextSpan>[
            if (text0 != null) TextSpan(text: text0),
            if (text1 != null)
              TextSpan(
                  text: text1, style: TextStyle(fontWeight: FontWeight.bold)),
            if (text2 != null) TextSpan(text: text2),
          ],
        ),
      );
    } else {
      return RichText(
        text: TextSpan(
          style: style,
          children: <TextSpan>[
            TextSpan(
              text: word,
            ),
          ],
        ),
      );
    }
  }
}

class MaterialSearch<T> extends StatefulWidget {
  MaterialSearch({
    Key key,
    this.placeholder,
    this.results,
    this.getResults,
    this.filter,
    this.sort,
    this.limit: 10,
    this.onSelect,
    this.onSubmit,
    this.barBackgroundColor = Colors.white,
    this.iconColor = Colors.white,
    this.leading,
  })  : assert(() {
          if (results == null && getResults == null ||
              results != null && getResults != null) {
            throw new AssertionError(
                'Either provide a function to get the results, or the results.');
          }

          return true;
        }()),
        super(key: key);

  final String placeholder;

  final List<MaterialSearchResult<T>> results;
  final MaterialResultsFinder getResults;
  final MaterialSearchFilter<T> filter;
  final MaterialSearchSort<T> sort;
  final int limit;
  final ValueChanged<T> onSelect;
  final OnSubmit onSubmit;
  final Color barBackgroundColor;
  final Color iconColor;
  final Widget leading;

  @override
  _MaterialSearchState<T> createState() => new _MaterialSearchState<T>();
}

class _MaterialSearchState<T> extends State<MaterialSearch> {
  bool _loading = false;
  List<MaterialSearchResult<T>> _results = [];

  String _criteria = '';
  TextEditingController _controller = new TextEditingController();

  _filter(dynamic v, String c) {
    return v
        .toString()
        .toLowerCase()
        .trim()
        .contains(new RegExp(r'' + c.toLowerCase().trim() + ''));
  }

  @override
  void initState() {
    super.initState();

    if (widget.getResults != null) {
      _getResultsDebounced();
    }

    _controller.addListener(() {
      if (_controller.value.text != null) {
        setState(() {
          _criteria = _controller.value.text;
          if (widget.getResults != null) {
            _getResultsDebounced();
          }
        });
      }
    });
  }

  Timer _resultsTimer;
  Future _getResultsDebounced() async {
    if (_results.length == 0) {
      setState(() {
        logger.info('Setting loading to true');
        _loading = true;
      });
    }

    if (_resultsTimer != null && _resultsTimer.isActive) {
      _resultsTimer.cancel();
    }

    _resultsTimer = new Timer(new Duration(milliseconds: 100), () async {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = true;
      });

      var results = await widget.getResults(_criteria);

      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
        _results = results;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _resultsTimer?.cancel();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var results =
        (widget.results ?? _results).where((MaterialSearchResult result) {
      if (widget.filter != null) {
        return widget.filter(result.value, _criteria);
      }
      //only apply default filter if used the `results` option
      //because getResults may already have applied some filter if `filter` option was omited.
      else if (widget.results != null) {
        return _filter(result.value, _criteria);
      }

      return true;
    }).toList();

    if (widget.sort != null) {
      logger.info('Sorting');
      results.sort((a, b) => widget.sort(a.value, b.value, _criteria));
    }

    results = results.take(widget.limit).toList();

    IconThemeData iconTheme =
        Theme.of(context).iconTheme.copyWith(color: widget.iconColor);

    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        return true;
      },
      child: new Scaffold(
        appBar: new AppBar(
          elevation: 0,
          leading: widget.leading,
          iconTheme: iconTheme,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).primaryColor
              : Theme.of(context).scaffoldBackgroundColor,
          title: new TextField(
            controller: _controller,
            autofocus: true,
            decoration: new InputDecoration.collapsed(
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                color: Colors.white54,
              ),
            ),
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            onSubmitted: (String value) {
              if (widget.onSubmit != null) {
                widget.onSubmit(value);
              }
            },
            keyboardAppearance: Theme.of(context).brightness,
          ),
          actions: _criteria.length == 0
              ? []
              : [
                  new IconButton(
                      icon: new Icon(Icons.clear),
                      onPressed: () {
                        logger.info('Clear pressed');
                        setState(() {
                          _controller.text = _criteria = '';
                        });
                      }),
                ],
        ),
        body: _loading
            ? new Center(
                child: new Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: new CircularProgressIndicator()),
              )
            : ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => widget.onSelect(results[index].value),
                    child: results[index],
                  );
                },
              ),
      ),
    );
  }
}
