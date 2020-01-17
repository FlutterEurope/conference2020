import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class TicketsList extends StatelessWidget {
  const TicketsList(
    this.list,
    this.isAdmin,
    this.filter, {
    Key key,
  }) : super(key: key);

  final AsyncSnapshot<QuerySnapshot> list;
  final AsyncSnapshot<bool> isAdmin;
  final String filter;

  @override
  Widget build(BuildContext context) {
    final filteredList = list.data.documents
        .where((n) => n['orderId'].toString().contains(filter.toUpperCase()))
        ?.toList();

    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.document('tickets/tickets').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List ticketCollection = snapshot.data['tickets'];
          return ListView.builder(
            itemCount: filteredList?.length,
            itemBuilder: (ctx, indx) {
              final doc = filteredList[indx].data;
              final DateTime date = doc['updated'].toDate();
              final ticket = ticketCollection
                  .firstWhere((n) => n['ticketId'] == doc['ticketId']);
              final name = utf8.decode(base64Decode(ticket['name']));
              return ListTile(
                title: SelectableText('${doc["orderId"]} / ${doc['ticketId']}'),
                subtitle: Text('$name | $date'),
                trailing: isAdmin.hasData && isAdmin.data == true
                    ? IconButton(
                        icon: Icon(LineIcons.trash),
                        onPressed: () async => await Firestore.instance
                            .collection('tickets_checked')
                            .document(doc['ticketId'])
                            .delete(),
                      )
                    : null,
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
