class Rating {
  final int id;
  final int number;
  final int userId;
  final int lodgingId;
  final int reservationId;

  Rating({
    required this.id,
    required this.number,
    required this.userId,
    required this.lodgingId,
    required this.reservationId,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      number: json['number'],
      userId: json['user_id'],
      lodgingId: json['lodging_id'],
      reservationId: json['reservation_id'],
    );
  }

}
