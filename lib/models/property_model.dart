class PropertyModel {
  final String id;
  String name;
  String? address;
  int units;
  final DateTime createdAt;

  PropertyModel({
    required this.id,
    required this.name,
    this.address,
    this.units = 1,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'units': units,
        'createdAt': createdAt.toIso8601String(),
      };

  static PropertyModel fromJson(Map<String, dynamic> json) => PropertyModel(
        id: json['id'] as String,
        name: json['name'] as String,
        address: json['address'] as String?,
        units: json['units'] as int? ?? 1,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      );
}
