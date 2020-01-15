import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:conferenceapp/agenda/repository/talks_repository.dart';
import 'package:conferenceapp/agenda/widgets/talk_card_widgets/favorite_button.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/model/author.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/profile/favorites_repository.dart';
import 'package:conferenceapp/rate/bloc/bloc.dart';
import 'package:conferenceapp/rate/repository/ratings_repository.dart';
import 'package:contentful_rich_text/contentful_rich_text.dart';
import 'package:contentful_rich_text/types/types.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:conferenceapp/utils/contentful_helper.dart';

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
              appBar: AppBar(
                backgroundColor:
                    Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).scaffoldBackgroundColor,
                title: Text(''),
                centerTitle: false,
              ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(LineIcons.calendar_plus_o),
        tooltip: 'Add to calendar',
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          try {
            final Event event = Event(
              title: talk.title,
              description:
                  Document.fromJson(talk.descriptionMap).toSimpleString(),
              location:
                  'Centrum konferencyjne w Centrum Nauki Kopernik, Wybrzeże Kościuszkowskie 20, 00-390 Warszawa',
              startDate: talk.startTime,
              endDate: talk.endTime,
              allDay: false,
            );

            Add2Calendar.addEvent2Cal(event);
          } catch (e, s) {
            logger.errorException(e, s);
          }
        },
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: false,
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
            actions: <Widget>[
              TalkDetailsFavoriteButton(talk: talk),
            ],
            title: Text(talk.title),
            centerTitle: false,
          ),
          SliverList(
            delegate: new SliverChildListDelegate([
              TopHeader(talk: talk),
              TalkTitle(talk: talk),
              TalkRating(talk: talk),
              if (talk.description != null) TalkDetails(talk: talk),
            ]),
          ),
        ],
      ),
    );
  }
}

class TalkRating extends StatefulWidget {
  const TalkRating({
    Key key,
    @required this.talk,
  }) : super(key: key);

  final Talk talk;

  @override
  _TalkRatingState createState() => _TalkRatingState();
}

class _TalkRatingState extends State<TalkRating> {
  RateBloc _rateBloc;
  double rating = 0.0;

  @override
  void dispose() {
    _rateBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _rateBloc ??= RateBloc(Provider.of<RatingsRepository>(context))
      ..add(FetchRateTalk(widget.talk));

    return BlocListener<RateBloc, RateState>(
      bloc: _rateBloc,
      listener: (context, state) {
        if (state is RatingTalkToEarlyErrorState) {
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Talk can be rated 5 minutes before the presentation is finished."),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).accentColor,
            ),
          );
        }
      },
      child: BlocBuilder<RateBloc, RateState>(
        bloc: _rateBloc,
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text('Rate the talk'),
              Center(
                child: SmoothStarRating(
                  allowHalfRating: false,
                  onRatingChanged: (v) {
                    _rateBloc.add(RateTalk(widget.talk, v));
                  },
                  starCount: 5,
                  rating: _rateBloc.rating ?? 0.0,
                  size: 40.0,
                  color: Theme.of(context).accentColor,
                  borderColor: Theme.of(context).accentColor,
                  spacing: 0.0,
                ),
              ),
              if (state is TalkRatedState)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: RichText(
                      text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: 'Enjoyed the talk? Share it on Twitter! ',
                            ),
                            WidgetSpan(
                              child: Icon(
                                LineIcons.twitter,
                                color: Colors.blue,
                                size: 18,
                              ),
                            )
                          ]),
                    ),
                    onPressed: shareToTwitter,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void shareToTwitter() {
    try {
      final twitters = widget.talk.authors
          .map((f) => f.twitter?.isNotEmpty == true
              ? '@' + f.twitter?.split('/')?.last
              : '')
          .join(' ');
      final body =
          'I really enjoyed talk ${widget.talk.title} by ${widget.talk.authors.join(', ')} at @FlutterEurope #fluttereurope $twitters';
      Share.share(
        body,
        subject: body,
      );
    } catch (e, s) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Ups, we have a problem here.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).accentColor,
      ));
      logger.error('Problem during share to Twitter');
      logger.errorException(e, s);
    }
  }
}

class TalkTitle extends StatelessWidget {
  const TalkTitle({
    Key key,
    @required this.talk,
  }) : super(key: key);

  final Talk talk;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        talk.title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class TalkDetails extends StatelessWidget {
  const TalkDetails({
    Key key,
    @required this.talk,
  }) : super(key: key);

  final Talk talk;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 6),
          Text(
            'Description',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          ContentfulRichText(talk.descriptionMap).documentToWidgetTree,
          SizedBox(height: 32),
          Column(
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
                CustomExpandablePanel(
                  header: author.name,
                  content: author.longBio,
                ),
            ],
          ),
          SizedBox(height: 56),
        ],
      ),
    );
  }
}

class CustomExpandablePanel extends StatelessWidget {
  const CustomExpandablePanel({
    Key key,
    this.header,
    @required this.content,
  }) : super(key: key);

  final String header;
  final String content;

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: header != null
          ? Row(
              children: <Widget>[
                Text(
                  header,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : null,
      collapsed: ExpandableButton(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Text(
                content,
                softWrap: true,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ExpandableIcon(
              theme: ExpandableThemeData.combine(
                ExpandableThemeData(
                  iconColor: Theme.of(context).textTheme.body1.color,
                ),
                ExpandableThemeData.defaults,
              ),
            )
          ],
        ),
      ),
      expanded: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Text(
              content,
              softWrap: true,
            ),
          ),
          ExpandableIcon(
            theme: ExpandableThemeData.combine(
              ExpandableThemeData(
                iconColor: Theme.of(context).textTheme.body1.color,
              ),
              ExpandableThemeData.defaults,
            ),
          )
        ],
      ),
      tapBodyToCollapse: true,
      hasIcon: false,
    );
  }
}

class TopHeader extends StatelessWidget {
  const TopHeader({
    Key key,
    @required this.talk,
  }) : super(key: key);

  final Talk talk;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                              backgroundImage: ExtendedNetworkImageProvider(
                                  author.avatar + '?fit=fill&w=300&h=300'),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: TwitterButton(author: author),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SpeakerNameAndJob(author: author),
            ],
          ),
      ],
    );
  }
}

class SpeakerNameAndJob extends StatelessWidget {
  const SpeakerNameAndJob({
    Key key,
    @required this.author,
  }) : super(key: key);

  final Author author;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
    );
  }
}

class TwitterButton extends StatelessWidget {
  const TwitterButton({
    Key key,
    @required this.author,
  }) : super(key: key);

  final Author author;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(32),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: IconButton(
        onPressed: () {
          openTwitter(author.twitter);
        },
        iconSize: 32,
        tooltip: 'See Twitter profile',
        color: Colors.blue,
        padding: EdgeInsets.all(0.0),
        // visualDensity: VisualDensity.compact,
        icon: Icon(LineIcons.twitter),
      ),
    );
  }

  void openTwitter(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      logger.warn('Could not launch $url');
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
            talk: talk,
          );
        }
        return Container();
      },
    );
  }
}
