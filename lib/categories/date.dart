import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TimeDate extends StatefulWidget {
  const TimeDate({super.key});

  @override
  State<TimeDate> createState() => _TimeDateState();
}

class _TimeDateState extends State<TimeDate> {
  DateTime? _selectedCalendarDate;
  DateTime _focusedCalendarDate = DateTime.now();
  final DateTime _initialCalendarDate = DateTime.utc(2010, 10, 16);
  final DateTime _lastCalendarDate = DateTime.utc(2030, 3, 14);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  ValueNotifier<DateTime?> selectedDate = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _selectedCalendarDate = _focusedCalendarDate;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedCalendarDate, selectedDay)) {
      setState(() {
        _selectedCalendarDate = selectedDay;
        _focusedCalendarDate = focusedDay;
        selectedDate.value = selectedDay;
      });
    }
  }

  void _changeCalendarFormat(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 5.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            side: BorderSide(color: Colors.red, width: 2.0),
          ),
          child: TableCalendar(
            onFormatChanged: _changeCalendarFormat,
            selectedDayPredicate: (currentSelectedDate) {
              return (isSameDay(_selectedCalendarDate!, currentSelectedDate));
            },
            onDaySelected: _onDaySelected,
            focusedDay: _focusedCalendarDate,
            firstDay: _initialCalendarDate,
            lastDay: _lastCalendarDate,
            calendarFormat: _calendarFormat,
            weekendDays: const [DateTime.saturday, DateTime.saturday],
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekHeight: 45.0,
            rowHeight: 45.0,
            headerStyle: const HeaderStyle(
              headerPadding: EdgeInsets.all(3),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              formatButtonTextStyle:
                  TextStyle(color: Colors.red, fontSize: 14.0),
              formatButtonDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(14.0),
                ),
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 28,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 28,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
            ),
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(color: Colors.red),
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 98, 98),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        ValueListenableBuilder<DateTime?>(
          valueListenable: selectedDate,
          builder: (context, selectedDate, child) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Selected Day ${selectedDate?.toString().split(" ")[0] ?? ''}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
