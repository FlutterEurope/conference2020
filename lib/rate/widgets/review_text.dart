import 'package:flutter/material.dart';

import 'write_review_modal_bottom_sheet.dart';

class ReviewText extends StatelessWidget {
  final String review;
  final Function(String) onReviewSubmitted;

  const ReviewText(this.review, {Key key, @required this.onReviewSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: InkWell(
        onTap: () async {
          final review = await showWriteReviewModalBottomSheet(context,
              initialValue: this.review);

          this.onReviewSubmitted(review);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "\"" + this.review + "\"",
            style: TextStyle(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
