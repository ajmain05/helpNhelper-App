class OrgApplicationModel {
  int? id;
  int? userId;
  String? title;
  String? description;
  String? category;
  double? targetAmount;
  double? collectedAmount;
  String? seekerName;
  String? seekerLocation;
  String? paymentMethod;
  String? paymentAccount;
  String? certImage;
  String? status;
  double? serviceChargePct;
  double? netAmountPayable;
  int? assignedVolunteerId;
  int? approvedBy;
  String? rejectionReason;
  String? createdAt;
  String? updatedAt;
  double? progress;

  OrgApplicationModel({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.category,
    this.targetAmount,
    this.collectedAmount,
    this.seekerName,
    this.seekerLocation,
    this.paymentMethod,
    this.paymentAccount,
    this.certImage,
    this.status,
    this.serviceChargePct,
    this.netAmountPayable,
    this.assignedVolunteerId,
    this.approvedBy,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
    this.progress,
  });

  OrgApplicationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    category = json['category'];
    targetAmount = json['requested_amount'] != null ? double.parse(json['requested_amount'].toString()) : 0.0;
    collectedAmount = json['collected_amount'] != null ? double.parse(json['collected_amount'].toString()) : 0.0;
    seekerName = json['seeker_name'];
    seekerLocation = json['seeker_location'];
    paymentMethod = json['payment_method'];
    paymentAccount = json['payment_account'];
    certImage = json['cert_image'];
    status = json['status'];
    serviceChargePct = json['service_charge_pct'] != null ? double.parse(json['service_charge_pct'].toString()) : 7.0;
    netAmountPayable = json['net_amount_payable'] != null ? double.parse(json['net_amount_payable'].toString()) : 0.0;
    assignedVolunteerId = json['assigned_volunteer_id'];
    approvedBy = json['approved_by'];
    rejectionReason = json['rejection_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    progress = json['progress'] != null ? double.parse(json['progress'].toString()) : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['category'] = category;
    data['target_amount'] = targetAmount;
    data['collected_amount'] = collectedAmount;
    data['seeker_name'] = seekerName;
    data['seeker_location'] = seekerLocation;
    data['payment_method'] = paymentMethod;
    data['payment_account'] = paymentAccount;
    data['cert_image'] = certImage;
    data['status'] = status;
    data['service_charge_pct'] = serviceChargePct;
    data['net_amount_payable'] = netAmountPayable;
    data['assigned_volunteer_id'] = assignedVolunteerId;
    data['approved_by'] = approvedBy;
    data['rejection_reason'] = rejectionReason;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['progress'] = progress;
    return data;
  }
}
