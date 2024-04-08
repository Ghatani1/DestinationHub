// ignore_for_file: use_build_context_synchronously, unused_local_variable
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/global_variables.dart';
import 'package:destination/modals/calendarevent.dart';
import 'package:destination/controllers/notification_controller.dart';
import 'package:destination/services/snackbar.dart';
import 'package:destination/utils/colors.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:table_calendar/table_calendar.dart';

class Reminder extends StatefulWidget {
  const Reminder({super.key});

  @override
  State<Reminder> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Reminder> {
  late String eventName = "";
  late String eventPlace = "";
  late String eventDate = "";
  late String eventTime = "";
  late String eventDescription = "";
  final TextEditingController _name = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _reminder = TextEditingController();
  final ValueNotifier<DateTime?> dateSub = ValueNotifier(null);
  geteventName(name) {
    eventName = name;
  }

  getvisitPlace(place) {
    eventPlace = place;
  }

  getvisitDate(date) {
    eventDate = date;
  }

  getvisitTime(time) {
    eventTime = time;
  }

  geteventDescription(description) {
    eventDescription = description;
  }

  createData(String userId, user) {
    // Use the userId parameter to associate the event with the user
    DateTime? dateVal = dateSub.value;
    String formattedTime = _time.text;
    if (eventName.isNotEmpty &&
        eventPlace.isNotEmpty &&
        dateVal != null &&
        formattedTime.isNotEmpty &&
        eventDescription.isNotEmpty) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("MyActivities")
          .doc(userId) // Use userId to associate the event with the user
          .collection("Events") // Create a subcollection for events
          .doc(eventName);
      Map<String, dynamic> activity = {
        "eventName": eventName,
        "eventPlace": eventPlace,
        "eventDate": dateVal.toString(),
        "eventTime": formattedTime,
        "eventDescription": eventDescription
      };
      documentReference
          .set(activity) // Add this line to add data to Firestore
          .then((value) {
        // Clear text fields and reset date value after adding data to Firestore
        _name.clear();
        _place.clear();
        _date.clear();
        _time.clear();
        _description.clear();
        dateSub.value = null;
        // Show success message
        ESnackBar.showSuccess(context, "Event has been added to list");
        Event newEvent = Event(
          eventName: eventName,
          eventDate: dateVal.toString(),
        );
        // addEvent(newEvent);
      }).catchError((error) {
        // Show error message if data couldn't be added to Firestore
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to add event: $error"),
            backgroundColor: kPrimary));
      });
    } else {
      return "Please fill out all the fields";
    }
  }

  readData() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyActivities").doc(eventName);
    await documentReference.get().then((datasnapshot) {
      (datasnapshot.get("eventName"));
      (datasnapshot.get("eventPlace"));
      (datasnapshot.get("eventDate"));
      (datasnapshot.get("eventTime"));
      (datasnapshot.get("eventDescription"));
    });
  }

  void showNotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 1,
      channelKey: 'added_event',
      title: eventName,
      body: eventDescription,
    ));
  }

  void scheduleNotification(
      String eventName, String eventDescription, DateTime dateTime) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'event_reminder',
        title: eventName,
        body: eventDescription,
      ),
      schedule: NotificationCalendar(
        year: dateTime.year,
        month: dateTime.month,
        day: dateTime.day,
        hour: dateTime.hour,
        minute: dateTime.minute,
        second: 0,
        millisecond: 0,
        allowWhileIdle: true,
      ),
    );
  }

  void reminderNotification(String reminderText, DateTime? selectedDateTime) {
    if (selectedDateTime != null) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 3,
          channelKey: 'own_reminder',
          title: 'Upcoming Event',
          body: reminderText,
        ),
        schedule: NotificationCalendar.fromDate(
          date: selectedDateTime,
        ),
      );
    }
  }

  int notificationCount = 0;
  void updateNotificationCount(int newCount) {
    setState(() {
      notificationCount = newCount;
    });
  }

  DateTime? selectedDateTime;

  final NotificationController _notificationController = Get.find();

  // void addEvent(Event event) {
  //   final DateTime eventDate =
  //       DateTime.parse(event.eventDate); // Convert string to DateTime
  //   if (events.containsKey(eventDate)) {
  //     events[eventDate]!.add(event);
  //   } else {
  //     events[eventDate] = [event];
  //   }
  // }

  Map<DateTime, List<Event>> events = {};

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // late final ValueNotifier<List<Event>> _selectedEvents;

  // @override
  // void initState() {
  //   super.initState();
  //   events = {};
  //   _selectedDay = DateTime.now(); // Initialize _selectedDay to current date
  //   _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  // }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: badges.Badge(
                showBadge: true,
                ignorePointer: false,
                badgeContent: Obx(() => Text(
                    _notificationController.notificationCount > 99
                        ? '99+'
                        : _notificationController.notificationCount.value
                            .toString(),
                    style: const TextStyle(
                        fontSize: 10,
                        color: kWhite,
                        fontWeight: FontWeight.bold))),
                position: BadgePosition.topEnd(top: 0, end: 5),
                badgeAnimation: const badges.BadgeAnimation.rotation(
                  animationDuration: Duration(milliseconds: 1),
                  colorChangeAnimationDuration: Duration(seconds: 1),
                  loopAnimation: true,
                  curve: Curves.fastOutSlowIn,
                  colorChangeAnimationCurve: Curves.bounceInOut,
                ),
                badgeStyle: badges.BadgeStyle(
                  padding: const EdgeInsets.all(2),
                  borderRadius: BorderRadius.circular(4),
                  shape: badges.BadgeShape.square,
                  badgeColor: kSecondary,
                  elevation: 0,
                ),
                child: IconButton(
                  onPressed: () {
                    _notificationController.updateNotificationCount(0);
                    Get.toNamed('/EditReminder');
                  },
                  icon: const Icon(Icons.edit_document, color: Colors.white),
                ),
              ),
            ),
          ],
          backgroundColor: kPrimary,
          centerTitle: true,
          title: const Text('Reminder',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
      body: Reminder(),
    );
  }

  Widget Reminder() {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TableCalendar(
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            // _selectedEvents.value = _getEventsForDay(selectedDay);
          });
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        eventLoader: _getEventsForDay,
      ),

      // SizedBox(
      //   height: 80, // Adjust height as needed
      //   child: ValueListenableBuilder<List<Event>>(
      //     valueListenable: _selectedEvents,
      //     builder: (context, value, _) {
      //       return ListView.builder(
      //         itemCount: value.length,
      //         itemBuilder: (context, index) {
      //           return Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 8.0),
      //             child: ListTile(
      //               title: Text(value[index].eventName),
      //               onTap: () {},
      //             ),
      //           );
      //         },
      //       );
      //     },
      //   ),
      // ),

      const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text('Create Activity Plan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),

      //Evenmt Name Field
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
            height: 60,
            width: 400,
            child: TextField(
                controller: _name,
                onChanged: (String name) {
                  geteventName(name); // Call the method to set eventName
                },
                decoration: InputDecoration(
                    hintText: 'Party, Visit, Dinner.....',
                    labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    prefixIcon: const Icon(Icons.event, color: kSecondary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    label: const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text("Events "))))),
      ),

      // Event Place Field
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
            height: 60,
            width: 400,
            child: TextField(
                controller: _place,
                onChanged: (String place) {
                  getvisitPlace(place);
                },
                decoration: InputDecoration(
                    hintText: 'Kathmandu,Bouddha',
                    labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    prefixIcon: const Icon(Icons.place, color: kSecondary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    label: const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text("Place "))))),
      ),

      // Event Date Field
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ValueListenableBuilder<DateTime?>(
              valueListenable: dateSub,
              builder: (context, dateVal, child) {
                // Update the text field's controller when dateVal changes
                if (dateVal != null) {
                  _date.text =
                      "${dateVal.year}/${dateVal.month.toString().padLeft(2, '0')}/${dateVal.day.toString().padLeft(2, '0')}";
                }
                return SizedBox(
                    height: 60,
                    width: 180,
                    child: TextField(
                        onChanged: (String date) {
                          getvisitDate(date);
                          _date.clear();
                        },
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050),
                              currentDate: DateTime.now(),
                              initialEntryMode: DatePickerEntryMode.calendar,
                              initialDatePickerMode: DatePickerMode.day,
                              builder: (context, child) {
                                return Theme(
                                    data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.fromSwatch(
                                            primarySwatch: kSecondary,
                                            accentColor: kSecondary)),
                                    child: child!);
                              });
                          dateSub.value = date;
                        },
                        controller: _date,
                        decoration: InputDecoration(
                            hintText: 'YYYY/MM/DD',
                            labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                            prefixIcon:
                                const Icon(Icons.date_range, color: kSecondary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            label: const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text("Date")))));
              }),
          ValueListenableBuilder<DateTime?>(
            valueListenable: dateSub,
            builder: (context, timeVal, child) {
              String formattedTime = timeVal != null
                  ? TimeOfDay.fromDateTime(timeVal).format(context)
                  : '';

              _time.text = formattedTime;

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                    height: 60,
                    width: 180,
                    child: TextField(
                        onChanged: (String time) {
                          getvisitTime(time);
                        },
                        onTap: () async {
                          TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) {
                                return Theme(
                                    data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.fromSwatch(
                                      primarySwatch: kSecondary,
                                      accentColor: kSecondary,
                                    )),
                                    child: child!);
                              });
                          if (selectedTime != null) {
                            DateTime selectedDateTime = DateTime(
                              timeVal?.year ?? DateTime.now().year,
                              timeVal?.month ?? DateTime.now().month,
                              timeVal?.day ?? DateTime.now().day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            dateSub.value = selectedDateTime;
                            _time.text = selectedTime.format(context);
                          }
                        },
                        readOnly: true,
                        controller: _time,
                        decoration: InputDecoration(
                            hintText: 'HH:MM',
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            prefixIcon: const Icon(
                              Icons.access_time,
                              color: kSecondary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            label: const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text("Time"),
                            )))),
              );
            },
          )
        ]),
      ),

      Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
            height: 120,
            width: 400,
            child: TextField(
              controller: _description,
              onChanged: (String description) {
                geteventDescription(description);
              },
              decoration: InputDecoration(
                  hintText: 'Things need to be done.....',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  prefixIcon: const Icon(Icons.description, color: kSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  label: const Text("Description")),
              maxLines: 10, // Set this to allow unlimited lines
              textInputAction:
                  TextInputAction.newline, // Allow user to insert line breaks
            )),
      ),

      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kSecondary, foregroundColor: kWhite),
                onPressed: () {
                  if (_name.text.isEmpty ||
                      _place.text.isEmpty ||
                      _date.text.isEmpty ||
                      _time.text.isEmpty ||
                      _description.text.isEmpty) {
                  } else {
                    // If all fields are filled, increment notification count and show notification
                    setState(() {
                      _notificationController.notificationCount++;
                      showNotification();
                    });
                    // Schedule notification
                    scheduleNotification(
                        eventName, eventDescription, dateSub.value!);
                  }
                  String message = createData('id', userId);
                  if (message == "Event has been added to list") {
                    ESnackBar.showSuccess(context, message);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(message), backgroundColor: kPrimary));
                  }
                },
                child: const Text(
                  'Add Event',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text('Do you want to add a reminder for yoyr event?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 60,
              width: 400,
              child: TextField(
                controller: _reminder,
                decoration: InputDecoration(
                  hintText: 'Create Your Event Reminder',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  prefixIcon: const Icon(Icons.event, color: kSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  label: const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text("Events "),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () async {
                DateTime? selectedDate = await DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  onChanged: (date) {
                    ('change $date in time zone ${date.timeZoneOffset.inHours}');
                    setState(() {
                      selectedDateTime = date;
                    });
                  },
                  onConfirm: (date) {
                    ('confirm $date');
                    setState(() {
                      selectedDateTime = date;
                    });
                  },
                  currentTime: DateTime.now(),
                );
                if (selectedDate != null) {
                  setState(() {
                    selectedDateTime = selectedDate;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(
                    // Format the selectedDateTime to display in the TextFormField
                    text: selectedDateTime != null
                        ? '${selectedDateTime!.year}-${selectedDateTime!.month}-${selectedDateTime!.day} ${selectedDateTime!.hour}:${selectedDateTime!.minute}'
                        : 'No date selected',
                  ),
                  readOnly: true, // Make the TextFormField read-only
                  decoration: InputDecoration(
                    hintText: 'Selected Date & Time',
                    prefixIcon: const Icon(
                      Icons.date_range,
                      color: kSecondary,
                    ),
                    suffixIcon: selectedDateTime != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                selectedDateTime = null;
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    label: const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text('Selected Date & Time'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSecondary,
                  foregroundColor: kWhite,
                ),
                onPressed: () {
                  String reminderText = _reminder.text;
                  if (reminderText.isEmpty || selectedDateTime == null) {
                    // Show message if either reminder text or selected date time is empty
                    ESnackBar.showError(
                        context, 'Add event or Select Date and time');
                  } else {
                    // Call the reminderNotification function with reminder text and selected date time
                    reminderNotification(reminderText, selectedDateTime);
                    // Clear the event reminder text field
                    _reminder.clear();
                    // Clear the selectedDateTime
                    setState(() {
                      selectedDateTime = null;
                    });
                    // Show confirmation message
                    ESnackBar.showSuccess(context, 'Reminder has been added');
                  }
                },
                child: const Text(
                  'Add Event',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    ]));
  }
}
