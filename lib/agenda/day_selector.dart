import 'package:conferenceapp/agenda/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DaySelectorContainer extends StatelessWidget {
  const DaySelectorContainer(
    this.pageController,
    this.index, {
    Key key,
  }) : super(key: key);

  final PageController pageController;
  final int index;

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.grey[100];

    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: bgColor,
              style: BorderStyle.solid,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: DaySelector(bgColor, pageController, index),
        ),
      ),
    );
  }
}

class DaySelector extends StatelessWidget {
  const DaySelector(
    this.bgColor,
    this.pageController,
    this.index, {
    Key key,
  }) : super(key: key);

  final Color bgColor;
  final PageController pageController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaBloc, AgendaState>(
      builder: (context, state) {
        final selectedDay = index;

        return Stack(
          children: <Widget>[
            AnimatedPositioned(
              top: 0,
              bottom: 0,
              left: selectedDay == 0
                  ? 0
                  : (MediaQuery.of(context).size.width - 24.0) / 2.0,
              right: selectedDay == 0
                  ? (MediaQuery.of(context).size.width - 24.0) / 2.0
                  : 0,
              duration: Duration(milliseconds: 300),
              child: Container(
                color: bgColor,
              ),
              curve: Curves.easeOut,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () {
                        pageController.animateToPage(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Day 1',
                              style: TextStyle(
                                color: selectedDay == 0
                                    ? Theme.of(context).primaryColor
                                    : bgColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () {
                        pageController.animateToPage(
                          1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Day 2',
                              style: TextStyle(
                                color: selectedDay != 0
                                    ? Theme.of(context).primaryColor
                                    : bgColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
