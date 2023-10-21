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

  late ViewConfiguration currentConfiguration = viewConfigurations[0];
  List<ViewConfiguration> viewConfigurations = [
    const ScheduleConfiguration(),
    const WeekConfiguration(),
    const WorkWeekConfiguration(),
    const MonthConfiguration(),
  ];

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
        eventData: Event(title: 'World Scout Jamboree'),
      ),
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: now.add(const Duration(hours: 2)),
          end: now.add(const Duration(hours: 5)),
        ),
        eventData: Event(title: 'Voorbeeld 2'),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
      child: CalendarView<Event>(
          controller: controller,
          eventsController: eventController,
          viewConfiguration: currentConfiguration,
          tileBuilder: _tileBuilder,
          multiDayTileBuilder: _multiDayTileBuilder,
          scheduleTileBuilder: _scheduleTileBuilder,
          components: CalendarComponents(
            calendarHeaderBuilder: _calendarHeader,
          )),
    );
  }

  Widget _tileBuilder(
      CalendarEvent<Event> event, TileConfiguration configuration) {
    final color = event.eventData?.color ?? Colors.blue;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      elevation: configuration.tileType == TileType.ghost ? 0 : 8,
      color: configuration.tileType != TileType.ghost
          ? color
          : color.withAlpha(100),
      child: Center(
        child: configuration.tileType != TileType.ghost
            ? Text(event.eventData?.title ?? 'Nieuw event')
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
            ? Text(event.eventData?.title ?? 'Nieuw event')
            : null,
      ),
    );
  }

  Widget _scheduleTileBuilder(
    CalendarEvent<Event> event,
    DateTime date,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: event.eventData?.color ?? Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0), // Adjust the padding as needed
          child: Text(event.eventData?.title ?? 'Nieuw Event'),
        ),
      ),
    );
  }

  Widget _calendarHeader(DateTimeRange dateTimeRange) {
    return Row(
      children: [
        DropdownMenu(
          onSelected: (value) {
            if (value == null) return;
            setState(() {
              currentConfiguration = value;
            });
          },
          initialSelection: currentConfiguration,
          dropdownMenuEntries: viewConfigurations
              .map((e) => DropdownMenuEntry(value: e, label: e.name))
              .toList(),
        ),
        IconButton.filledTonal(
          onPressed: controller.animateToPreviousPage,
          icon: const Icon(Icons.navigate_before_rounded),
        ),
        IconButton.filledTonal(
          onPressed: controller.animateToNextPage,
          icon: const Icon(Icons.navigate_next_rounded),
        ),
      ],
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
