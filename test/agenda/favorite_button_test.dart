import 'package:conferenceapp/agenda/talk_card.dart';
import 'package:conferenceapp/profile/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

main() {
  MockFavoritesRepository favoritesRepo;

  setUp(() {
    favoritesRepo = MockFavoritesRepository();
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
        body: RepositoryProvider<FavoritesRepository>(
          builder: (_) => favoritesRepository,
          child: Stack(
            children: <Widget>[
              FavoriteButton(
                talkId: talkId,
                isFavorite: isFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
