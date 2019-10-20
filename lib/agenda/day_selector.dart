import 'package:conferenceapp/agenda/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DaySelectorContainer extends StatelessWidget {
  const DaySelectorContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              style: BorderStyle.solid,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: DaySelector(),
        ),
      ),
    );
  }
}

class DaySelector extends StatelessWidget {
  const DaySelector({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaBloc, AgendaState>(
      builder: (context, state) {
        final selectedDay =
            state is PopulatedAgendaState ? state.selectedDay : 0;
        return Stack(
          children: <Widget>[
            AnimatedPositioned(
              top: 0,
              bottom: 0,
              left: selectedDay == 1
                  ? 0
                  : (MediaQuery.of(context).size.width - 24.0) / 2.0,
              right: selectedDay == 1
                  ? (MediaQuery.of(context).size.width - 24.0) / 2.0
                  : 0,
              duration: Duration(milliseconds: 200),
              child: Container(
                color: Colors.white,
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
                        BlocProvider.of<AgendaBloc>(context)
                            .add(SwitchDay(DateTime(2020, 1, 23)));
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Day 1',
                              style: TextStyle(
                                color: selectedDay == 1
                                    ? Colors.blue
                                    : Colors.white,
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
                        BlocProvider.of<AgendaBloc>(context)
                            .add(SwitchDay(DateTime(2020, 1, 23)));
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Day 2',
                              style: TextStyle(
                                color: selectedDay == 2
                                    ? Colors.blue
                                    : Colors.white,
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
