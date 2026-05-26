class TenancyModel {
  String propertyId;
  String tenantId;
  String status;

  TenancyModel({
    required this.propertyId,
    required this.tenantId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {"propertyId": propertyId, "tenantId": tenantId, "status": status};
  }
}
