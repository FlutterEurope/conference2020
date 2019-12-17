import 'package:conferenceapp/agenda/repository/talks_repository.dart';
import 'package:conferenceapp/agenda/widgets/talk_card_widgets/favorite_button.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/profile/favorites_repository.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TalkPage extends StatelessWidget {
  TalkPage(this.id);

  final String id;

  @override
  Widget build(BuildContext context) {
    final talkStream = Provider.of<TalkRepository>(context).talk(id);
    return StreamBuilder<Talk>(
        stream: talkStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final talk = snapshot.data;
            return TalkPageContent(talk: talk);
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

class TalkPageContent extends StatelessWidget {
  const TalkPageContent({
    Key key,
    @required this.talk,
  }) : super(key: key);

  final Talk talk;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black45
              : Colors.white54,
        ),
        actions: <Widget>[
          TalkDetailsFavoriteButton(talk: talk),
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (var author in talk.authors)
                    Column(
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 120,
                              height: 120,
                              child: Stack(
                                children: <Widget>[
                                  DottedBorder(
                                    borderType: BorderType.Circle,
                                    dashPattern: [4, 4],
                                    child: Center(
                                      child: CircleAvatar(
                                        radius: 120,
                                        backgroundImage:
                                            ExtendedNetworkImageProvider(
                                                author.avatar),
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(32),
                                      clipBehavior: Clip.antiAlias,
                                      color: Colors.white,
                                      child: IconButton(
                                        onPressed: () {
                                          print(author.twitter);

                                          openTwitter(author.twitter);
                                        },
                                        iconSize: 32,
                                        tooltip: 'See Twitter profile',
                                        color: Colors.blue,
                                        padding: EdgeInsets.all(0.0),
                                        visualDensity: VisualDensity.compact,
                                        icon: Icon(LineIcons.twitter),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Text(
                              author.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            child: Text(
                              author.occupation,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Container(
                child: Text(
                  talk.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Description',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      talk.description ?? 'No description',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Speakers',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    for (var author in talk.authors)
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.body2,
                          children: <TextSpan>[
                            TextSpan(
                                text: author.name,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ': '),
                            TextSpan(
                              text: author.longBio ?? 'No description',
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }

  void openTwitter(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}

class TalkDetailsFavoriteButton extends StatelessWidget {
  const TalkDetailsFavoriteButton({
    Key key,
    @required this.talk,
  }) : super(key: key);

  final Talk talk;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Talk>>(
      stream: Provider.of<FavoritesRepository>(context).favoriteTalks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final fav = snapshot.data.firstWhere((Talk n) => n.id == talk.id,
                  orElse: () => null) !=
              null;
          return FavoriteButton(
            isFavorite: fav,
            talkId: talk.id,
          );
        }
        return Container();
      },
    );
  }
}
