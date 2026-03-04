class UserModel {
  int? _id;
  String? _sid;
  String? _name;
  String? _email;
  String? _mobile;
  int? _upazilaId;
  String? _permanentAddress;
  String? _presentAddress;
  String? _officeAddress;
  String? _licenseNo;
  String? _licenseImage;
  String? _category;
  String? _authFile;
  String? _photo;
  String? _emailVerifiedAt;
  String? _type;
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  UserModel(
      {int? id,
      String? sid,
      String? name,
      String? email,
      String? mobile,
      int? upazilaId,
      String? permanentAddress,
      String? presentAddress,
      String? officeAddress,
      String? licenseNo,
      String? licenseImage,
      String? category,
      String? authFile,
      String? photo,
      String? emailVerifiedAt,
      String? type,
      String? status,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (sid != null) {
      this._sid = sid;
    }
    if (name != null) {
      this._name = name;
    }
    if (email != null) {
      this._email = email;
    }
    if (mobile != null) {
      this._mobile = mobile;
    }
    if (upazilaId != null) {
      this._upazilaId = upazilaId;
    }
    if (permanentAddress != null) {
      this._permanentAddress = permanentAddress;
    }
    if (presentAddress != null) {
      this._presentAddress = presentAddress;
    }
    if (officeAddress != null) {
      this._officeAddress = officeAddress;
    }
    if (licenseNo != null) {
      this._licenseNo = licenseNo;
    }
    if (licenseImage != null) {
      this._licenseImage = licenseImage;
    }
    if (category != null) {
      this._category = category;
    }
    if (authFile != null) {
      this._authFile = authFile;
    }
    if (photo != null) {
      this._photo = photo;
    }
    if (emailVerifiedAt != null) {
      this._emailVerifiedAt = emailVerifiedAt;
    }
    if (type != null) {
      this._type = type;
    }
    if (status != null) {
      this._status = status;
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
  String? get sid => _sid;
  set sid(String? sid) => _sid = sid;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get mobile => _mobile;
  set mobile(String? mobile) => _mobile = mobile;
  int? get upazilaId => _upazilaId;
  set upazilaId(int? upazilaId) => _upazilaId = upazilaId;
  String? get permanentAddress => _permanentAddress;
  set permanentAddress(String? permanentAddress) =>
      _permanentAddress = permanentAddress;
  String? get presentAddress => _presentAddress;
  set presentAddress(String? presentAddress) =>
      _presentAddress = presentAddress;
  String? get officeAddress => _officeAddress;
  set officeAddress(String? officeAddress) => _officeAddress = officeAddress;
  String? get licenseNo => _licenseNo;
  set licenseNo(String? licenseNo) => _licenseNo = licenseNo;
  String? get licenseImage => _licenseImage;
  set licenseImage(String? licenseImage) => _licenseImage = licenseImage;
  String? get category => _category;
  set category(String? category) => _category = category;
  String? get authFile => _authFile;
  set authFile(String? authFile) => _authFile = authFile;
  String? get photo => _photo;
  set photo(String? photo) => _photo = photo;
  String? get emailVerifiedAt => _emailVerifiedAt;
  set emailVerifiedAt(String? emailVerifiedAt) =>
      _emailVerifiedAt = emailVerifiedAt;
  String? get type => _type;
  set type(String? type) => _type = type;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  UserModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _sid = json['sid'];
    _name = json['name'];
    _email = json['email'];
    _mobile = json['mobile'];
    _upazilaId = json['upazila_id'];
    _permanentAddress = json['permanent_address'];
    _presentAddress = json['present_address'];
    _officeAddress = json['office_address'];
    _licenseNo = json['license_no'];
    _licenseImage = json['license_image'];
    _category = json['category'];
    _authFile = json['auth_file'];
    _photo = json['photo'];
    _emailVerifiedAt = json['email_verified_at'];
    _type = json['type'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['sid'] = this._sid;
    data['name'] = this._name;
    data['email'] = this._email;
    data['mobile'] = this._mobile;
    data['upazila_id'] = this._upazilaId;
    data['permanent_address'] = this._permanentAddress;
    data['present_address'] = this._presentAddress;
    data['office_address'] = this._officeAddress;
    data['license_no'] = this._licenseNo;
    data['license_image'] = this._licenseImage;
    data['category'] = this._category;
    data['auth_file'] = this._authFile;
    data['photo'] = this._photo;
    data['email_verified_at'] = this._emailVerifiedAt;
    data['type'] = this._type;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
