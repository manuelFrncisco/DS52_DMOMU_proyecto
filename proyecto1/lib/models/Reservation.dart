
class Reservation {
  final int id;
  final int userId;
  final DateTime startDate;
  final DateTime endDate;
  final String name;
  final int lodgingId;

  Reservation({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.name,
    required this.lodgingId
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
       name: json['lodging']['name'] ?? "",
      startDate: DateTime.parse(json['start_date'] ?? ""),
      endDate: DateTime.parse(json['end_date'] ?? ""),
      lodgingId: json['lodging_id'] ?? 0
    );
  }
}
