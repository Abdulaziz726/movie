class TimeSlot {
  final String id;
  final String time;
  final int capacity;
  final int booked;

  TimeSlot(
      {required this.id,
      required this.time,
      required this.capacity,
      required this.booked});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['_id'],
      time: json['time'],
      capacity: json['capacity'],
      booked: json['booked'],
    );
  }
}

class Movie {
  final String id;
  final String title;
  final List<TimeSlot> timeSlots;

  Movie({required this.id, required this.title, required this.timeSlots});

  factory Movie.fromJson(Map<String, dynamic> json) {
    var slots = (json['timeSlots'] as List)
        .map((slot) => TimeSlot.fromJson(slot))
        .toList();
    return Movie(
      id: json['_id'],
      title: json['title'],
      timeSlots: slots,
    );
  }
}
