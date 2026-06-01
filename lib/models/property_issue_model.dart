class PropertyIssueModel {
  final String id;
  final String propertyId;
  final String title;
  final String description;
  final double cost;
  final String date;
  final String status; // 'pending', 'approved', 'rejected'

  PropertyIssueModel({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.description,
    required this.cost,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "propertyId": propertyId,
      "title": title,
      "description": description,
      "cost": cost,
      "date": date,
      "status": status,
    };
  }

  factory PropertyIssueModel.fromJson(Map<String, dynamic> json) {
    return PropertyIssueModel(
      id: json['id'] as String? ?? '',
      propertyId: json['propertyId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
    );
  }
}
