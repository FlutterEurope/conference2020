import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class AccountAvatar extends StatelessWidget {
  const AccountAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Padding(
        padding: const EdgeInsets.all(5.0),
        child: CircleAvatar(
          backgroundImage: ExtendedNetworkImageProvider(
            'https://picsum.photos/id/433/100/100',
            cache: true,
          ),
        ),
      ),
    );
  }
}
