class CampaignCategoryModel {
  int? _id;
  String? _title;
  String? _slug;
  int? _parentId;
  String? _createdAt;
  String? _updatedAt;
  ParentCategory? _parentCategory;

  CampaignCategoryModel(
      {int? id,
      String? title,
      String? slug,
      int? parentId,
      String? createdAt,
      String? updatedAt,
      ParentCategory? parentCategory}) {
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
    if (parentCategory != null) {
      this._parentCategory = parentCategory;
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
  ParentCategory? get parentCategory => _parentCategory;
  set parentCategory(ParentCategory? parentCategory) =>
      _parentCategory = parentCategory;

  CampaignCategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _slug = json['slug'];
    _parentId = json['parent_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _parentCategory = json['parent_category'] != null
        ? new ParentCategory.fromJson(json['parent_category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['slug'] = this._slug;
    data['parent_id'] = this._parentId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    if (this._parentCategory != null) {
      data['parent_category'] = this._parentCategory!.toJson();
    }
    return data;
  }
}

class ParentCategory {
  int? _id;
  String? _title;
  String? _slug;
  Null? _parentId;
  String? _createdAt;
  String? _updatedAt;

  ParentCategory(
      {int? id,
      String? title,
      String? slug,
      Null? parentId,
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
  Null? get parentId => _parentId;
  set parentId(Null? parentId) => _parentId = parentId;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  ParentCategory.fromJson(Map<String, dynamic> json) {
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
