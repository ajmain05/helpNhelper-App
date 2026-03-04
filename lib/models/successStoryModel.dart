class SuccessStoryModel {
  int? _id;
  String? _title;
  String? _shortDescription;
  String? _longDescription;
  String? _photo;
  String? _previousCondition;
  String? _presentCondition;
  int? _campaignId;
  String? _createdAt;
  String? _updatedAt;

  SuccessStoryModel(
      {int? id,
      String? title,
      String? shortDescription,
      String? longDescription,
      String? photo,
      String? previousCondition,
      String? presentCondition,
      int? campaignId,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      this._id = id;
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
    if (photo != null) {
      this._photo = photo;
    }
    if (previousCondition != null) {
      this._previousCondition = previousCondition;
    }
    if (presentCondition != null) {
      this._presentCondition = presentCondition;
    }
    if (campaignId != null) {
      this._campaignId = campaignId;
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
  String? get shortDescription => _shortDescription;
  set shortDescription(String? shortDescription) =>
      _shortDescription = shortDescription;
  String? get longDescription => _longDescription;
  set longDescription(String? longDescription) =>
      _longDescription = longDescription;
  String? get photo => _photo;
  set photo(String? photo) => _photo = photo;
  String? get previousCondition => _previousCondition;
  set previousCondition(String? previousCondition) =>
      _previousCondition = previousCondition;
  String? get presentCondition => _presentCondition;
  set presentCondition(String? presentCondition) =>
      _presentCondition = presentCondition;
  int? get campaignId => _campaignId;
  set campaignId(int? campaignId) => _campaignId = campaignId;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  SuccessStoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _shortDescription = json['short_description'];
    _longDescription = json['long_description'];
    _photo = json['photo'];
    _previousCondition = json['previous_condition'];
    _presentCondition = json['present_condition'];
    _campaignId = json['campaign_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['short_description'] = this._shortDescription;
    data['long_description'] = this._longDescription;
    data['photo'] = this._photo;
    data['previous_condition'] = this._previousCondition;
    data['present_condition'] = this._presentCondition;
    data['campaign_id'] = this._campaignId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
