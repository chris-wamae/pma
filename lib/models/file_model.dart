class FileModel {
  final String id;
  final String name;
  final String url;
  final String uploadedBy;
  final DateTime uploadedAt;
  final String? associatedEntityId;
  final String? associatedEntityType; // e.g., 'property', 'maintenance_request'

  FileModel({
    required this.id,
    required this.name,
    required this.url,
    required this.uploadedBy,
    DateTime? uploadedAt,
    this.associatedEntityId,
    this.associatedEntityType,
  }) : uploadedAt = uploadedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'uploadedBy': uploadedBy,
        'uploadedAt': uploadedAt.toIso8601String(),
        'associatedEntityId': associatedEntityId,
        'associatedEntityType': associatedEntityType,
      };

  static FileModel fromJson(Map<String, dynamic> json) => FileModel(
        id: json['id'] as String,
        name: json['name'] as String,
        url: json['url'] as String,
        uploadedBy: json['uploadedBy'] as String,
        uploadedAt: json['uploadedAt'] != null
            ? DateTime.parse(json['uploadedAt'] as String)
            : DateTime.now(),
        associatedEntityId: json['associatedEntityId'] as String?,
        associatedEntityType: json['associatedEntityType'] as String?,
      );

  FileModel copyWith({
    String? id,
    String? name,
    String? url,
    String? uploadedBy,
    DateTime? uploadedAt,
    String? associatedEntityId,
    String? associatedEntityType,
  }) {
    return FileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      associatedEntityId: associatedEntityId ?? this.associatedEntityId,
      associatedEntityType: associatedEntityType ?? this.associatedEntityType,
    );
  }
}