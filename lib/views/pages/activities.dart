// ignore_for_file: use_build_context_synchronously

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/services/editactivitydata.dart';
import 'package:destination/categories/date.dart';
import 'package:destination/controllers/notification_controller.dart';
import 'package:destination/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
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

  String createData() {
    DateTime? dateVal = dateSub.value;
    String formattedTime = _time.text;

    if (eventName.isNotEmpty &&
        eventPlace.isNotEmpty &&
        dateVal != null &&
        formattedTime.isNotEmpty &&
        eventDescription.isNotEmpty) {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("MyActivities").doc(eventName);
      Map<String, dynamic> activity = {
        "eventName": eventName,
        "eventPlace": eventPlace,
        "eventDate": dateVal.toString(),
        "eventTime": formattedTime,
        "eventDescription": eventDescription
      };
      documentReference.set(activity);
      _name.clear();
      _place.clear();
      _date.clear();
      _time.clear();
      _description.clear();
      dateSub.value = null;
      return "Event has been added to list";
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

  int notificationCount = 0;
  void updateNotificationCount(int newCount) {
    setState(() {
      notificationCount = newCount;
    });
  }

  final NotificationController _notificationController = Get.find();

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
                position: BadgePosition.topEnd(top: 0, end: 0),
                badgeAnimation: const badges.BadgeAnimation.rotation(
                  animationDuration: Duration(milliseconds: 1),
                  colorChangeAnimationDuration: Duration(seconds: 1),
                  loopAnimation: false,
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
                    Get.to(() => const ActivityData());
                  },
                  icon: const Icon(Icons.edit_document, color: Colors.white),
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: kPrimary,
          centerTitle: true,
          title: const Text('Activities',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
      body: activities(),
      floatingActionButton: FloatingActionButton.extended(
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
            scheduleNotification(eventName, eventDescription, dateSub.value!);
          }

          String message = createData();

          if (message == "Event has been added to list") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: kSecondary,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: kPrimary));
          }
        },
        label: const Text('Add Event'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget activities() {
    return ListView(children: [
      Column(children: [
        const TimeDate(),
        const SizedBox(height: 15),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text('Create Activity Plan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 15),

//Evenmt Name Field
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 60,
            width: 400,
            child: TextField(
                controller: _name,
                onChanged: (String name) {
                  geteventName(name);
                },
                decoration: InputDecoration(
                    hintText: 'Party, Visit, Dinner.....',
                    labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    prefixIcon: const Icon(Icons.event, color: Colors.red),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    label: const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text("Events "))))),
        const SizedBox(height: 15),

// Event Place Field
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    prefixIcon: const Icon(Icons.place, color: Colors.red),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    label: const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text("Place "))))),
        const SizedBox(height: 15),

// Event Date Field
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                                      initialEntryMode:
                                          DatePickerEntryMode.calendar,
                                      initialDatePickerMode: DatePickerMode.day,
                                      builder: (context, child) {
                                        return Theme(
                                            data: Theme.of(context).copyWith(
                                                colorScheme:
                                                    ColorScheme.fromSwatch(
                                                        primarySwatch:
                                                            Colors.red,
                                                        accentColor: kPrimary)),
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
                                    prefixIcon: const Icon(Icons.date_range,
                                        color: kPrimary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: const Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Text("Date")))));
                      }),
                  const SizedBox(height: 15),

// Event Time Field
                  ValueListenableBuilder<DateTime?>(
                    valueListenable: dateSub,
                    builder: (context, timeVal, child) {
                      String formattedTime = timeVal != null
                          ? TimeOfDay.fromDateTime(timeVal).format(context)
                          : '';

                      _time.text = formattedTime;

                      return SizedBox(
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
                                              colorScheme:
                                                  ColorScheme.fromSwatch(
                                            primarySwatch: Colors.red,
                                            accentColor: kPrimary,
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
                                    color: kPrimary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  label: const Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Text("Time"),
                                  ))));
                    },
                  )
                ])),
        const SizedBox(height: 15),

//Event Description Field

        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      prefixIcon:
                          const Icon(Icons.description, color: Colors.red),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      label: const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text("Description"),
                      )),
                  maxLines: 10, // Set this to allow unlimited lines
                  textInputAction: TextInputAction
                      .newline, // Allow user to insert line breaks
                )),
          ]),
        ),
        const Text('Do you want to add a reminder for yoyr even?')
      ])
    ]);
  }
}
