class CampaignModel {
  int? _id;
  int? _categoryId;
  int? _seekerApplicationId;
  String? _title;
  String? _shortDescription;
  String? _longDescription;
  String? _amount;
  String? _terms;
  String? _photo;
  int? _isFeatured;
  String? _createdAt;
  String? _updatedAt;
  String? _totalRaised;
  String? _totalDonation;
  int? _totalDonors;
  Category? _category;

  CampaignModel(
      {int? id,
      int? categoryId,
      int? seekerApplicationId,
      String? title,
      String? shortDescription,
      String? longDescription,
      String? amount,
      String? terms,
      String? photo,
      int? isFeatured,
      String? createdAt,
      String? updatedAt,
      String? totalRaised,
      String? totalDonation,
      int? totalDonors,
      Category? category}) {
    if (id != null) {
      this._id = id;
    }
    if (categoryId != null) {
      this._categoryId = categoryId;
    }
    if (seekerApplicationId != null) {
      this._seekerApplicationId = seekerApplicationId;
    }
    if (title != null) {
      this._title = title;
    }
    if (shortDescription != null) {
      this._shortDescription = shortDescription;
    }
    if (longDescription != null) {
      this._longDescription = longDescription;
    }
    if (amount != null) {
      this._amount = amount;
    }
    if (terms != null) {
      this._terms = terms;
    }
    if (photo != null) {
      this._photo = photo;
    }
    if (isFeatured != null) {
      this._isFeatured = isFeatured;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (totalRaised != null) {
      this._totalRaised = totalRaised;
    }
    if (totalDonation != null) {
      this._totalDonation = totalDonation;
    }
    if (totalDonors != null) {
      this._totalDonors = totalDonors;
    }
    if (category != null) {
      this._category = category;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  int? get categoryId => _categoryId;
  set categoryId(int? categoryId) => _categoryId = categoryId;
  int? get seekerApplicationId => _seekerApplicationId;
  set seekerApplicationId(int? seekerApplicationId) =>
      _seekerApplicationId = seekerApplicationId;
  String? get title => _title;
  set title(String? title) => _title = title;
  String? get shortDescription => _shortDescription;
  set shortDescription(String? shortDescription) =>
      _shortDescription = shortDescription;
  String? get longDescription => _longDescription;
  set longDescription(String? longDescription) =>
      _longDescription = longDescription;
  String? get amount => _amount;
  set amount(String? amount) => _amount = amount;
  String? get terms => _terms;
  set terms(String? terms) => _terms = terms;
  String? get photo => _photo;
  set photo(String? photo) => _photo = photo;
  int? get isFeatured => _isFeatured;
  set isFeatured(int? isFeatured) => _isFeatured = isFeatured;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  String? get totalRaised => _totalRaised;
  set totalRaised(String? totalRaised) => _totalRaised = totalRaised;
  String? get totalDonation => _totalDonation;
  set totalDonation(String? totalDonation) => _totalDonation = totalDonation;
  int? get totalDonors => _totalDonors;
  set totalDonors(int? totalDonors) => _totalDonors = totalDonors;
  Category? get category => _category;
  set category(Category? category) => _category = category;

  CampaignModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _categoryId = json['category_id'];
    _seekerApplicationId = json['seeker_application_id'];
    _title = json['title'];
    _shortDescription = json['short_description'];
    _longDescription = json['long_description'];
    _amount = json['amount'];
    _terms = json['terms'];
    _photo = json['photo'];
    _isFeatured = json['is_featured'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _totalRaised = json['total_raised'];
    _totalDonation = json['total_donation']?.toString();
    _totalDonors = json['total_donors'];
    _category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['category_id'] = this._categoryId;
    data['seeker_application_id'] = this._seekerApplicationId;
    data['title'] = this._title;
    data['short_description'] = this._shortDescription;
    data['long_description'] = this._longDescription;
    data['amount'] = this._amount;
    data['terms'] = this._terms;
    data['photo'] = this._photo;
    data['is_featured'] = this._isFeatured;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['total_raised'] = this._totalRaised;
    data['total_donation'] = this._totalDonation;
    data['total_donors'] = this._totalDonors;
    if (this._category != null) {
      data['category'] = this._category!.toJson();
    }
    return data;
  }
}

class Category {
  int? _id;
  String? _title;
  String? _slug;
  int? _parentId;
  String? _createdAt;
  String? _updatedAt;

  Category(
      {int? id,
      String? title,
      String? slug,
      int? parentId,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (title != null) {
      this._title = title;
    }
    if (slug != null) {
      this._slug = slug;
    }
    if (parentId != null) {
      this._parentId = parentId;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get title => _title;
  set title(String? title) => _title = title;
  String? get slug => _slug;
  set slug(String? slug) => _slug = slug;
  int? get parentId => _parentId;
  set parentId(int? parentId) => _parentId = parentId;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  Category.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _slug = json['slug'];
    _parentId = json['parent_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['slug'] = this._slug;
    data['parent_id'] = this._parentId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
