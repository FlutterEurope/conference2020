import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class StarRating extends StatelessWidget {
  final Function(double) onRatingChanged;
  final double rating;

  const StarRating(
      {Key key, @required this.onRatingChanged, @required this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
      allowHalfRating: false,
      onRatingChanged: onRatingChanged,
      starCount: 5,
      rating: rating,
      size: 40.0,
      color: Theme.of(context).accentColor,
      borderColor: Theme.of(context).accentColor,
      spacing: 0.0,
    );
  }
}
