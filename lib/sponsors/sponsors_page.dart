import 'package:collection/collection.dart';
import 'package:conferenceapp/common/appbar.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/model/sponsor.dart';
import 'package:conferenceapp/sponsors/sponsors_repository.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sponsorsRepository =
        RepositoryProvider.of<SponsorsRepository>(context);
    return Scaffold(
      appBar: FlutterEuropeAppBar(
        back: true,
        search: false,
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<Sponsor>>(
          future: sponsorsRepository.fetchSponsors(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final elems = <Widget>[];
              final grouped = groupBy(snapshot.data, (Sponsor f) => f.level);
              grouped.forEach((g, list) {
                elems.add(Center(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Sponsor level: ${g.toString().split(".")[1]}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )));
                list.forEach(
                  (s) => elems.add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: 26.0, top: 18.0),
                      child: ListTile(
                        title: Container(
                          width: 560,
                          height: 150,
                          child: ExtendedImage.network(
                            s.logoUrl + '?w=560',
                            width: 560,
                          ),
                        ),
                        onTap: () async {
                          if (await canLaunch(s.url)) {
                            await launch(s.url);
                          } else {
                            logger.info('Could not launch ${s.url}');
                          }
                        },
                      ),
                    ),
                  ),
                );
                elems.add(SizedBox(height: 30));
              });

              return ListView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                padding: EdgeInsets.all(12.0),
                children: elems,
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
