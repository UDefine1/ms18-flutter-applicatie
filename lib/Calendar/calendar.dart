import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

import '../menu.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  final CalendarController<Event> controller = CalendarController();
  final CalendarEventsController<Event> eventController =
      CalendarEventsController<Event>();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    eventController.addEvents([
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: now,
          end: now.add(const Duration(hours: 1)),
        ),
        eventData: Event(title: 'Event 1'),
      ),
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: now.add(const Duration(hours: 2)),
          end: now.add(const Duration(hours: 5)),
        ),
        eventData: Event(title: 'Event 2'),
      ),
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(now.year, now.month, now.day),
          end: DateTime(now.year, now.month, now.day).add(const Duration(days: 2)),
        ),
        eventData: Event(title: 'Event 3'),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
      child: CalendarView<Event>(
        controller: controller,
        eventsController: eventController,
        viewConfiguration: const MonthConfiguration(),
        tileBuilder: _tileBuilder,
        multiDayTileBuilder: _multiDayTileBuilder,
        scheduleTileBuilder: _scheduleTileBuilder,
      ),
    );
  }

  Widget _tileBuilder(CalendarEvent<Event> event, TileConfiguration configuration) {
    final color = event.eventData?.color ?? Colors.blue;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      elevation: configuration.tileType == TileType.ghost ? 0 : 8,
      color: configuration.tileType != TileType.ghost ? color : color.withAlpha(100),
      child: Center(
        child: configuration.tileType != TileType.ghost
            ? Text(event.eventData?.title ?? 'New Event')
            : null,
      ),
    );
  }

  Widget _multiDayTileBuilder(
    CalendarEvent<Event> event,
    MultiDayTileConfiguration configuration,
  ) {
    final color = event.eventData?.color ?? Colors.blue;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      elevation: configuration.tileType == TileType.selected ? 8 : 0,
      color: configuration.tileType == TileType.ghost
          ? color.withAlpha(100)
          : color,
      child: Center(
        child: configuration.tileType != TileType.ghost
            ? Text(event.eventData?.title ?? 'New Event')
            : null,
      ),
    );
  }

  Widget _scheduleTileBuilder(
    CalendarEvent<Event> event,
    DateTime date,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: event.eventData?.color ?? Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(event.eventData?.title ?? 'New Event'),
    );
  }
}


class Event {
  Event({
    required this.title,
    this.description,
    this.color,
  });

  final String title;
  final String? description;
  final Color? color;
}
