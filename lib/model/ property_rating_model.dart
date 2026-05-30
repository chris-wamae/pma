class PropertyRatingModel {
  String propertyId;
  String propertyName;
  int rating;
  String comment;
  String date;

  PropertyRatingModel({
    required this.propertyId,
    required this.propertyName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "propertyId": propertyId,
      "propertyName": propertyName,
      "rating": rating,
      "comment": comment,
      "date": date,
    };
  }

  factory PropertyRatingModel.fromMap(Map<String, dynamic> map) {
    return PropertyRatingModel(
      propertyId: map["propertyId"] ?? "",
      propertyName: map["propertyName"] ?? "",
      rating: map["rating"] ?? 0,
      comment: map["comment"] ?? "",
      date: map["date"] ?? "",
    );
  }
}
