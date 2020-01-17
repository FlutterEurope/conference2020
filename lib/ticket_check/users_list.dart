import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/profile/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import 'tickets_list.dart';

class UsersListPage extends StatefulWidget {
  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  String filter = '';

  @override
  Widget build(BuildContext context) {
    final tickets =
        Firestore.instance.collection('tickets_checked').snapshots();
    final authRepo = RepositoryProvider.of<AuthRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              filter = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Wyszukaj po order ID',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              LineIcons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {});
            },
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: StreamBuilder<bool>(
            stream: authRepo.isAdmin,
            builder: (context, isAdmin) {
              return StreamBuilder<QuerySnapshot>(
                stream: tickets,
                builder: (context, list) {
                  if (list.hasData)
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'W sumie sprawdzono: ${list.data.documents?.length}'),
                        ),
                        Flexible(
                          child: TicketsList(list, isAdmin, filter),
                        ),
                      ],
                    );
                  else
                    return CircularProgressIndicator();
                },
              );
            }),
      ),
    );
  }

  String formatTimestamp(int timestamp) {
    var format = new DateFormat('d MMM, hh:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }
}
