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
        ? Colors.blue[100]
        : Colors.blue[900];

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: bgColor,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              DaySelector(bgColor, pageController, index),
            ],
          ),
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
                  : (MediaQuery.of(context).size.width - 24) / 2,
              right: selectedDay == 0
                  ? (MediaQuery.of(context).size.width - 24) / 2
                  : 0,
              duration: Duration(milliseconds: 300),
              child: Container(
                color: bgColor,
              ),
              curve: Curves.easeOutBack,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Material(
                    type: MaterialType.transparency,
                    child: Semantics(
                      button: true,
                      enabled: selectedDay != 0,
                      hint: 'Select day no. 1',
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
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                'Day 1',
                                style: TextStyle(
                                  color: selectedDay == 0
                                      ? Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Theme.of(context).primaryColor
                                          : Colors.white
                                      : Theme.of(context).brightness ==
                                              Brightness.light
                                          ? bgColor
                                          : Colors.grey[300],
                                ),
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
                    child: Semantics(
                      button: true,
                      enabled: selectedDay != 1,
                      hint: 'Select day no. 2',
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
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                'Day 2',
                                style: TextStyle(
                                  color: selectedDay != 0
                                      ? Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Theme.of(context).primaryColor
                                          : Colors.white
                                      : Theme.of(context).brightness ==
                                              Brightness.light
                                          ? bgColor
                                          : Colors.grey[300],
                                ),
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
