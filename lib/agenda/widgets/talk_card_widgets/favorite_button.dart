import 'package:conferenceapp/profile/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    Key key,
    @required this.isFavorite,
    @required this.talkId,
  }) : super(key: key);

  final bool isFavorite;

  final String talkId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onPressed(context),
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  void _onPressed(BuildContext context) {
    final favoritesRepo = RepositoryProvider.of<FavoritesRepository>(context);
    if (isFavorite) {
      favoritesRepo.removeTalkFromFavorites(talkId);
    } else {
      favoritesRepo.addTalkToFavorites(talkId);
    }
  }
}
