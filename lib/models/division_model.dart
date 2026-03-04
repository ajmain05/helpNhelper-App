class DivisionModel {
  int? _id;
  String? _name;
  int? _countryId;
  String? _createdAt;
  String? _updatedAt;

  DivisionModel(
      {int? id,
      String? name,
      int? countryId,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (countryId != null) {
      this._countryId = countryId;
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
  int? get countryId => _countryId;
  set countryId(int? countryId) => _countryId = countryId;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  DivisionModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _countryId = json['country_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['country_id'] = this._countryId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
