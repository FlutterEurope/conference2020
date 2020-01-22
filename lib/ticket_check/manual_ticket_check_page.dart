import 'package:conferenceapp/common/europe_text_field.dart';
import 'package:conferenceapp/ticket_check/scan_ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';

class ManualTicketPage extends StatefulWidget {
  final TicketCheckBloc bloc;

  const ManualTicketPage({Key key, this.bloc}) : super(key: key);

  @override
  _ManualTicketPageState createState() => _ManualTicketPageState();
}

class _ManualTicketPageState extends State<ManualTicketPage> {
  String value = '';
  String name = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketCheckBloc, TicketCheckState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Ręczne sprawdzanie biletów'),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      'Tutaj możesz ręcznie wpisać dane, jeśli nie udało się ich zeskanować',
                    ),
                  ),
                  EuropeTextFormField(
                    hint: 'Order number lub ticket number',
                    maxLength: 20,
                    value: value,
                    onChanged: (val) {
                      setState(() {
                        value = val.toUpperCase();
                      });
                    },
                    textCapitalization: TextCapitalization.characters,
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (value.length > 0) onSearch();
                    },
                  ),
                  Text(
                      'Numer zamówienia (order no.) ma 9 znaków i zaczyna się od OT'),
                  Text('Numer biletu (ticket id.) ma 20 znaków'),
                  RaisedButton(
                    child: Text('Szukaj'),
                    onPressed: value.length > 0 ? onSearch : null,
                  ),
                  if (state is TicketScannedState)
                    TicketInfo(
                      bloc: widget.bloc,
                      state: state,
                    ),
                  if (state is TicketValidatedState)
                    TicketValidated(
                      bloc: widget.bloc,
                      state: state,
                      onClose: () {
                        widget.bloc.add(InitEvent());
                      },
                    ),
                  if (state is TicketErrorState) TicketError(state.reason),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void onSearch() {
    if (value.length > 9)
      widget.bloc.add(TicketScanned('_ _ $value'));
    else
      widget.bloc.add(TicketScanned('_ $value _'));
  }
}
