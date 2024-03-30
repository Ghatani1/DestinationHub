class Event {
  final String eventName;
  final String eventDate;

  Event({
    required this.eventName,
    required this.eventDate,
  });

  @override
  String toString() {
    return eventName;
  }
}
