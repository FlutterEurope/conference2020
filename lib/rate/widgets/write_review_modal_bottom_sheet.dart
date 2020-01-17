import 'package:flutter/material.dart';

Future<String> showWriteReviewModalBottomSheet<String>(BuildContext context,
    {String initialValue}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _WriteReviewModalBottomSheet(
      initialValue: initialValue ?? "",
    ),
  );
}

class _WriteReviewModalBottomSheet extends StatefulWidget {
  final String initialValue;

  _WriteReviewModalBottomSheet({Key key, this.initialValue}) : super(key: key);

  @override
  _WriteReviewModalBottomSheetState createState() =>
      _WriteReviewModalBottomSheetState();
}

class _WriteReviewModalBottomSheetState
    extends State<_WriteReviewModalBottomSheet> {
  TextEditingController _controller;
  bool canSubmit = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(canSubmitListener);
  }

  @override
  void dispose() {
    _controller.removeListener(canSubmitListener);
    _controller.dispose();

    super.dispose();
  }

  void canSubmitListener() {
    this.setState(() {
      canSubmit = _controller.text.length >= 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              maxLines: null,
              cursorColor: Theme.of(context).accentColor,
              autofocus: true,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: "How did you like the talk? (min. 10 letters).",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Review will be visible only to the speaker.",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                FlatButton(
                  textColor: Theme.of(context).accentColor,
                  child: Text("Submit"),
                  onPressed: this.canSubmit
                      ? () {
                          Navigator.of(context).pop(_controller.text.trim());
                        }
                      : null,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
