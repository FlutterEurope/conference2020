import 'package:conferenceapp/agenda/bloc/bloc.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/search/material_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaBloc, AgendaState>(
        bloc: BlocProvider.of<AgendaBloc>(context),
        builder: (context, state) {
          if (state is PopulatedAgendaState)
            return MaterialSearch<Talk>(
              placeholder: 'Search',
              getResults: (String criteria) async {
                return [...state.talks[0], ...state.talks[1]]
                    .map((Talk v) => new MaterialSearchResult<Talk>(
                          icon: v.authors.length > 1
                              ? LineIcons.users
                              : LineIcons.user,
                          value: v,
                          title: v.title,
                          subtitle: v.authors.map((f) => f.name).join(", "),
                          criteria: criteria,
                        ))
                    .toList();
              },
              filter: filterResults,
              onSelect: (dynamic value) {
                if (value is Talk) Navigator.pop(context, value);
              },
              onSubmit: (dynamic value) {
                Navigator.pop<Talk>(context, value);
              },
            );
          else
            return Container();
        });
  }

  bool filterResults(dynamic value, String criteria) {
    return "${value.title}${value.authors.map((f) => f.name).join(" ")}"
        .toLowerCase()
        .trim()
        .contains(
          RegExp(r'' +
              criteria
                  .replaceAll(RegExp(r'[^\w\s]+'), '')
                  .toLowerCase()
                  .trim() +
              ''),
        );
  }
}
