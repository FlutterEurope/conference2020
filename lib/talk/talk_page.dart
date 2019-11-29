import 'package:conferenceapp/agenda/repository/talks_repository.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (var author in talk.authors)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 120,
                      height: 120,
                      child: DottedBorder(
                        borderType: BorderType.Circle,
                        dashPattern: [4, 4],
                        child: Center(
                          child: CircleAvatar(
                            radius: 120,
                            backgroundImage:
                                ExtendedNetworkImageProvider(author.avatar),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
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
          ],
        ),
      ),
    );
  }
}
