import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyRating {
  final String? id;
  final String propertyId;
  final String tenantId;
  final double rating;
  final String comment;
  final DateTime date;

  PropertyRating({
    this.id,
    required this.propertyId,
    required this.tenantId,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'tenantId': tenantId,
      'rating': rating,
      'comment': comment,
      'date': Timestamp.fromDate(date),
    };
  }
}
