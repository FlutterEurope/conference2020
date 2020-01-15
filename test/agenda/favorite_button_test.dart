import 'package:conferenceapp/agenda/widgets/talk_card_widgets/favorite_button.dart';
import 'package:conferenceapp/utils/analytics.dart';
import 'package:conferenceapp/model/agenda.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/profile/favorites_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

class MockAnalytics extends Mock implements FirebaseAnalytics {}

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

main() {
  MockFavoritesRepository favoritesRepo;
  MockFlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  setUp(() {
    favoritesRepo = MockFavoritesRepository();
    analytics = MockAnalytics();
    flutterLocalNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
  });

  group('FavoriteButton', () {
    testWidgets('it builds', (tester) async {
      await tester.pumpWidget(
        FavoriteButtonWrapper(favoritesRepository: favoritesRepo),
      );
    });

    testWidgets('shows empty heart when not favorite', (tester) async {
      //given
      await tester.pumpWidget(
        FavoriteButtonWrapper(
          favoritesRepository: favoritesRepo,
          isFavorite: false,
        ),
      );
      //then
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('shows full heart when favorite', (tester) async {
      //given
      await tester.pumpWidget(
        FavoriteButtonWrapper(
          favoritesRepository: favoritesRepo,
          isFavorite: true,
        ),
      );
      //then
      expect(find.byIcon(Icons.favorite_border), findsNothing);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('on tap calls repository add to favorites', (tester) async {
      //given
      await tester.pumpWidget(
        FavoriteButtonWrapper(
          favoritesRepository: favoritesRepo,
          isFavorite: false,
        ),
      );
      //when
      await tester.tap(find.byType(FavoriteButton));
      //then
      verify(favoritesRepo.addTalkToFavorites('talkId')).called(1);
    });

    testWidgets('on tap calls repository remove from favorites',
        (tester) async {
      //given
      await tester.pumpWidget(
        FavoriteButtonWrapper(
          favoritesRepository: favoritesRepo,
          isFavorite: true,
        ),
      );
      //when
      await tester.tap(find.byType(FavoriteButton));
      //then
      verify(favoritesRepo.removeTalkFromFavorites('talkId')).called(1);
    });
  });
}

class FavoriteButtonWrapper extends StatelessWidget {
  final String talkId;
  final bool isFavorite;
  final MockFavoritesRepository favoritesRepository;

  const FavoriteButtonWrapper({
    Key key,
    this.talkId = 'talkId',
    this.isFavorite = false,
    @required this.favoritesRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RepositoryProvider<SharedPreferences>(
          create: (_) => MockSharedPreferences(),
          child: RepositoryProvider<FlutterLocalNotificationsPlugin>(
            create: (_) => MockFlutterLocalNotificationsPlugin(),
            child: RepositoryProvider<FavoritesRepository>(
              create: (_) => favoritesRepository,
              child: Stack(
                children: <Widget>[
                  FavoriteButton(
                    talk: Talk(
                      'talkId',
                      'title',
                      [null],
                      'description',
                      DateTime.now(),
                      DateTime.now(),
                      null,
                      TalkType.other,
                    ),
                    isFavorite: isFavorite,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
