class CorporateWalletData {
  final bool success;
  final CorporateWallet wallet;
  final List<CorporateAllocation> allocations;

  CorporateWalletData({
    required this.success,
    required this.wallet,
    required this.allocations,
  });

  factory CorporateWalletData.fromJson(Map<String, dynamic> json) {
    return CorporateWalletData(
      success: json['success'] ?? false,
      wallet: CorporateWallet.fromJson(json['wallet'] ?? {}),
      allocations: (json['allocations'] as List?)
              ?.map((e) => CorporateAllocation.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CorporateWallet {
  final double totalDeposited;
  final double balance;

  CorporateWallet({required this.totalDeposited, required this.balance});

  factory CorporateWallet.fromJson(Map<String, dynamic> json) {
    return CorporateWallet(
      totalDeposited:
          double.tryParse(json['total_deposited']?.toString() ?? '0') ?? 0.0,
      balance: double.tryParse(json['balance']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class CorporateAllocation {
  final int id;
  final double amount;
  final String allocatedAt;
  final AllocatedCampaign campaign;

  CorporateAllocation({
    required this.id,
    required this.amount,
    required this.allocatedAt,
    required this.campaign,
  });

  factory CorporateAllocation.fromJson(Map<String, dynamic> json) {
    return CorporateAllocation(
      id: json['id'] ?? 0,
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      allocatedAt: json['allocated_at'] ?? '',
      campaign: AllocatedCampaign.fromJson(json['campaign'] ?? {}),
    );
  }
}

class AllocatedCampaign {
  final int? id;
  final String title;
  final String? image;

  AllocatedCampaign({
    this.id,
    required this.title,
    this.image,
  });

  factory AllocatedCampaign.fromJson(Map<String, dynamic> json) {
    return AllocatedCampaign(
      id: json['id'],
      title: json['title'] ?? 'Unknown Campaign',
      image: json['image'],
    );
  }
}

// ── Deposit Records (SSLCommerz + Cheque) ─────────────────────────────────
class CorporateDepositRecord {
  final int id;
  final double amount;
  final String method;
  final String status;
  final String? transactionId;
  final String? chequeNo;
  final String? bankName;
  final String? adminNote;
  final String createdAt;

  CorporateDepositRecord({
    required this.id,
    required this.amount,
    required this.method,
    required this.status,
    this.transactionId,
    this.chequeNo,
    this.bankName,
    this.adminNote,
    required this.createdAt,
  });

  factory CorporateDepositRecord.fromJson(Map<String, dynamic> json) {
    return CorporateDepositRecord(
      id: json['id'] ?? 0,
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      method: json['method'] ?? 'sslcommerz',
      status: json['status'] ?? 'pending',
      transactionId: json['transaction_id'],
      chequeNo: json['cheque_no'],
      bankName: json['bank_name'],
      adminNote: json['admin_note'],
      createdAt: json['created_at'] ?? '',
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isUnderReview => status == 'under_review';
  bool get isRejected => status == 'rejected';
  bool get isCheque => method == 'offline';
}
