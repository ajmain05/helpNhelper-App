class TransactionMethodModel {
  int? _id;
  String? _type;
  String? _bkash;
  String? _nagad;
  String? _bankName;
  String? _branchName;
  String? _routingNumber;
  String? _holderName;
  String? _accountNumber;
  int? _userId;
  String? _createdAt;
  String? _updatedAt;

  TransactionMethodModel(
      {int? id,
      String? type,
      String? bkash,
      String? nagad,
      String? bankName,
      String? branchName,
      String? routingNumber,
      String? holderName,
      String? accountNumber,
      int? userId,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (type != null) {
      this._type = type;
    }
    if (bkash != null) {
      this._bkash = bkash;
    }
    if (nagad != null) {
      this._nagad = nagad;
    }
    if (bankName != null) {
      this._bankName = bankName;
    }
    if (branchName != null) {
      this._branchName = branchName;
    }
    if (routingNumber != null) {
      this._routingNumber = routingNumber;
    }
    if (holderName != null) {
      this._holderName = holderName;
    }
    if (accountNumber != null) {
      this._accountNumber = accountNumber;
    }
    if (userId != null) {
      this._userId = userId;
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
  String? get type => _type;
  set type(String? type) => _type = type;
  String? get bkash => _bkash;
  set bkash(String? bkash) => _bkash = bkash;
  String? get nagad => _nagad;
  set nagad(String? nagad) => _nagad = nagad;
  String? get bankName => _bankName;
  set bankName(String? bankName) => _bankName = bankName;
  String? get branchName => _branchName;
  set branchName(String? branchName) => _branchName = branchName;
  String? get routingNumber => _routingNumber;
  set routingNumber(String? routingNumber) => _routingNumber = routingNumber;
  String? get holderName => _holderName;
  set holderName(String? holderName) => _holderName = holderName;
  String? get accountNumber => _accountNumber;
  set accountNumber(String? accountNumber) => _accountNumber = accountNumber;
  int? get userId => _userId;
  set userId(int? userId) => _userId = userId;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  TransactionMethodModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _type = json['type'];
    _bkash = json['bkash'];
    _nagad = json['nagad'];
    _bankName = json['bank_name'];
    _branchName = json['branch_name'];
    _routingNumber = json['routing_number'];
    _holderName = json['holder_name'];
    _accountNumber = json['account_number'];
    _userId = json['user_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['type'] = this._type;
    data['bkash'] = this._bkash;
    data['nagad'] = this._nagad;
    data['bank_name'] = this._bankName;
    data['branch_name'] = this._branchName;
    data['routing_number'] = this._routingNumber;
    data['holder_name'] = this._holderName;
    data['account_number'] = this._accountNumber;
    data['user_id'] = this._userId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
