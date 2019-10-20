import 'package:flutter/material.dart';

class AccountAvatar extends StatelessWidget {
  const AccountAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: CircleAvatar(
        backgroundImage: NetworkImage('https://picsum.photos/id/433/200/200'),
      ),
    );
  }
}
