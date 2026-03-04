class SeekerHistoryModel {
  int? _id;
  int? _userId;
  String? _title;
  String? _description;
  String? _volunteerDocument;
  String? _volunteerDocumentStatus;
  String? _requestedAmount;
  String? _completionDate;
  String? _status;
  String? _createdAt;
  String? _updatedAt;
  String? _sid;
  String? _category;
  String? _document;
  String? _image;
  String? _comment;
  User? _user;

  SeekerHistoryModel(
      {int? id,
      int? userId,
      String? title,
      String? description,
      String? volunteerDocument,
      String? volunteerDocumentStatus,
      String? requestedAmount,
      String? completionDate,
      String? status,
      String? createdAt,
      String? updatedAt,
      String? sid,
      String? category,
      String? document,
      String? image,
      String? comment,
      User? user}) {
    if (id != null) {
      this._id = id;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (title != null) {
      this._title = title;
    }
    if (description != null) {
      this._description = description;
    }
    if (volunteerDocument != null) {
      this._volunteerDocument = volunteerDocument;
    }
    if (volunteerDocumentStatus != null) {
      this._volunteerDocumentStatus = volunteerDocumentStatus;
    }
    if (requestedAmount != null) {
      this._requestedAmount = requestedAmount;
    }
    if (completionDate != null) {
      this._completionDate = completionDate;
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
    if (sid != null) {
      this._sid = sid;
    }
    if (category != null) {
      this._category = category;
    }
    if (document != null) {
      this._document = document;
    }
    if (image != null) {
      this._image = image;
    }
    if (comment != null) {
      this._comment = comment;
    }
    if (user != null) {
      this._user = user;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  int? get userId => _userId;
  set userId(int? userId) => _userId = userId;
  String? get title => _title;
  set title(String? title) => _title = title;
  String? get description => _description;
  set description(String? description) => _description = description;
  String? get volunteerDocument => _volunteerDocument;
  set volunteerDocument(String? volunteerDocument) =>
      _volunteerDocument = volunteerDocument;
  String? get volunteerDocumentStatus => _volunteerDocumentStatus;
  set volunteerDocumentStatus(String? volunteerDocumentStatus) =>
      _volunteerDocumentStatus = volunteerDocumentStatus;
  String? get requestedAmount => _requestedAmount;
  set requestedAmount(String? requestedAmount) =>
      _requestedAmount = requestedAmount;
  String? get completionDate => _completionDate;
  set completionDate(String? completionDate) =>
      _completionDate = completionDate;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  String? get sid => _sid;
  set sid(String? sid) => _sid = sid;
  String? get category => _category;
  set category(String? category) => _category = category;
  String? get document => _document;
  set document(String? document) => _document = document;
  String? get image => _image;
  set image(String? image) => _image = image;
  String? get comment => _comment;
  set comment(String? comment) => _comment = comment;
  User? get user => _user;
  set user(User? user) => _user = user;

  SeekerHistoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _title = json['title'];
    _description = json['description'];
    _volunteerDocument = json['volunteer_document'];
    _volunteerDocumentStatus = json['volunteer_document_status'];
    _requestedAmount = json['requested_amount'];
    _completionDate = json['completion_date'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _sid = json['sid'];
    _category = json['category'];
    _document = json['document'];
    _image = json['image'];
    _comment = json['comment'];
    _user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['title'] = this._title;
    data['description'] = this._description;
    data['volunteer_document'] = this._volunteerDocument;
    data['volunteer_document_status'] = this._volunteerDocumentStatus;
    data['requested_amount'] = this._requestedAmount;
    data['completion_date'] = this._completionDate;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['sid'] = this._sid;
    data['category'] = this._category;
    data['document'] = this._document;
    data['image'] = this._image;
    data['comment'] = this._comment;
    if (this._user != null) {
      data['user'] = this._user!.toJson();
    }
    return data;
  }
}

class User {
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
  int? _category;
  String? _authFile;
  String? _photo;
  String? _fbLink;
  String? _emailVerifiedAt;
  String? _type;
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  User(
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
      int? category,
      String? authFile,
      String? photo,
      String? fbLink,
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
    if (fbLink != null) {
      this._fbLink = fbLink;
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
  int? get category => _category;
  set category(int? category) => _category = category;
  String? get authFile => _authFile;
  set authFile(String? authFile) => _authFile = authFile;
  String? get photo => _photo;
  set photo(String? photo) => _photo = photo;
  String? get fbLink => _fbLink;
  set fbLink(String? fbLink) => _fbLink = fbLink;
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

  User.fromJson(Map<String, dynamic> json) {
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
    _fbLink = json['fb_link'];
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
    data['fb_link'] = this._fbLink;
    data['email_verified_at'] = this._emailVerifiedAt;
    data['type'] = this._type;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
