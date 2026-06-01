class PropertyModel {
  final String id;
  final String ownerId;
  String name;
  String? address;
  int units;
  final DateTime createdAt;

  PropertyModel({
    required this.id,
    required this.ownerId,
    required this.name,
    this.address,
    this.units = 1,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'ownerId': ownerId,
        'name': name,
        'address': address,
        'units': units,
        'createdAt': createdAt.toIso8601String(),
      };

  static PropertyModel fromJson(Map<String, dynamic> json) => PropertyModel(
        id: json['id'] as String? ?? '',
        ownerId: json['ownerId'] as String? ?? '',
        name: json['name'] as String? ?? 'Unknown Property',
        address: json['address'] as String?,
        units: json['units'] as int? ?? 1,
        createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
      );
}
