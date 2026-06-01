class PropertyRatingModel {
  final String propertyId;
  final String userId;
  final int rating;
  final String comment;
  final String date;

  PropertyRatingModel({
    required this.propertyId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      "propertyId": propertyId,
      "userId": userId,
      "rating": rating,
      "comment": comment,
      "date": date,
    };
  }

  factory PropertyRatingModel.fromJson(Map<String, dynamic> json) {
    return PropertyRatingModel(
      propertyId: json['propertyId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      rating: _parseInt(json['rating']),
      comment: json['comment'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? (double.tryParse(value)?.round() ?? 0);
    return 0;
  }
}
