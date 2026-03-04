class UpazilaModel {
  int? _id;
  String? _name;
  int? _districtId;
  String? _createdAt;
  String? _updatedAt;

  UpazilaModel(
      {int? id,
      String? name,
      int? districtId,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (districtId != null) {
      this._districtId = districtId;
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
  int? get districtId => _districtId;
  set districtId(int? districtId) => _districtId = districtId;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  UpazilaModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _districtId = json['district_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['district_id'] = this._districtId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
