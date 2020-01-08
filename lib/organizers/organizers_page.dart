import 'package:conferenceapp/common/appbar.dart';
import 'package:conferenceapp/model/organizer.dart';
import 'package:conferenceapp/organizers/organizers_repository.dart';
import 'package:contentful_rich_text/contentful_rich_text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final organizersRepository =
        RepositoryProvider.of<OrganizersRepository>(context);
    return Scaffold(
      appBar: FlutterEuropeAppBar(
        back: true,
        search: false,
      ),
      body: Container(
        child: FutureBuilder<List<Organizer>>(
          future: organizersRepository.fetchOrganizers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final organizers = snapshot.data.toList();

              return GridView.count(
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 2
                        : 4,
                children: organizers
                    .map((f) => Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: InkResponse(
                            onTap: () {},
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: Container(
                                    child: ExtendedImage.network(
                                      f.pictureUrl + '?w=360',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black54,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          f.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: InkWell(onTap: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) => SimpleDialog(
                                                title: Text(f.name),
                                                contentPadding:
                                                    EdgeInsets.all(24.0),
                                                children: <Widget>[
                                                  ContentfulRichText(
                                                          (f.longBioMap))
                                                      .documentToWidgetTree,
                                                ],
                                              ));
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              );
            } else {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
