class DistrictModel {
  int? _id;
  String? _name;
  int? _divisionId;
  String? _createdAt;
  String? _updatedAt;

  DistrictModel(
      {int? id,
      String? name,
      int? divisionId,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (divisionId != null) {
      this._divisionId = divisionId;
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
  String? get name => _name;
  set name(String? name) => _name = name;
  int? get divisionId => _divisionId;
  set divisionId(int? divisionId) => _divisionId = divisionId;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  DistrictModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _divisionId = json['division_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['division_id'] = this._divisionId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
