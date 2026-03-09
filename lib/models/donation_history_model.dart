class DonationHistoryModel {
  int? id;
  String? userId;
  String? campaignId;
  String? amount;
  String? paymentMethod;
  String? trxId;
  String? status;
  String? isAnonymous;
  String? createdAt;
  String? updatedAt;
  CampaignObject? campaign;

  DonationHistoryModel({
    this.id,
    this.userId,
    this.campaignId,
    this.amount,
    this.paymentMethod,
    this.trxId,
    this.status,
    this.isAnonymous,
    this.createdAt,
    this.updatedAt,
    this.campaign,
  });

  DonationHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id']?.toString();
    campaignId = json['campaign_id']?.toString();
    amount = json['amount']?.toString();
    paymentMethod = json['payment_method']?.toString();
    trxId = json['trx_id']?.toString();
    status = json['status']?.toString();
    isAnonymous = json['is_anonymous']?.toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    campaign = json['campaign'] != null
        ? CampaignObject.fromJson(json['campaign'])
        : null;
  }
}

class CampaignObject {
  int? id;
  String? categoryId;
  String? title;
  String? shortDescription;
  String? description;
  String? coverPhoto;
  String? amount; // target goal
  String? totalRaised;
  String? totalDonors;
  String? address;
  String? video;
  String? isFeatured;
  String? status;
  String? completionDate;
  String? createdBy;
  String? createdAt;

  CampaignObject({
    this.id,
    this.categoryId,
    this.title,
    this.shortDescription,
    this.description,
    this.coverPhoto,
    this.amount,
    this.totalRaised,
    this.totalDonors,
    this.address,
    this.video,
    this.isFeatured,
    this.status,
    this.completionDate,
    this.createdBy,
    this.createdAt,
  });

  CampaignObject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id']?.toString();
    title = json['title'];
    shortDescription = json['short_description'];
    description = json['description'];
    coverPhoto = json['cover_photo'];
    amount = json['amount']?.toString();
    totalRaised = json['total_raised']?.toString();
    totalDonors = json['total_donors']?.toString();
    address = json['address'];
    video = json['video'];
    isFeatured = json['is_featured']?.toString();
    status = json['status']?.toString();
    completionDate = json['completion_date'];
    createdBy = json['created_by']?.toString();
    createdAt = json['created_at'];
  }
}
