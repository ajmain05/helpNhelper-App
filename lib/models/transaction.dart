class TransactionModel {
  int? _id;
  String? _receiverType;
  String? _date;
  String? _amount;
  String? _referenceNumber;
  String? _remarks;
  int? _status;
  String? _type;
  String? _subType;
  int? _campaignId;
  int? _invoiceId;
  int? _transactionCategoryId;
  int? _transactionModeId;
  int? _bankId;
  int? _bankAccountId;
  int? _volunteerId;
  int? _createdBy;
  int? _donorId;
  String? _name;
  String? _mobile;
  String? _createdAt;
  String? _updatedAt;
  String? _volunteerPaymentType;
  String? _receiveStatus;
  int? _userBankId;
  BankInfo? _bankInfo;
  BankAccountInfo? _bankAccountInfo;
  UserBank? _userBank;
  Invoice? _invoice;
  Null? _campaignInfo;
  int? _transactionCategory;
  TransactionMode? _transactionMode;

  TransactionModel(
      {int? id,
      String? receiverType,
      String? date,
      String? amount,
      String? referenceNumber,
      String? remarks,
      int? status,
      String? type,
      String? subType,
      int? campaignId,
      int? invoiceId,
      int? transactionCategoryId,
      int? transactionModeId,
      int? bankId,
      int? bankAccountId,
      int? volunteerId,
      int? createdBy,
      int? donorId,
      String? name,
      String? mobile,
      String? createdAt,
      String? updatedAt,
      String? volunteerPaymentType,
      String? receiveStatus,
      int? userBankId,
      BankInfo? bankInfo,
      BankAccountInfo? bankAccountInfo,
      UserBank? userBank,
      Invoice? invoice,
      Null? campaignInfo,
      int? transactionCategory,
      TransactionMode? transactionMode}) {
    if (id != null) {
      this._id = id;
    }
    if (receiverType != null) {
      this._receiverType = receiverType;
    }
    if (date != null) {
      this._date = date;
    }
    if (amount != null) {
      this._amount = amount;
    }
    if (referenceNumber != null) {
      this._referenceNumber = referenceNumber;
    }
    if (remarks != null) {
      this._remarks = remarks;
    }
    if (status != null) {
      this._status = status;
    }
    if (type != null) {
      this._type = type;
    }
    if (subType != null) {
      this._subType = subType;
    }
    if (campaignId != null) {
      this._campaignId = campaignId;
    }
    if (invoiceId != null) {
      this._invoiceId = invoiceId;
    }
    if (transactionCategoryId != null) {
      this._transactionCategoryId = transactionCategoryId;
    }
    if (transactionModeId != null) {
      this._transactionModeId = transactionModeId;
    }
    if (bankId != null) {
      this._bankId = bankId;
    }
    if (bankAccountId != null) {
      this._bankAccountId = bankAccountId;
    }
    if (volunteerId != null) {
      this._volunteerId = volunteerId;
    }
    if (createdBy != null) {
      this._createdBy = createdBy;
    }
    if (donorId != null) {
      this._donorId = donorId;
    }
    if (name != null) {
      this._name = name;
    }
    if (mobile != null) {
      this._mobile = mobile;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (volunteerPaymentType != null) {
      this._volunteerPaymentType = volunteerPaymentType;
    }
    if (receiveStatus != null) {
      this._receiveStatus = receiveStatus;
    }
    if (userBankId != null) {
      this._userBankId = userBankId;
    }
    if (bankInfo != null) {
      this._bankInfo = bankInfo;
    }
    if (bankAccountInfo != null) {
      this._bankAccountInfo = bankAccountInfo;
    }
    if (userBank != null) {
      this._userBank = userBank;
    }
    if (invoice != null) {
      this._invoice = invoice;
    }
    if (campaignInfo != null) {
      this._campaignInfo = campaignInfo;
    }
    if (transactionCategory != null) {
      this._transactionCategory = transactionCategory;
    }
    if (transactionMode != null) {
      this._transactionMode = transactionMode;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get receiverType => _receiverType;
  set receiverType(String? receiverType) => _receiverType = receiverType;
  String? get date => _date;
  set date(String? date) => _date = date;
  String? get amount => _amount;
  set amount(String? amount) => _amount = amount;
  String? get referenceNumber => _referenceNumber;
  set referenceNumber(String? referenceNumber) =>
      _referenceNumber = referenceNumber;
  String? get remarks => _remarks;
  set remarks(String? remarks) => _remarks = remarks;
  int? get status => _status;
  set status(int? status) => _status = status;
  String? get type => _type;
  set type(String? type) => _type = type;
  String? get subType => _subType;
  set subType(String? subType) => _subType = subType;
  int? get campaignId => _campaignId;
  set campaignId(int? campaignId) => _campaignId = campaignId;
  int? get invoiceId => _invoiceId;
  set invoiceId(int? invoiceId) => _invoiceId = invoiceId;
  int? get transactionCategoryId => _transactionCategoryId;
  set transactionCategoryId(int? transactionCategoryId) =>
      _transactionCategoryId = transactionCategoryId;
  int? get transactionModeId => _transactionModeId;
  set transactionModeId(int? transactionModeId) =>
      _transactionModeId = transactionModeId;
  int? get bankId => _bankId;
  set bankId(int? bankId) => _bankId = bankId;
  int? get bankAccountId => _bankAccountId;
  set bankAccountId(int? bankAccountId) => _bankAccountId = bankAccountId;
  int? get volunteerId => _volunteerId;
  set volunteerId(int? volunteerId) => _volunteerId = volunteerId;
  int? get createdBy => _createdBy;
  set createdBy(int? createdBy) => _createdBy = createdBy;
  int? get donorId => _donorId;
  set donorId(int? donorId) => _donorId = donorId;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get mobile => _mobile;
  set mobile(String? mobile) => _mobile = mobile;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  String? get volunteerPaymentType => _volunteerPaymentType;
  set volunteerPaymentType(String? volunteerPaymentType) =>
      _volunteerPaymentType = volunteerPaymentType;
  String? get receiveStatus => _receiveStatus;
  set receiveStatus(String? receiveStatus) => _receiveStatus = receiveStatus;
  int? get userBankId => _userBankId;
  set userBankId(int? userBankId) => _userBankId = userBankId;
  BankInfo? get bankInfo => _bankInfo;
  set bankInfo(BankInfo? bankInfo) => _bankInfo = bankInfo;
  BankAccountInfo? get bankAccountInfo => _bankAccountInfo;
  set bankAccountInfo(BankAccountInfo? bankAccountInfo) =>
      _bankAccountInfo = bankAccountInfo;
  UserBank? get userBank => _userBank;
  set userBank(UserBank? userBank) => _userBank = userBank;
  Invoice? get invoice => _invoice;
  set invoice(Invoice? invoice) => _invoice = invoice;
  Null? get campaignInfo => _campaignInfo;
  set campaignInfo(Null? campaignInfo) => _campaignInfo = campaignInfo;
  int? get transactionCategory => _transactionCategory;
  set transactionCategory(int? transactionCategory) =>
      _transactionCategory = transactionCategory;
  TransactionMode? get transactionMode => _transactionMode;
  set transactionMode(TransactionMode? transactionMode) =>
      _transactionMode = transactionMode;

  TransactionModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _receiverType = json['receiver_type'];
    _date = json['date'];
    _amount = json['amount'];
    _referenceNumber = json['reference_number'];
    _remarks = json['remarks'];
    _status = json['status'];
    _type = json['type'];
    _subType = json['sub_type'];
    _campaignId = json['campaign_id'];
    _invoiceId = json['invoice_id'];
    _transactionCategoryId = json['transaction_category_id'];
    _transactionModeId = json['transaction_mode_id'];
    _bankId = json['bank_id'];
    _bankAccountId = json['bank_account_id'];
    _volunteerId = json['volunteer_id'];
    _createdBy = json['created_by'];
    _donorId = json['donor_id'];
    _name = json['name'];
    _mobile = json['mobile'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _volunteerPaymentType = json['volunteer_payment_type'];
    _receiveStatus = json['receive_status'];
    _userBankId = json['user_bank_id'];
    _bankInfo = json['bank_info'] != null
        ? new BankInfo.fromJson(json['bank_info'])
        : null;
    _bankAccountInfo = json['bank_account_info'] != null
        ? new BankAccountInfo.fromJson(json['bank_account_info'])
        : null;
    _userBank = json['user_bank'] != null
        ? new UserBank.fromJson(json['user_bank'])
        : null;
    _invoice =
        json['invoice'] != null ? new Invoice.fromJson(json['invoice']) : null;
    _campaignInfo = json['campaign_info'];
    _transactionCategory = json['transaction_category'];
    _transactionMode = json['transaction_mode'] != null
        ? new TransactionMode.fromJson(json['transaction_mode'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['receiver_type'] = this._receiverType;
    data['date'] = this._date;
    data['amount'] = this._amount;
    data['reference_number'] = this._referenceNumber;
    data['remarks'] = this._remarks;
    data['status'] = this._status;
    data['type'] = this._type;
    data['sub_type'] = this._subType;
    data['campaign_id'] = this._campaignId;
    data['invoice_id'] = this._invoiceId;
    data['transaction_category_id'] = this._transactionCategoryId;
    data['transaction_mode_id'] = this._transactionModeId;
    data['bank_id'] = this._bankId;
    data['bank_account_id'] = this._bankAccountId;
    data['volunteer_id'] = this._volunteerId;
    data['created_by'] = this._createdBy;
    data['donor_id'] = this._donorId;
    data['name'] = this._name;
    data['mobile'] = this._mobile;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['volunteer_payment_type'] = this._volunteerPaymentType;
    data['receive_status'] = this._receiveStatus;
    data['user_bank_id'] = this._userBankId;
    if (this._bankInfo != null) {
      data['bank_info'] = this._bankInfo!.toJson();
    }
    if (this._bankAccountInfo != null) {
      data['bank_account_info'] = this._bankAccountInfo!.toJson();
    }
    if (this._userBank != null) {
      data['user_bank'] = this._userBank!.toJson();
    }
    if (this._invoice != null) {
      data['invoice'] = this._invoice!.toJson();
    }
    data['campaign_info'] = this._campaignInfo;
    data['transaction_category'] = this._transactionCategory;
    if (this._transactionMode != null) {
      data['transaction_mode'] = this._transactionMode!.toJson();
    }
    return data;
  }
}

class BankInfo {
  int? _id;
  int? _createdBy;
  String? _name;
  String? _logo;
  String? _createdAt;
  String? _updatedAt;

  BankInfo(
      {int? id,
      int? createdBy,
      String? name,
      String? logo,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (createdBy != null) {
      this._createdBy = createdBy;
    }
    if (name != null) {
      this._name = name;
    }
    if (logo != null) {
      this._logo = logo;
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
  int? get createdBy => _createdBy;
  set createdBy(int? createdBy) => _createdBy = createdBy;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get logo => _logo;
  set logo(String? logo) => _logo = logo;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  BankInfo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _createdBy = json['created_by'];
    _name = json['name'];
    _logo = json['logo'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['created_by'] = this._createdBy;
    data['name'] = this._name;
    data['logo'] = this._logo;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}

class BankAccountInfo {
  int? _id;
  int? _bankId;
  int? _createdBy;
  String? _branchName;
  String? _accountNumber;
  String? _openingBalance;
  String? _currentBalance;
  String? _remarks;
  String? _createdAt;
  String? _updatedAt;

  BankAccountInfo(
      {int? id,
      int? bankId,
      int? createdBy,
      String? branchName,
      String? accountNumber,
      String? openingBalance,
      String? currentBalance,
      String? remarks,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (bankId != null) {
      this._bankId = bankId;
    }
    if (createdBy != null) {
      this._createdBy = createdBy;
    }
    if (branchName != null) {
      this._branchName = branchName;
    }
    if (accountNumber != null) {
      this._accountNumber = accountNumber;
    }
    if (openingBalance != null) {
      this._openingBalance = openingBalance;
    }
    if (currentBalance != null) {
      this._currentBalance = currentBalance;
    }
    if (remarks != null) {
      this._remarks = remarks;
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
  int? get bankId => _bankId;
  set bankId(int? bankId) => _bankId = bankId;
  int? get createdBy => _createdBy;
  set createdBy(int? createdBy) => _createdBy = createdBy;
  String? get branchName => _branchName;
  set branchName(String? branchName) => _branchName = branchName;
  String? get accountNumber => _accountNumber;
  set accountNumber(String? accountNumber) => _accountNumber = accountNumber;
  String? get openingBalance => _openingBalance;
  set openingBalance(String? openingBalance) =>
      _openingBalance = openingBalance;
  String? get currentBalance => _currentBalance;
  set currentBalance(String? currentBalance) =>
      _currentBalance = currentBalance;
  String? get remarks => _remarks;
  set remarks(String? remarks) => _remarks = remarks;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  BankAccountInfo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _bankId = json['bank_id'];
    _createdBy = json['created_by'];
    _branchName = json['branch_name'];
    _accountNumber = json['account_number'];
    _openingBalance = json['opening_balance'];
    _currentBalance = json['current_balance'];
    _remarks = json['remarks'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['bank_id'] = this._bankId;
    data['created_by'] = this._createdBy;
    data['branch_name'] = this._branchName;
    data['account_number'] = this._accountNumber;
    data['opening_balance'] = this._openingBalance;
    data['current_balance'] = this._currentBalance;
    data['remarks'] = this._remarks;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}

class UserBank {
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

  UserBank(
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

  UserBank.fromJson(Map<String, dynamic> json) {
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

class Invoice {
  int? _id;
  int? _campaignId;
  String? _sid;
  int? _status;
  String? _date;
  int? _createdBy;
  String? _createdAt;
  String? _updatedAt;

  Invoice(
      {int? id,
      int? campaignId,
      String? sid,
      int? status,
      String? date,
      int? createdBy,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (campaignId != null) {
      this._campaignId = campaignId;
    }
    if (sid != null) {
      this._sid = sid;
    }
    if (status != null) {
      this._status = status;
    }
    if (date != null) {
      this._date = date;
    }
    if (createdBy != null) {
      this._createdBy = createdBy;
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
  int? get campaignId => _campaignId;
  set campaignId(int? campaignId) => _campaignId = campaignId;
  String? get sid => _sid;
  set sid(String? sid) => _sid = sid;
  int? get status => _status;
  set status(int? status) => _status = status;
  String? get date => _date;
  set date(String? date) => _date = date;
  int? get createdBy => _createdBy;
  set createdBy(int? createdBy) => _createdBy = createdBy;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  Invoice.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _campaignId = json['campaign_id'];
    _sid = json['sid'];
    _status = json['status'];
    _date = json['date'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['campaign_id'] = this._campaignId;
    data['sid'] = this._sid;
    data['status'] = this._status;
    data['date'] = this._date;
    data['created_by'] = this._createdBy;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}

class TransactionMode {
  int? _id;
  String? _name;
  int? _createdBy;
  String? _createdAt;
  String? _updatedAt;
  String? _type;

  TransactionMode(
      {int? id,
      String? name,
      int? createdBy,
      String? createdAt,
      String? updatedAt,
      String? type}) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (createdBy != null) {
      this._createdBy = createdBy;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (type != null) {
      this._type = type;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  int? get createdBy => _createdBy;
  set createdBy(int? createdBy) => _createdBy = createdBy;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  String? get type => _type;
  set type(String? type) => _type = type;

  TransactionMode.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['created_by'] = this._createdBy;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['type'] = this._type;
    return data;
  }
}
